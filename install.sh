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

install_skill_creator() {
	local revision="e4bb5d960d87126ff3b3a8af1a104b7db67560ba"
	local dst="$HOME/.agents/skills/skill-creator" copilot="$HOME/.copilot/skills/skill-creator" tmp
	if [ -e "$dst" ] || [ -L "$dst" ]; then
		echo "skill-creator already exists at $dst; leaving it unchanged"
	else
		tmp="$(mktemp -d)"
		git -C "$tmp" init --quiet
		git -C "$tmp" fetch --depth=1 https://github.com/anthropics/skills.git "$revision"
		git -C "$tmp" checkout FETCH_HEAD -- skills/skill-creator
		mkdir -p "$(dirname "$dst")"
		mv "$tmp/skills/skill-creator" "$dst"
		rm -rf "$tmp"
		echo "installed skill-creator at $dst from $revision"
	fi

	if [ -L "$copilot" ] && [ "$(readlink "$copilot")" = "$dst" ]; then
		echo "Copilot skill-creator already linked to $dst"
	elif [ -e "$copilot" ] || [ -L "$copilot" ]; then
		echo "warning: $copilot already exists; leaving it unchanged" >&2
	else
		mkdir -p "$(dirname "$copilot")"
		ln -s "$dst" "$copilot"
		echo "linked $copilot -> $dst"
	fi
}

install_skill_creator

link skills/eng-governance-review .agents/skills/eng-governance-review
link skills/eng-governance-review .copilot/skills/eng-governance-review

install_vim_package "$HOME/.vim/pack/themes/start/rose-pine" colors/rosepine_moon.vim https://github.com/rose-pine/vim.git
install_vim_package "$HOME/.vim/pack/dotfiles/start/fzf" plugin/fzf.vim https://github.com/junegunn/fzf.git
install_vim_package "$HOME/.vim/pack/dotfiles/start/fzf-vim" plugin/fzf.vim https://github.com/junegunn/fzf.vim.git
install_vim_package "$HOME/.vim/pack/dotfiles/start/ale" plugin/ale.vim https://github.com/dense-analysis/ale.git
install_vim_package "$HOME/.vim/pack/dotfiles/start/vim-sleuth" plugin/sleuth.vim https://github.com/tpope/vim-sleuth.git
install_vim_package "$HOME/.vim/pack/dotfiles/start/auto-pairs" plugin/auto-pairs.vim https://github.com/jiangmiao/auto-pairs.git
install_vim_package "$HOME/.vim/pack/dotfiles/start/vim-gitgutter" plugin/gitgutter.vim https://github.com/airblade/vim-gitgutter.git

if ! command -v rg >/dev/null 2>&1; then
	if ! command -v brew >/dev/null 2>&1; then
		echo "Ripgrep requires Homebrew; install it and rerun ./install.sh" >&2
		exit 1
	fi
	brew install ripgrep
fi

# macOS's /usr/bin/git is an xcrun shim that roughly triples the cost of each git call, slowing zsh git completion.
if [ "$(uname)" = Darwin ] && ! brew list git >/dev/null 2>&1; then
	brew install git
fi

if ! command -v markdownlint-cli2 >/dev/null 2>&1; then
	if ! command -v npm >/dev/null 2>&1; then
		echo "Markdown linting requires Node.js 22 or newer and npm; install them and rerun ./install.sh" >&2
		exit 1
	fi
	npm install --global markdownlint-cli2
fi

link wezterm/wezterm.lua .config/wezterm/wezterm.lua
link tmux/tmux.conf .config/tmux/tmux.conf
link vim/vimrc .vimrc
link git/aliases.zsh .config/dotfiles/git-aliases.zsh
link shell/content-search.zsh .config/dotfiles/content-search.zsh
link snippets.json .config/agent-snippets/snippets.json
echo "Agent integration setup specifications: $DIR/agent-integrations/README.md"

if [ -e "$HOME/AGENTS.md" ] || [ -L "$HOME/AGENTS.md" ]; then
	echo "warning: $HOME/AGENTS.md already exists; leaving it unchanged" >&2
else
	cp -n "$DIR/AGENTS.md" "$HOME/AGENTS.md"
	echo "copied agent instructions to $HOME/AGENTS.md"
fi

mkdir -p "$HOME/.claude"
if [ -L "$HOME/.claude/CLAUDE.md" ] && [ "$(readlink "$HOME/.claude/CLAUDE.md")" = "$HOME/AGENTS.md" ]; then
	echo "Claude instructions already linked to $HOME/AGENTS.md"
elif [ -e "$HOME/.claude/CLAUDE.md" ] || [ -L "$HOME/.claude/CLAUDE.md" ]; then
	echo "warning: $HOME/.claude/CLAUDE.md already exists; leaving it unchanged" >&2
else
	ln -s "$HOME/AGENTS.md" "$HOME/.claude/CLAUDE.md"
	echo "linked Claude instructions to $HOME/AGENTS.md"
fi
