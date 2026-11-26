# Ctrl+G: search file contents below the current directory and open a match in Vim.
_dotfiles_content_search() {
  local selection file line remainder
  local separator=$'\t'
  local reload="test -n {q} && rg --smart-case --fixed-strings --line-number --with-filename --no-heading --color=never --field-match-separator ${(q)separator} -- {q} . || true"

  zle -I
  selection=$(printf '' | fzf --disabled --delimiter="$separator" \
    --height=80% --layout=reverse --prompt='Search contents> ' \
    --header='Type to search | Enter: open in Vim | Esc: cancel' \
    --bind="change:reload:$reload") || { zle redisplay; return; }

  file=${selection%%$'\t'*}
  remainder=${selection#*$'\t'}
  line=${remainder%%$'\t'*}
  command vim "+$line" -- "$file" < /dev/tty
  zle reset-prompt
}

zle -N dotfiles-content-search _dotfiles_content_search
bindkey -M emacs '^G' dotfiles-content-search
bindkey -M viins '^G' dotfiles-content-search
