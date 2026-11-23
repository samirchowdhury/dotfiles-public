# dotfiles-public

Run `./install.sh` to symlink the WezTerm and tmux configs into `~/.config` and the Vim config to `~/.vimrc`. Existing regular config files are backed up with a `.bak` suffix; installation stops rather than overwrite an existing backup.
The installer also installs ripgrep with Homebrew if `rg` is missing.

WezTerm and Vim use Rosé Pine Moon. The installer clones the [Vim theme](https://github.com/rose-pine/vim) and the [fzf Vim plugins](https://github.com/junegunn/fzf.vim) on first install, which requires Git and internet access. Vim's fuzzy search also requires the `fzf` executable (see Shell tools below).

Vim shows the current line's absolute number and relative numbers for other lines.
In normal mode, use a displayed distance followed by `j` or `k` to move down or up (for example, `5j`), or use `42G` to jump to absolute line 42.
Similarly use a number followed by `w`,`b` or `h`, `l` to jump by words or characters, respectively.

## Key bindings

| Action | WezTerm | tmux |
| --- | --- | --- |
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

### Finding and copying a file path

At a zsh prompt in WezTerm or tmux, first `cd` to the project directory.
Press `Ctrl+T`, type a filename such as `quiet-tool-traces.ts` or a fuzzy abbreviation such as `qtt`, select the match with the arrows, and press `Enter` to insert its path without executing it.
The default file search starts under the current directory.
This is a shell shortcut, not a shortcut inside an agent's interactive input.

To copy the inserted path in WezTerm, drag over exactly the text you want and press `Cmd+C`.
If Vim, tmux, or another application captures the mouse, hold `Shift` while dragging to select through WezTerm instead.
The default mouse selection also copies on release.

For keyboard-only selection, press `Ctrl+Shift+X` to enter WezTerm copy mode.
Move to the start of the path with arrows or `h`, `j`, `k`, `l`, press `v` to start selecting, move to the end, then press `y` to copy and exit.
Press `Esc` to cancel copy mode.
Copy mode selects displayed terminal text without editing or submitting your command.

### Vim key bindings

These are used in normal mode (press `Esc` first):

| Action | Keys |
| --- | --- |
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

### Markdown linting

The installer adds [ALE](https://github.com/dense-analysis/ale) and installs `markdownlint-cli2` globally with npm if it is missing.
This requires Node.js 22 or newer and npm (on macOS, `brew install node`).
ALE checks Markdown files when opened or saved and shows diagnostics in Vim.
Before saving Markdown, Vim automatically applies Markdownlint's fixable rules, including when using `:wq` or `:x` to save and exit.
Formatting runs synchronously from the file's directory so it finishes before the write and uses the applicable Markdownlint configuration.
Formatter failures stop the save and display an error; rules without automatic fixes remain as ALE diagnostics.
Use `:ALENext` or `:ALEPrevious` to navigate diagnostics, and `:ALEInfo` to inspect the linter's status.
Other file types are not linted by this configuration.

Run `markdownlint-cli2 README.md` from the repo root to lint from the terminal.
The repo's `.markdownlint.jsonc` keeps the default rules except the line-length limit, allowing one sentence per line.
That rule configuration applies to this repo; Markdown files elsewhere use their own configuration or Markdownlint defaults.

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

## Global agent instructions

The installer copies the minimal `AGENTS.md` template to `~/AGENTS.md` and symlinks `~/.claude/CLAUDE.md` to that file, Claude Code's global user-instruction location. Existing files or conflicting symlinks at either destination trigger a warning and are left unchanged.

Edit `~/AGENTS.md` for your local instructions, or populate the repo template for future machines. This is a copy, not a symlink to the repo: later template edits do not update installed files. Do not put private instructions or secrets in this public repo.

## Agent snippets

Edit `snippets.json` to add reusable prompts.
The installer symlinks it to `~/.config/agent-snippets/snippets.json`.
It does not install a picker or assume that your harness reads this file automatically.

For agent-assisted setup, ask: "Set up this repo for my agent harness, including the snippet picker described in SNIPPET-PICKER.md."
The [specification](SNIPPET-PICKER.md) directs the agent to check your installed harness for native support or build a minimal external adapter.
The intended workflow is a hotkey, fuzzy search, and Enter to insert without submitting.
Snippets refresh on each picker opening, with no usage tracking.

## Quiet tool traces

The [quiet tool traces specification](QUIET-TOOL-TRACES.md) describes a presentation-only integration that hides routine tool calls and output, keeps errors visible, and lets you reveal traces on demand.
Tool execution, model context, and session history remain unchanged.
This repo does not install a harness-specific implementation.

For agent-assisted setup, ask: "Set up quiet tool traces for Copilot CLI using QUIET-TOOL-TRACES.md."
Replace Copilot CLI with your target harness.
The agent must check the installed version's native settings and supported display APIs, then configure them or build a minimal external adapter.
If the harness cannot meet the spec, the agent should explain the gap and ask before implementing an approximation.
