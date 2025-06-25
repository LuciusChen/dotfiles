export PATH=$PATH:/usr/local/git/bin:/usr/local/bin
# starship
eval "$(starship init zsh)"
# zsh
## case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
## case-insensitive (all) completion
#zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
## case-insensitive,partial-word and then substring completion
#zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
# fzf-tab
autoload -U compinit; compinit
source ~/fzf-tab/fzf-tab.plugin.zsh
# vterm
if [[ "$INSIDE_EMACS" = 'vterm' ]] \
    && [[ -n ${EMACS_VTERM_PATH} ]] \
    && [[ -f ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh ]]; then
    source ${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh
fi
# python
# 直接指定路径会导致虚拟环境的解释器依旧是指定路径的解释器
alias python=python3.12
alias pip=pip3
# java
export JAVA_HOME=$(/usr/libexec/java_home)
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk-22.0.1/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH
# grep
PATH="/opt/homebrew/Cellar/grep/3.11/libexec:$PATH"
# eza
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    autoload -Uz compinit
    compinit
fi

alias ls='eza'
alias la='eza -a'
alias ll='eza -lh'
#alias la='eza -lah'
alias lr='eza -lR'
# Homebrew
alias bupg='brew upgrade'
alias bclean='brew cleanup --prune=all'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/Users/luciuschen/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Created by `pipx` on 2024-06-24 06:51:56
export PATH="$PATH:/Users/luciuschen/.local/bin"

export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

# emacs eat
[ -n "$EAT_SHELL_INTEGRATION_DIR" ] && \
  source "$EAT_SHELL_INTEGRATION_DIR/zsh"
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi

# Function: smite
# Description: This function allows users to interactively delete command history entries using fzf.
#
# Usage:
#   smite [-a]
#
# Options:
#   -a  List all command history entries, not just those from the current session.
#
# Behavior:
#   - Without any options, it lists recent command history entries for selection.
#   - If the '-a' option is provided, it lists all commands from history.
#   - Users can select one or multiple commands to delete using the fzf interface.
#   - Selected commands will be removed from the history file.
#
# Error Handling:
#   - If an unsupported option or argument is provided, an error message is displayed and the function exits with status 1.
#
# Dependencies:
#   - This function requires fzf to be installed for the interactive selection.
function smite() {
    setopt LOCAL_OPTIONS ERR_RETURN PIPE_FAIL

    local opts=( -I )
    if [[ $1 == '-a' ]]; then
        opts=()
    elif [[ -n $1 ]]; then
        print >&2 'usage: smite [-a]'
        return 1
    fi

    fc -l -n $opts 1 | \
        fzf --no-sort --tac --multi | \
        while IFS='' read -r command_to_delete; do
            printf 'Removing history entry "%s"\n' $command_to_delete
            local HISTORY_IGNORE="${(b)command_to_delete}"
            fc -W
            fc -p $HISTFILE $HISTSIZE $SAVEHIST
        done
}
