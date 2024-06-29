DOTFILES="$HOME/repos/dotfiles"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$PATH:$HOME/.local/bin"
export ZSH_THEME="powerlevel10k/powerlevel10k"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source $ZSH/oh-my-zsh.sh

plugins=( 
    git
    history
    zsh-autosuggestions
)


setopt SHARE_HISTORY
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
setopt HIST_EXPIRE_DUPS_FIRST

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

function connect_to_test_container() {
    local containers
    containers=$(machinectl -l | grep "^bstack-${USER}" | awk '{print $1}')

    if [ "$(echo "$containers" | wc -l)" -gt 2 ]; then
        echo "Error: More than two matching containers found."
        return 1
    elif [ -z "$containers" ]; then
        echo "No matching containers found."
        return 1
    else
        echo "Matching containers found:"
        echo "$containers"

        # Connect to the container
        sudo machinectl login "$containers"
    fi
}

# Aliases
alias tc="connect_to_test_container"
alias rgcpp='rg -t=cpp -F'
alias rgpy='rg -t=py -F'
alias rgcmake='rg -t=cmake -F'
alias rgyaml='rg -t=yaml -F'

alias vrgcpp='vrg -t=cpp -F'
alias vrgpy='vrg -t=py -F'
alias vrgcmake='vrg -t=cmake -F'
alias vrgyaml='vrg -t=yaml -F'
alias vrgnix='vrg -t=nix -F'

alias def='python3 $DOTFILES/reg.py'

alias b='byobu'

alias vj='vim ~/temp.json'
alias vt='vim ~/temp.txt'
alias vy='vim ~/temp.yaml'
alias vtr='vim ~/test.txt'

alias findf='find -type f -name '
alias findd='find -type d -name '

alias replace="find ./ -type f -exec sed -i"

alias tlogin='tsh login || tsh logout && tsh login --user=dsudakov --proxy=port.bidderstack.com'


# Source goto
[[ -s "/usr/local/share/goto.sh" ]] && source /usr/local/share/goto.sh
[[ -s "/usr/local/share/vrg.sh" ]] && source /usr/local/share/vrg.sh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Clippy
if [ -f '/home/dsudakov/repos/cworkspace/concurrency-course/client/activate' ]; then . '/home/dsudakov/repos/cworkspace/concurrency-course/client/activate'; fi
if [ -f '/home/dsudakov/repos/cworkspace/concurrency-course/client/complete.bash' ]; then source /home/dsudakov/repos/cworkspace/concurrency-course/client/complete.bash; fi

# IDK why this cant be just be installed by oh-my-zsh... but im too lazy for nailing it down
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
