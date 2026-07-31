cargo build --release

mkdir -p ~/.local/bin
cp target/release/tmux-fzf-switch ~/.local/bin/
