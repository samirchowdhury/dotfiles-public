#!/usr/bin/env bash
# Symlink configs into place. Existing non-symlink files are backed up with a .bak suffix.
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
	local src="$DIR/$1" dst="$HOME/$2"
	mkdir -p "$(dirname "$dst")"
	if [ -e "$dst" ] && [ ! -L "$dst" ]; then
		if [ -e "$dst.bak" ] || [ -L "$dst.bak" ]; then
			echo "cannot back up $dst: $dst.bak already exists" >&2
			return 1
		fi
		mv "$dst" "$dst.bak"
		echo "backed up $dst -> $dst.bak"
	fi
	ln -sfn "$src" "$dst"
	echo "linked $dst -> $src"
}

link wezterm/wezterm.lua .config/wezterm/wezterm.lua
link tmux/tmux.conf .config/tmux/tmux.conf
link vim/vimrc .vimrc
link git/aliases.zsh .config/dotfiles/git-aliases.zsh
