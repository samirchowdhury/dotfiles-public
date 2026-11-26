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
| Navigate to adjacent pane | `Ctrl+Shift+Arrow` | Left `Option+Shift+Arrow` |
| Cycle panes | No default binding | `Ctrl+B`, then `O` |
| Switch to last active pane | — | `Ctrl+B`, then `;` |
| Close WezTerm tab | `Cmd+W` | `Cmd+W` closes the enclosing WezTerm tab |
| Rename WezTerm tab and active window header (empty name restores automatic title) | `Cmd+Shift+R` | `Cmd+Shift+R` renames the enclosing WezTerm tab and active window header |
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
| Hide/show Git diff highlights in the current buffer | `\gd` |
| Preview the changed hunk under the cursor | `\gp` |
| Next/previous changed hunk | `]c` / `[c` |
| Move down/up by lines | `j` / `k` (e.g. `5j`) |
| Move left/right by characters | `h` / `l` (e.g. `5h`) |
| Move forward/backward by words | `w` / `b` (e.g. `3w`) |
| Jump to an absolute line | `42G` |
| Search forward | `/`, then search text and `Enter` |
| Next/previous search match | `n` / `N` |
| Search for the word under the cursor | `*` / `#` |
| Scroll down/up half a screen | `Ctrl+D` / `Ctrl+U` |

For fuzzy search, type to filter the lines, use the arrows to select one, and press `Enter` to jump to it. `Ctrl+F` replaces Vim's default full-page-forward shortcut.

In Insert mode, left `Option+Left` / `Option+Right` moves backward/forward by one word without leaving Insert mode.
The tmux pane shortcuts use `Option+Shift+Arrow` so they do not intercept these word motions.

### Feature-branch diff highlighting

The installer adds [Vim GitGutter](https://github.com/airblade/vim-gitgutter).
When opening a tracked file, Vim automatically compares it against `git merge-base main HEAD`, showing gutter signs and whole-line highlights for added, modified, and removed lines.
No keybinding is needed to turn this on; the diff includes committed feature-branch changes and unsaved buffer edits.
Changes update after about 250 ms of idle time.
Deleted lines are marked beside surviving lines rather than displayed as text.
Files absent from the base commit, including entirely new files, may not receive markers from GitGutter.

In normal mode, press `\gd` to hide/show both signs and highlights for the current buffer.
Here `\` is Vim's default leader key; press it and then `g`, `d` in sequence.
Use `]c` / `[c` to move between hunks and `\gp` to preview the original and changed text.
Stage/undo mappings are deliberately not installed; these review shortcuts do not change files or the Git index.

The comparison SHA is pinned when the first Git file is opened and stays fixed for the Vim session, even if `main` or `HEAD` later advances.
Run `:GitDiffBase` to recalculate the merge-base with `main`, or `:GitDiffBase origin/main` to select another base ref.
To reuse a known original branch-point SHA after merging or rebasing, run `:GitDiffBase <sha>` with that ancestor commit.
A new Vim session calculates a new merge-base; it cannot infer an older branch point lost through a rebase.
GitGutter's comparison base is global, so use separate Vim sessions for different repositories; files from another repository in the same session have GitGutter disabled to avoid applying the wrong SHA.
If `main` is unavailable or has no common ancestor, highlights stay disabled and Vim asks you to choose a ref with `:GitDiffBase <base-ref>` rather than silently compare against the index.
Restart Vim after first installation to load the plugin and configuration.

### Indentation and bracket pairing

The installer adds [vim-sleuth](https://github.com/tpope/vim-sleuth) to detect indentation from the current file or nearby files, rather than enforce per-language widths.
Use `:Sleuth` to rerun detection and `:setlocal expandtab? shiftwidth? softtabstop?` to inspect the current settings.
[Auto-pairs](https://github.com/jiangmiao/auto-pairs) inserts matching brackets, braces, and quotes in Insert mode.
Type the closing character to move past an automatically inserted match.
Neither plugin reformats whole files; Markdown keeps the formatter described below.

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

On macOS, the installer installs Git with Homebrew.
The default `/usr/bin/git` is an `xcrun` shim that took about 26 ms per call versus about 9 ms for the underlying binary.
zsh's `git add` completion runs about nine Git commands per Tab, so `ga E<Tab>` took 0.35–0.55 s with the shim and about 0.2 s with Homebrew Git.
Make sure `/opt/homebrew/bin` comes before `/usr/bin` in `PATH`; check with `which git`.
Homebrew Git also installs its own `_git` zsh completion, which takes precedence over zsh's built-in one.

## Global agent instructions

The installer copies the minimal `AGENTS.md` template to `~/AGENTS.md` and symlinks `~/.claude/CLAUDE.md` to that file, Claude Code's global user-instruction location. Existing files or conflicting symlinks at either destination trigger a warning and are left unchanged.

Edit `~/AGENTS.md` for your local instructions, or populate the repo template for future machines. This is a copy, not a symlink to the repo: later template edits do not update installed files. Do not put private instructions or secrets in this public repo.

## Skill creator

The installer adds Anthropic's [skill-creator](https://github.com/anthropics/skills/tree/e4bb5d960d87126ff3b3a8af1a104b7db67560ba/skills/skill-creator) globally for Pi and Copilot.
It fetches commit `e4bb5d960d87126ff3b3a8af1a104b7db67560ba` with Git and installs only the skill directory at `~/.agents/skills/skill-creator`.
First installation requires Git and internet access, but not the `skills` CLI.
The installer also links `~/.copilot/skills/skill-creator` to the shared installation.
Existing installations and conflicting Copilot paths are left unchanged, including local edits.
Rerunning the installer does not upgrade the skill or enforce the pin on an existing installation.

In Pi, run `/reload`, then invoke `/skill:skill-creator` followed by your request.
In a new Copilot session, ask it to use `skill-creator` to create or improve a named skill.
Some bundled evaluation tools require Python or the Claude CLI, including `claude -p` for description optimization.
The installer does not install those dependencies or add Pi-specific evaluation adapters.

To update, review the upstream changes and change `revision` in `install_skill_creator` in `install.sh` to the chosen commit.
Update the commit and source link in this section too.
Before rerunning `./install.sh`, move the existing `~/.agents/skills/skill-creator` installation to an unused backup path.
Keep that backup until you have checked the new version and recovered any local edits.
The Copilot link continues to point to the shared installation path.

## Engineering governance review

The repo's [`eng-governance-review` skill](skills/eng-governance-review/SKILL.md) uses its bundled [`ENG-GOVERNANCE-ONTOLOGY.md`](skills/eng-governance-review/references/ENG-GOVERNANCE-ONTOLOGY.md) as an internal lens for reviewing a feature branch, PR/MR, compare URL, or patch.
The output is a readable, numbered Markdown review ordered by priority: high-priority problems first, then should-fix findings, with optional nits clearly separated.
Each finding explains the concrete problem and effect, with focused source references and examples or suggested fixes where useful, rather than ontology tags or a rigid reporting schema.
Detailed provenance and inspection records stay in separate metadata so the review gets straight to the problems.
Open the file in Vim and discuss it with the agent by item number.
Numbers remain stable during the walkthrough.

The installer symlinks the skill into `~/.agents/skills/eng-governance-review` for pi and `~/.copilot/skills/eng-governance-review` for Copilot CLI and VS Code Copilot.
The canonical ontology lives in the skill's `references/` directory, keeping the skill self-contained.
Keep this checkout in place while using the installed links.
Existing regular destination files or directories are backed up using the installer's normal `.bak` policy.

In pi, run `/reload`, then `/skill:eng-governance-review <branch-or-diff-URL>`.
In a new Copilot CLI or VS Code Copilot agent session, ask: "Use eng-governance-review on BRANCH_OR_DIFF_URL and write the agenda to /tmp/governance-review.md."
The agent uses available read-only repository access and asks for a base branch if it cannot resolve the intended comparison.
It reports the file path when ready; open it with `vim /tmp/governance-review.md`, then ask the agent to walk through an item.
Save Vim edits before asking the agent to update the file, and use `:checktime` afterward to reload changes from disk.

To remove the skill from the harnesses, remove those two user-level symlinks.
No harness extensions, additional skill dependencies, or settings changes are required.
Repository access may require an authenticated host CLI or a local checkout.

## Agent integrations

The [agent integrations folder](agent-integrations/README.md) contains harness-neutral specifications and a shared setup workflow.
For a new computer, ask: "Set up all integrations in `agent-integrations/` for Copilot CLI."
Replace Copilot CLI with your target harness.
The agent should assess every spec against the installed harness, prefer native configuration, and ask before implementing approximations.

## Agent snippets

Edit `snippets.json` to add reusable prompts.
The installer symlinks it to `~/.config/agent-snippets/snippets.json`.
It does not install a picker or assume that your harness reads this file automatically.

The [specification](agent-integrations/SNIPPET-PICKER.md) directs the agent to check your installed harness for native support or build a minimal external adapter.
The intended workflow is a hotkey, fuzzy search, and Enter to insert without submitting.
Snippets refresh on each picker opening, with no usage tracking.

For Pi, use `Ctrl+S` to open the picker after setting up the integration.
The user extension lives at `~/.pi/agent/extensions/snippet-picker.ts`; run `/reload` after installing or changing it.
Use the arrows to select, `Enter` to insert at the cursor without submitting, and `Esc` to cancel.
The implementation stays outside this repo, as required by the specification.

## Quiet tool traces

The [quiet tool traces specification](agent-integrations/QUIET-TOOL-TRACES.md) describes a presentation-only integration that hides routine tool calls and output, keeps errors visible, and lets you reveal traces on demand.
Tool execution, model context, and session history remain unchanged.
This repo does not install a harness-specific implementation.

Use the shared agent-assisted setup workflow above to configure it for your harness.
