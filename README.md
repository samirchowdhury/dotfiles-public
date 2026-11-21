# dotfiles-public

Run `./install.sh` to symlink the WezTerm and tmux configs into `~/.config` and the Vim config to `~/.vimrc`. Existing regular config files are backed up with a `.bak` suffix; installation stops rather than overwrite an existing backup.

WezTerm and Vim use Rosé Pine Moon. The installer clones the [Vim theme](https://github.com/rose-pine/vim) on first install, which requires Git and internet access.

Vim shows the current line's absolute number and relative numbers for other lines. In normal mode, use a displayed distance followed by `j` or `k` to move down or up (for example, `5j`), or use `42G` to jump to absolute line 42.

## Key bindings

| Action | WezTerm | tmux |
|---|---|---|
| Split pane side by side | `Cmd+E` | Left `Option+E` |
| Split pane stacked | `Cmd+O` | Left `Option+O` |
| Close active pane | `Cmd+Shift+W` | Left `Option+W` |
| Navigate to adjacent pane | `Ctrl+Shift+Arrow` | Left `Option+Arrow` |
| Cycle panes | No default binding | `Ctrl+B`, then `O` |
| Switch to last active pane | — | `Ctrl+B`, then `;` |
| Close WezTerm tab | `Cmd+W` | `Cmd+W` closes the enclosing WezTerm tab |
| Search command history with fzf | `Ctrl+R` | `Ctrl+R` |
| Insert a file path with fzf | `Ctrl+T` | `Ctrl+T` |
| Change directory with fzf | Left `Option+C` | Left `Option+C` |
| Accept zsh autosuggestion | `Right Arrow` | `Right Arrow` |
| Next/previous word | `Option+f`, `Option+b` | `Option+f`, `Option+b` | 

tmux's `Ctrl+B` is the default prefix: release it before pressing the next key. The split bindings are inspired by Terminator (`Ctrl+Shift+E` / `Ctrl+Shift+O`). Only the left Option key acts as Alt in WezTerm; the right Option key still types special characters.

## Shell tools

fzf and the zsh plugins work at a zsh prompt in either WezTerm or tmux. With fzf, type to filter, use the arrows to select, and press Enter. Autosuggestions show a matching command from history as ghost text; press `Ctrl+F` to accept it. Syntax highlighting colors the command as you type; it has no shortcut.

These shell tools are configured separately in `~/.zshrc`, not by `install.sh`. To set them up with Homebrew, run `brew install fzf zsh-autosuggestions zsh-syntax-highlighting`, then add the following near the end of `~/.zshrc` (syntax highlighting should be sourced last):

```zsh
source <(fzf --zsh)
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey '^F' autosuggest-accept
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
```

Open a new shell to load the changes.

## Git aliases

The repo provides `gs` (`git status`), `gc` (`git commit`), `ga` (`git add`), `gd` (`git diff`), `gp` (`git push`), and `gl` (`git log`). To enable them in zsh after running `./install.sh`, add this to `~/.zshrc`, after Oh My Zsh if you use it:

```zsh
source "$HOME/.config/dotfiles/git-aliases.zsh"
```

The other Git shortcuts provided by the Oh My Zsh Git plugin require that plugin separately.
