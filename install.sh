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

install_vim_package() {
	local path="$1" file="$2" url="$3"
	if [ -f "$path/$file" ]; then
		return
	fi
	if [ -e "$path" ] || [ -L "$path" ]; then
		echo "cannot install Vim package: $path already exists but lacks $file" >&2
		exit 1
	fi
	mkdir -p "$(dirname "$path")"
	git clone --depth=1 "$url" "$path"
}

install_vim_package "$HOME/.vim/pack/themes/start/rose-pine" colors/rosepine_moon.vim https://github.com/rose-pine/vim.git
install_vim_package "$HOME/.vim/pack/dotfiles/start/fzf" plugin/fzf.vim https://github.com/junegunn/fzf.git
install_vim_package "$HOME/.vim/pack/dotfiles/start/fzf-vim" plugin/fzf.vim https://github.com/junegunn/fzf.vim.git

link wezterm/wezterm.lua .config/wezterm/wezterm.lua
link tmux/tmux.conf .config/tmux/tmux.conf
link vim/vimrc .vimrc
link git/aliases.zsh .config/dotfiles/git-aliases.zsh
