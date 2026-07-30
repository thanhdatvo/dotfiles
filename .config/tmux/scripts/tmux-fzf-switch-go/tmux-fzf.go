package main

import (
	"bufio"
	"bytes"
	"errors"
	"fmt"
	"io"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

const (
	paneFormat = "#{session_id}\t#{window_id}\t#{pane_id}\t" +
		"#{session_name} › #{window_name} › pane #{pane_index}\t" +
		"#{pane_current_command}\t#{pane_current_path}"
)

type Selection struct {
	SessionID string
	WindowID  string
	PaneID    string
}

func main() {
	if err := requireCommands("tmux", "fzf"); err != nil {
		fatal(err)
	}

	for tmuxHasWindows() {
		key, selection, err := runFinder()
		if err != nil {
			// Esc and Ctrl-C cause fzf to exit with a nonzero status.
			return
		}

		if key == "ctrl-n" {
			if err := createSession(); err != nil {
				pauseWithMessage(err.Error())
			}
			continue
		}

		if selection == nil {
			continue
		}

		switch key {
		case "ctrl-w":
			if err := createWindow(*selection); err != nil {
				pauseWithMessage(err.Error())
			}

		case "ctrl-d":
			if err := deleteWindow(selection.WindowID); err != nil {
				pauseWithMessage(err.Error())
			}

		case "ctrl-r":
			if err := renameWindow(selection.WindowID); err != nil {
				pauseWithMessage(err.Error())
			}

		case "ctrl-s":
			if err := renameSession(selection.SessionID); err != nil {
				pauseWithMessage(err.Error())
			}

		case "", "enter":
			if err := runTmux("switch-client", "-t", selection.PaneID); err != nil {
				pauseWithMessage(err.Error())
				continue
			}
			return
		}
	}

	_ = runTmux("kill-server")
}

func runFinder() (string, *Selection, error) {
	listCommand := exec.Command("tmux", "list-panes", "-a", "-F", paneFormat)

	fzfCommand := exec.Command(
		"fzf",
		"--expect=enter,ctrl-d,ctrl-r,ctrl-s,ctrl-n,ctrl-w",
		"--delimiter=\t",
		"--with-nth=4,5,6,7",
		"--prompt=tmux ❯ ",
		"--header=Enter: switch │ Ctrl-n: new session │ Ctrl-w: new window │ Ctrl-r: rename window │ Ctrl-s: rename session │ Ctrl-d: delete window",
		"--border",
		"--color=border:0,preview-border:0",
		"--reverse",
		"--height=100%",
		"--preview=tmux capture-pane -ep -t {3} -S -200",
		"--preview-window=right,60%,wrap",
	)

	pipe, err := listCommand.StdoutPipe()
	if err != nil {
		return "", nil, err
	}

	fzfCommand.Stdin = pipe
	fzfCommand.Stderr = os.Stderr

	var output bytes.Buffer
	fzfCommand.Stdout = &output

	if err := listCommand.Start(); err != nil {
		return "", nil, err
	}

	if err := fzfCommand.Start(); err != nil {
		_ = listCommand.Process.Kill()
		return "", nil, err
	}

	fzfErr := fzfCommand.Wait()
	listErr := listCommand.Wait()

	if fzfErr != nil {
		return "", nil, fzfErr
	}
	if listErr != nil {
		return "", nil, listErr
	}

	lines := strings.Split(
		strings.TrimSuffix(output.String(), "\n"),
		"\n",
	)

	if len(lines) == 0 {
		return "", nil, nil
	}

	key := lines[0]

	// Ctrl-n can be used without selecting an entry.
	if len(lines) < 2 || strings.TrimSpace(lines[1]) == "" {
		return key, nil, nil
	}

	fields := strings.Split(lines[1], "\t")
	if len(fields) < 3 {
		return "", nil, fmt.Errorf("unexpected fzf result: %q", lines[1])
	}

	return key, &Selection{
		SessionID: fields[0],
		WindowID:  fields[1],
		PaneID:    fields[2],
	}, nil
}

func createSession() error {
	name, err := promptValue("New session name", "")
	if err != nil {
		return err
	}

	name = strings.TrimSpace(name)
	if name == "" {
		return nil
	}

	if sessionExists(name) {
		return fmt.Errorf("session %q already exists", name)
	}

	home, err := os.UserHomeDir()
	if err != nil {
		return fmt.Errorf("find home directory: %w", err)
	}

	startDirectory, err := promptValue("Starting directory", home)
	if err != nil {
		return err
	}

	startDirectory, err = validateDirectory(startDirectory)
	if err != nil {
		return err
	}

	if err := runTmux(
		"new-session",
		"-d",
		"-s", name,
		"-c", startDirectory,
	); err != nil {
		return err
	}

	if err := runTmux("switch-client", "-t", "="+name); err != nil {
		return err
	}

	os.Exit(0)
	return nil
}

func createWindow(selection Selection) error {
	currentDirectory, err := tmuxOutput(
		"display-message",
		"-p",
		"-t", selection.PaneID,
		"#{pane_current_path}",
	)
	if err != nil {
		return err
	}

	windowName, err := promptValue("New window name", "")
	if err != nil {
		return err
	}

	startDirectory, err := promptValue(
		"Starting directory",
		currentDirectory,
	)
	if err != nil {
		return err
	}

	startDirectory, err = validateDirectory(startDirectory)
	if err != nil {
		return err
	}

	args := []string{
		"new-window",
		"-d",
		"-P",
		"-F", "#{pane_id}",
		"-t", selection.SessionID,
		"-c", startDirectory,
	}

	if strings.TrimSpace(windowName) != "" {
		args = append(args, "-n", windowName)
	}

	newPaneID, err := tmuxOutput(args...)
	if err != nil {
		return err
	}

	if err := runTmux("switch-client", "-t", newPaneID); err != nil {
		return err
	}

	os.Exit(0)
	return nil
}

func renameWindow(windowID string) error {
	currentName, err := tmuxOutput(
		"display-message",
		"-p",
		"-t", windowID,
		"#{window_name}",
	)
	if err != nil {
		return err
	}

	newName, err := promptValue("Rename window", currentName)
	if err != nil {
		return err
	}

	newName = strings.TrimSpace(newName)
	if newName == "" || newName == currentName {
		return nil
	}

	if err := runTmux("rename-window", "-t", windowID, newName); err != nil {
		return err
	}

	return runTmux(
		"set-option",
		"-w",
		"-t", windowID,
		"automatic-rename",
		"off",
	)
}

func renameSession(sessionID string) error {
	currentName, err := tmuxOutput(
		"display-message",
		"-p",
		"-t", sessionID,
		"#{session_name}",
	)
	if err != nil {
		return err
	}

	newName, err := promptValue("Rename session", currentName)
	if err != nil {
		return err
	}

	newName = strings.TrimSpace(newName)
	if newName == "" || newName == currentName {
		return nil
	}

	if sessionExists(newName) {
		return fmt.Errorf("session %q already exists", newName)
	}

	return runTmux("rename-session", "-t", sessionID, newName)
}

func deleteWindow(windowID string) error {
	windowName, err := tmuxOutput(
		"display-message",
		"-p",
		"-t", windowID,
		"#{window_name}",
	)
	if err != nil {
		return err
	}

	answer, err := promptValue(
		fmt.Sprintf("Delete window %q? Type y to confirm", windowName),
		"n",
	)
	if err != nil {
		return err
	}

	switch strings.ToLower(strings.TrimSpace(answer)) {
	case "y", "yes":
	default:
		return nil
	}

	// Killing the last window may terminate the tmux server,
	// so ignore the resulting server-disconnected error.
	_ = runTmux("kill-window", "-t", windowID)

	if !tmuxHasWindows() {
		_ = runTmux("kill-server")
		os.Exit(0)
	}

	return nil
}

func promptValue(label, defaultValue string) (string, error) {
	tty, err := os.OpenFile("/dev/tty", os.O_RDWR, 0)
	if err != nil {
		return "", fmt.Errorf("open /dev/tty: %w", err)
	}
	defer tty.Close()

	if defaultValue == "" {
		fmt.Fprintf(tty, "\n%s: ", label)
	} else {
		fmt.Fprintf(tty, "\n%s [%s]: ", label, defaultValue)
	}

	reader := bufio.NewReader(tty)
	value, err := reader.ReadString('\n')
	if err != nil && !errors.Is(err, io.EOF) {
		return "", err
	}

	value = strings.TrimSpace(value)
	if value == "" {
		return defaultValue, nil
	}

	return value, nil
}

func pauseWithMessage(message string) {
	tty, err := os.OpenFile("/dev/tty", os.O_RDWR, 0)
	if err != nil {
		fmt.Fprintln(os.Stderr, message)
		return
	}
	defer tty.Close()

	fmt.Fprintf(tty, "\n%s\nPress Enter to continue.", message)
	_, _ = bufio.NewReader(tty).ReadString('\n')
}

func validateDirectory(directory string) (string, error) {
	directory = expandHome(strings.TrimSpace(directory))

	info, err := os.Stat(directory)
	if err != nil {
		return "", fmt.Errorf("directory does not exist: %s", directory)
	}
	if !info.IsDir() {
		return "", fmt.Errorf("not a directory: %s", directory)
	}

	absolutePath, err := filepath.Abs(directory)
	if err != nil {
		return "", err
	}

	return absolutePath, nil
}

func expandHome(path string) string {
	if path == "~" || strings.HasPrefix(path, "~/") {
		home, err := os.UserHomeDir()
		if err == nil {
			if path == "~" {
				return home
			}
			return filepath.Join(home, strings.TrimPrefix(path, "~/"))
		}
	}

	return path
}

func sessionExists(name string) bool {
	command := exec.Command("tmux", "has-session", "-t", "="+name)
	return command.Run() == nil
}

func tmuxHasWindows() bool {
	command := exec.Command("tmux", "list-windows", "-a")
	command.Stdout = io.Discard
	command.Stderr = io.Discard
	return command.Run() == nil
}

func tmuxOutput(args ...string) (string, error) {
	command := exec.Command("tmux", args...)

	var stdout bytes.Buffer
	var stderr bytes.Buffer

	command.Stdout = &stdout
	command.Stderr = &stderr

	if err := command.Run(); err != nil {
		message := strings.TrimSpace(stderr.String())
		if message == "" {
			message = err.Error()
		}
		return "", fmt.Errorf("tmux %s: %s", args[0], message)
	}

	return strings.TrimSpace(stdout.String()), nil
}

func runTmux(args ...string) error {
	command := exec.Command("tmux", args...)

	var stderr bytes.Buffer
	command.Stderr = &stderr

	if err := command.Run(); err != nil {
		message := strings.TrimSpace(stderr.String())
		if message == "" {
			message = err.Error()
		}
		return fmt.Errorf("tmux %s: %s", args[0], message)
	}

	return nil
}

func requireCommands(names ...string) error {
	for _, name := range names {
		if _, err := exec.LookPath(name); err != nil {
			return fmt.Errorf("required command not found: %s", name)
		}
	}
	return nil
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, "tmux-fzf:", err)
	os.Exit(1)
}
