DOTFILES="$HOME/repos/dotfiles"


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export PATH="$PATH:$HOME/.local/bin:/usr/local/share"
export ZSH_THEME="powerlevel10k/powerlevel10k"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

export LOGNAME=$USER

plugins=( 
    zsh-syntax-highlighting
    git
    history
    zsh-autosuggestions
    zsh-fzf-history-search
)

source $ZSH/oh-my-zsh.sh

setopt SHARE_HISTORY
export HISTSIZE=1000000
export SAVEHIST=$HISTSIZE
export LC_ALL="en_US.UTF-8"
setopt HIST_EXPIRE_DUPS_FIRST

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

tc() {
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

devenv() {
    # Save current directory
    local current_dir=$(pwd)

    # Go to 'bidderstack' directory
    local nix_dir="$HOME/repos/bidderstack"
    if [ ! -d "$nix_dir" ]; then
        echo "'bidderstack' directory not found"
        return 1
    fi
    cd "$nix_dir" || return 1

    # Run nix develop
    nix develop .#bidder --override-input bidderstack-bidder ../bidderstack-bidder \
        --command bash -c "\
        cd $current_dir;\
        echo \"Entered nix develop environment. Shell level \$SHLVL\";\
        $SHELL\
        "

    cd $current_dir || 1
}

bshell() {
    # Define the module mappings
    declare -A MODULES=(
        [bidder]="bidderstack-bidder:$HOME/repos/bidderstack-bidder"
        [schemas]="bidderstack-schemas:$HOME/repos/bidderstack-bidder/models/schemas"
    )

    # Define flag-to-module key mapping
    declare -A FLAG_TO_MODULE=(
        [b]="bidder"
        [s]="schemas"
    )

    OVERRIDE_INPUTS=()
    EXTRA_ARGS=()

    # Function to add module details to OVERRIDE_INPUTS
    add_module() {
        local key="$1"
        if [[ -n "${MODULES[$key]}" ]]; then
            IFS=":" read -r module_name module_path <<< "${MODULES[$key]}"
            OVERRIDE_INPUTS+=("--override-input" "$module_name" "$module_path")
        else
            echo "Error: Unknown module '$key'"
            return 1
        fi
    }

    # Parse the arguments
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -[bts]*)  # Handle single and combined flags like -b, -t, -s, -bt, -bs, etc.
                combined="${1:1}"  # Strip the leading dash
                for flag in $(echo "$combined" | sed 's/./& /g'); do
                    module_key="${FLAG_TO_MODULE[$flag]}"
                    if [[ -n "$module_key" ]]; then
                        add_module "$module_key" || return 1
                    else
                        echo "Error: Unknown flag '-$flag'"
                        return 1
                    fi
                done
                shift
                ;;
            --bidder|--tests|--schema)
                long_flag="${1#--}"  # Remove leading --
                module_key="${FLAG_TO_MODULE[${long_flag:0:1}]}"
                add_module "$module_key" || return 1
                shift
                ;;
            *)  
                # Capture extra arguments to forward them to shell.sh
                EXTRA_ARGS+=("$1")
                shift
                ;;
        esac
    done

    local current_dir=$(pwd)

    cleanup() {
        cd $1
        set +x
    }

    trap "cleanup $current_dir" INT TERM EXIT

    set -x

    # Run the command
    cd ~/repos/bidderstack-tests || { echo "Error: Could not change directory to ~/repos/bidderstack-tests"; return 1; }
    ./container/shell.sh ${EXTRA_ARGS[@]} ${OVERRIDE_INPUTS[@]}
}


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

alias vim='nvim'
alias vj='vim ~/temp.json'
alias vt='vim ~/temp.txt'
alias vy='vim ~/temp.yaml'
alias vtr='vim ~/test.txt'

alias findf='find -type f -name '
alias findd='find -type d -name '

alias replace="find ./ -type f -exec sed -i"

alias tlogin='tsh login || tsh logout && tsh login --user=dsudakov --proxy=port.bidderstack.com'
alias gitu='git push -u origin HEAD'
alias tmysql='tsh db connect mysql --db-user teleport --db-name dsp_router'
alias tch='tsh db connect ch --db-user default'
alias tmongo='tsh db connect mongo --db-user teleport --db-name main'


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

