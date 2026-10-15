#### -------------------------
#### FZF: Open file in nvim (Ctrl+V)
#### -------------------------
fzf-nvim-open-file() {
  local file
  file=$(
    fd --type f 2> /dev/null \
    | fzf --height=80% --preview "bat --style=numbers --color=always --line-range=:500 {}"
  ) || return
  
  nvim "$file"
}
zle -N fzf-nvim-open-file
bindkey '^V' fzf-nvim-open-file

#### -------------------------
#### FZF: Ripgrep content search → open nvim at line (Ctrl+L)
#### -------------------------
fzf-ripgrep-nvim() {
local result file line

result=$(
  rg --column --line-number --no-heading --color=always . \
  | fzf --ansi --height=80% \
      --delimiter : \
      --preview 'bat --style=numbers --color=always {1} --highlight-line {2}' \
      --preview-window=right:60%
) || return

file=$(echo "$result" | cut -d: -f1)
line=$(echo "$result" | cut -d: -f2)

nvim "+$line" "$file"
}
zle -N fzf-ripgrep-nvim
bindkey '^L' fzf-ripgrep-nvim

# Load fzf-history-search plugin
source @zshHistoryPlugin@
bindkey '^R' fzf_history_search

# Configure the powerlevel10k theme
source @p10kTheme@
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

alias ffzf='fzf | xargs cat | wl-copy'
alias wt='ya tool arc-wt'

gowt() {
  if (( $# > 1 )) || [[ $# == 1 && -z "$1" ]]; then
    print -u2 'Usage: gowt [worktree_name]'
    return 1
  fi

  builtin cd -- "$HOME/arcadia-wt/${1-}"
}

_gowt() {
  (( CURRENT == 2 )) || return 1

  local -a worktrees=( "$HOME"/arcadia-wt/*(N-/) )
  compadd -- "${worktrees[@]:t}"
}
compdef _gowt gowt
