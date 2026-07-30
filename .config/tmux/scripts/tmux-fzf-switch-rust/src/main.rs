use std::{
    env,
    error::Error,
    ffi::OsString,
    fmt,
    fs::{self, OpenOptions},
    io::{self, BufRead, BufReader, Read, Write},
    path::{Path, PathBuf},
    process::{self, Child, Command, ExitStatus, Stdio},
};

const PANE_FORMAT: &str = concat!(
    "#{session_id}\t",
    "#{window_id}\t",
    "#{pane_id}\t",
    "#{session_name} › #{window_name} › pane #{pane_index}\t",
    "#{pane_current_command}\t",
    "#{pane_current_path}"
);

const FZF_HEADER: &str = concat!(
    "Enter: switch │ ",
    "Ctrl-n: new session │ ",
    "Ctrl-w: new window │ ",
    "Ctrl-r: rename window │ ",
    "Ctrl-s: rename session │ ",
    "Ctrl-d: delete window"
);

#[derive(Debug)]
struct AppError(String);

impl fmt::Display for AppError {
    fn fmt(&self, formatter: &mut fmt::Formatter<'_>) -> fmt::Result {
        formatter.write_str(&self.0)
    }
}

impl Error for AppError {}

type AppResult<T> = Result<T, Box<dyn Error>>;

#[derive(Debug, Clone)]
struct Selection {
    session_id: String,
    window_id: String,
    pane_id: String,
}

#[derive(Debug)]
struct FinderResult {
    key: String,
    selection: Option<Selection>,
}

fn main() {
    if let Err(error) = run() {
        eprintln!("tmux-fzf-switch: {error}");
        process::exit(1);
    }
}

fn run() -> AppResult<()> {
    require_command("tmux")?;
    require_command("fzf")?;

    while tmux_has_windows() {
        let finder_result = match run_finder() {
            Ok(result) => result,
            Err(FinderError::Cancelled) => return Ok(()),
            Err(FinderError::Other(error)) => return Err(error),
        };

        if finder_result.key == "ctrl-n" {
            match create_session() {
                Ok(ActionResult::Continue) => continue,
                Ok(ActionResult::Exit) => return Ok(()),
                Err(error) => {
                    pause_with_message(&error.to_string())?;
                    continue;
                }
            }
        }

        let Some(selection) = finder_result.selection else {
            continue;
        };

        let result = match finder_result.key.as_str() {
            "ctrl-w" => create_window(&selection),
            "ctrl-d" => delete_window(&selection.window_id),
            "ctrl-r" => rename_window(&selection.window_id),
            "ctrl-s" => rename_session(&selection.session_id),

            "" | "enter" => {
                run_tmux(["switch-client", "-t", selection.pane_id.as_str()])?;
                return Ok(());
            }

            _ => Ok(ActionResult::Continue),
        };

        match result {
            Ok(ActionResult::Continue) => {}
            Ok(ActionResult::Exit) => return Ok(()),
            Err(error) => pause_with_message(&error.to_string())?,
        }
    }

    let _ = run_tmux(["kill-server"]);
    Ok(())
}

#[derive(Debug)]
enum ActionResult {
    Continue,
    Exit,
}

#[derive(Debug)]
enum FinderError {
    Cancelled,
    Other(Box<dyn Error>),
}

fn run_finder() -> Result<FinderResult, FinderError> {
    let mut list_panes = Command::new("tmux")
        .args(["list-panes", "-a", "-F", PANE_FORMAT])
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .map_err(|error| FinderError::Other(Box::new(error)))?;

    let list_stdout = list_panes.stdout.take().ok_or_else(|| {
        FinderError::Other(Box::new(AppError(
            "unable to capture tmux list-panes output".into(),
        )))
    })?;

    let fzf_output = Command::new("fzf")
        .args([
            "--expect=enter,ctrl-d,ctrl-r,ctrl-s,ctrl-n,ctrl-w",
            "--delimiter=\t",
            "--with-nth=4,5,6",
            "--prompt=tmux ❯ ",
            &format!("--header={FZF_HEADER}"),
            "--border",
            "--color=border:0,preview-border:0",
            "--reverse",
            "--height=100%",
            "--preview=tmux capture-pane -ep -t {3} -S -200",
            "--preview-window=right,60%,wrap",
        ])
        .stdin(Stdio::from(list_stdout))
        .stdout(Stdio::piped())
        .stderr(Stdio::inherit())
        .output()
        .map_err(|error| FinderError::Other(Box::new(error)))?;

    let list_status = list_panes
        .wait()
        .map_err(|error| FinderError::Other(Box::new(error)))?;

    if !list_status.success() {
        return Err(FinderError::Other(Box::new(AppError(
            "tmux list-panes failed".into(),
        ))));
    }

    if !fzf_output.status.success() {
        // fzf normally returns 130 for Ctrl-C and 1 when no item is selected.
        return Err(FinderError::Cancelled);
    }

    let output = String::from_utf8(fzf_output.stdout)
        .map_err(|error| FinderError::Other(Box::new(error)))?;

    let mut lines = output.lines();

    let key = lines.next().unwrap_or_default().to_owned();
    let selected_line = lines.next().unwrap_or_default();

    if selected_line.is_empty() {
        return Ok(FinderResult {
            key,
            selection: None,
        });
    }

    let mut fields = selected_line.split('\t');

    let session_id = fields.next().unwrap_or_default().to_owned();
    let window_id = fields.next().unwrap_or_default().to_owned();
    let pane_id = fields.next().unwrap_or_default().to_owned();

    if session_id.is_empty() || window_id.is_empty() || pane_id.is_empty() {
        return Err(FinderError::Other(Box::new(AppError(format!(
            "unexpected fzf result: {selected_line:?}"
        )))));
    }

    Ok(FinderResult {
        key,
        selection: Some(Selection {
            session_id,
            window_id,
            pane_id,
        }),
    })
}

fn create_session() -> AppResult<ActionResult> {
    let session_name = prompt_value("New session name", None)?;
    let session_name = session_name.trim();

    if session_name.is_empty() {
        return Ok(ActionResult::Continue);
    }

    if session_exists(session_name) {
        return Err(Box::new(AppError(format!(
            "Session {session_name:?} already exists."
        ))));
    }

    let home = home_directory()?;
    let default_directory = home.to_string_lossy();

    let start_directory =
        prompt_value("Starting directory", Some(default_directory.as_ref()))?;

    let start_directory = validate_directory(&start_directory)?;

    run_tmux([
        "new-session",
        "-d",
        "-s",
        session_name,
        "-c",
        path_to_str(&start_directory)?,
    ])?;

    run_tmux(["switch-client", "-t", &format!("={session_name}")])?;

    Ok(ActionResult::Exit)
}

fn create_window(selection: &Selection) -> AppResult<ActionResult> {
    let current_directory = tmux_output([
        "display-message",
        "-p",
        "-t",
        selection.pane_id.as_str(),
        "#{pane_current_path}",
    ])?;

    let window_name = prompt_value("New window name", None)?;

    let start_directory =
        prompt_value("Starting directory", Some(current_directory.as_str()))?;

    let start_directory = validate_directory(&start_directory)?;

    let mut arguments: Vec<OsString> = vec![
        "new-window".into(),
        "-d".into(),
        "-P".into(),
        "-F".into(),
        "#{pane_id}".into(),
        "-t".into(),
        selection.session_id.clone().into(),
        "-c".into(),
        start_directory.as_os_str().to_owned(),
    ];

    let window_name = window_name.trim();

    if !window_name.is_empty() {
        arguments.push("-n".into());
        arguments.push(window_name.into());
    }

    let new_pane_id = tmux_output_os(arguments)?;

    run_tmux(["switch-client", "-t", new_pane_id.as_str()])?;

    Ok(ActionResult::Exit)
}

fn rename_window(window_id: &str) -> AppResult<ActionResult> {
    let current_name = tmux_output([
        "display-message",
        "-p",
        "-t",
        window_id,
        "#{window_name}",
    ])?;

    let new_name = prompt_value("Rename window", Some(&current_name))?;
    let new_name = new_name.trim();

    if new_name.is_empty() || new_name == current_name {
        return Ok(ActionResult::Continue);
    }

    run_tmux(["rename-window", "-t", window_id, new_name])?;

    run_tmux([
        "set-option",
        "-w",
        "-t",
        window_id,
        "automatic-rename",
        "off",
    ])?;

    Ok(ActionResult::Continue)
}

fn rename_session(session_id: &str) -> AppResult<ActionResult> {
    let current_name = tmux_output([
        "display-message",
        "-p",
        "-t",
        session_id,
        "#{session_name}",
    ])?;

    let new_name = prompt_value("Rename session", Some(&current_name))?;
    let new_name = new_name.trim();

    if new_name.is_empty() || new_name == current_name {
        return Ok(ActionResult::Continue);
    }

    if session_exists(new_name) {
        return Err(Box::new(AppError(format!(
            "Session {new_name:?} already exists."
        ))));
    }

    run_tmux(["rename-session", "-t", session_id, new_name])?;

    Ok(ActionResult::Continue)
}

fn delete_window(window_id: &str) -> AppResult<ActionResult> {
    let window_name = tmux_output([
        "display-message",
        "-p",
        "-t",
        window_id,
        "#{window_name}",
    ])?;

    let confirmation = prompt_value(
        &format!("Delete window {window_name:?}? Type y to confirm"),
        Some("n"),
    )?;

    match confirmation.trim().to_ascii_lowercase().as_str() {
        "y" | "yes" => {}
        _ => return Ok(ActionResult::Continue),
    }

    // Killing the final window may cause the server to disappear before the
    // command returns, so an error here is intentionally ignored.
    let _ = run_tmux(["kill-window", "-t", window_id]);

    if !tmux_has_windows() {
        let _ = run_tmux(["kill-server"]);
        return Ok(ActionResult::Exit);
    }

    Ok(ActionResult::Continue)
}

fn prompt_value(label: &str, default_value: Option<&str>) -> AppResult<String> {
    let mut tty = OpenOptions::new()
        .read(true)
        .write(true)
        .open("/dev/tty")
        .map_err(|error| {
            AppError(format!("unable to open /dev/tty for prompting: {error}"))
        })?;

    match default_value {
        Some(default) if !default.is_empty() => {
            write!(tty, "\n{label} [{default}]: ")?;
        }
        _ => {
            write!(tty, "\n{label}: ")?;
        }
    }

    tty.flush()?;

    let mut reader = BufReader::new(tty.try_clone()?);
    let mut value = String::new();
    reader.read_line(&mut value)?;

    let value = value.trim_end_matches(['\r', '\n']);

    if value.is_empty() {
        Ok(default_value.unwrap_or_default().to_owned())
    } else {
        Ok(value.to_owned())
    }
}

fn pause_with_message(message: &str) -> AppResult<()> {
    let mut tty = OpenOptions::new()
        .read(true)
        .write(true)
        .open("/dev/tty")?;

    write!(tty, "\n{message}\nPress Enter to continue.")?;
    tty.flush()?;

    let mut input = String::new();
    BufReader::new(tty).read_line(&mut input)?;

    Ok(())
}

fn session_exists(name: &str) -> bool {
    Command::new("tmux")
        .args(["has-session", "-t", &format!("={name}")])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .is_ok_and(|status| status.success())
}

fn tmux_has_windows() -> bool {
    Command::new("tmux")
        .args(["list-windows", "-a"])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .is_ok_and(|status| status.success())
}

fn validate_directory(value: &str) -> AppResult<PathBuf> {
    let expanded = expand_home(value.trim())?;

    let metadata = fs::metadata(&expanded).map_err(|_| {
        AppError(format!(
            "Directory does not exist: {}",
            expanded.display()
        ))
    })?;

    if !metadata.is_dir() {
        return Err(Box::new(AppError(format!(
            "Not a directory: {}",
            expanded.display()
        ))));
    }

    Ok(expanded.canonicalize()?)
}

fn expand_home(value: &str) -> AppResult<PathBuf> {
    if value == "~" {
        return home_directory();
    }

    if let Some(rest) = value.strip_prefix("~/") {
        return Ok(home_directory()?.join(rest));
    }

    Ok(PathBuf::from(value))
}

fn home_directory() -> AppResult<PathBuf> {
    env::var_os("HOME")
        .map(PathBuf::from)
        .ok_or_else(|| Box::new(AppError("HOME is not set".into())) as Box<dyn Error>)
}

fn path_to_str(path: &Path) -> AppResult<&str> {
    path.to_str().ok_or_else(|| {
        Box::new(AppError(format!(
            "Path is not valid UTF-8: {}",
            path.display()
        ))) as Box<dyn Error>
    })
}

fn tmux_output<const N: usize>(arguments: [&str; N]) -> AppResult<String> {
    let output = Command::new("tmux").args(arguments).output()?;
    parse_command_output("tmux", output.status, output.stdout, output.stderr)
}

fn tmux_output_os(arguments: Vec<OsString>) -> AppResult<String> {
    let output = Command::new("tmux").args(arguments).output()?;
    parse_command_output("tmux", output.status, output.stdout, output.stderr)
}

fn parse_command_output(
    command: &str,
    status: ExitStatus,
    stdout: Vec<u8>,
    stderr: Vec<u8>,
) -> AppResult<String> {
    if !status.success() {
        let error = String::from_utf8_lossy(&stderr).trim().to_owned();

        let message = if error.is_empty() {
            format!("{command} exited with status {status}")
        } else {
            format!("{command}: {error}")
        };

        return Err(Box::new(AppError(message)));
    }

    Ok(String::from_utf8(stdout)?.trim().to_owned())
}

fn run_tmux<I, S>(arguments: I) -> AppResult<()>
where
    I: IntoIterator<Item = S>,
    S: AsRef<std::ffi::OsStr>,
{
    let output = Command::new("tmux").args(arguments).output()?;

    if output.status.success() {
        return Ok(());
    }

    let error = String::from_utf8_lossy(&output.stderr).trim().to_owned();

    let message = if error.is_empty() {
        format!("tmux exited with status {}", output.status)
    } else {
        format!("tmux: {error}")
    };

    Err(Box::new(AppError(message)))
}

fn require_command(name: &str) -> AppResult<()> {
    let path = env::var_os("PATH")
        .ok_or_else(|| AppError("PATH environment variable is not set".into()))?;

    let found = env::split_paths(&path)
        .map(|directory| directory.join(name))
        .any(|candidate| candidate.is_file());

    if found {
        Ok(())
    } else {
        Err(Box::new(AppError(format!(
            "Required command not found in PATH: {name}"
        ))))
    }
}
