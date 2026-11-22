# dotfiles-public

Run `./install.sh` to symlink the WezTerm and tmux configs into `~/.config` and the Vim config to `~/.vimrc`. Existing regular config files are backed up with a `.bak` suffix; installation stops rather than overwrite an existing backup.

WezTerm and Vim use Rosé Pine Moon. The installer clones the [Vim theme](https://github.com/rose-pine/vim) and the [fzf Vim plugins](https://github.com/junegunn/fzf.vim) on first install, which requires Git and internet access. Vim's fuzzy search also requires the `fzf` executable (see Shell tools below).

Vim shows the current line's absolute number and relative numbers for other lines.
In normal mode, use a displayed distance followed by `j` or `k` to move down or up (for example, `5j`), or use `42G` to jump to absolute line 42.
Similarly use a number followed by `w`,`b` or `h`, `l` to jump by words or characters, respectively.

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
| Accept next suggested word / move forward a word | `Ctrl+F` | `Ctrl+F` |
| Delete word before cursor | `Ctrl+W` | `Ctrl+W` |
| Navigate to next/previous word | `Option+f`, `Option+b` | `Option+f`, `Option+b` | 

tmux's `Ctrl+B` is the default prefix: release it before pressing the next key. The split bindings are inspired by Terminator (`Ctrl+Shift+E` / `Ctrl+Shift+O`). Only the left Option key acts as Alt in WezTerm; the right Option key still types special characters.

### Vim key bindings

These are used in normal mode (press `Esc` first):

| Action | Keys |
|---|---|
| Fuzzy-search lines in the current buffer | `Ctrl+F` |
| Move down/up by lines | `j` / `k` (e.g. `5j`) |
| Move left/right by characters | `h` / `l` (e.g. `5h`) |
| Move forward/backward by words | `w` / `b` (e.g. `3w`) |
| Jump to an absolute line | `42G` |
| Search forward | `/`, then search text and `Enter` |
| Next/previous search match | `n` / `N` |
| Search for the word under the cursor | `*` / `#` |
| Scroll down/up half a screen | `Ctrl+D` / `Ctrl+U` |

For fuzzy search, type to filter the lines, use the arrows to select one, and press `Enter` to jump to it. `Ctrl+F` replaces Vim's default full-page-forward shortcut.

## Shell tools

fzf and the zsh plugins work at a zsh prompt in either WezTerm or tmux. With fzf, type to filter, use the arrows to select, and press Enter. Autosuggestions show a matching command from history as ghost text; press `Right Arrow` at the end of the line to accept it all, or `Ctrl+F` to accept the next word. `Ctrl+W` deletes the word before the cursor. Syntax highlighting colors the command as you type; it has no shortcut.

These shell tools are configured separately in `~/.zshrc`, not by `install.sh`. To set them up with Homebrew, run `brew install fzf zsh-autosuggestions zsh-syntax-highlighting`, then add the following near the end of `~/.zshrc` (syntax highlighting should be sourced last):

```zsh
source <(fzf --zsh)
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
bindkey '^F' forward-word
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
```

Open a new shell to load the changes.

## Git aliases

The repo provides `gs` (`git status`), `gc` (`git commit`), `ga` (`git add`), `gd` (`git diff`), `gp` (`git push`), and `gl` (`git log`). To enable them in zsh after running `./install.sh`, add this to `~/.zshrc`, after Oh My Zsh if you use it:

```zsh
source "$HOME/.config/dotfiles/git-aliases.zsh"
```

The other Git shortcuts provided by the Oh My Zsh Git plugin require that plugin separately.
