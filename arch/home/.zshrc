export PATH=$PATH:/usr/local/git/bin:/usr/local/bin:/opt:
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
# starship
eval "$(starship init zsh)"
# zsh
## case-insensitive (uppercase from lowercase) completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# case-insensitive (all) completion
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
# case-insensitive,partial-word and then substring completion
# zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# dnf install zsh-autosuggestions zsh-syntax-highlighting fzf 默认是安装在 /usr/share 下
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf/key-bindings.zsh
source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
autoload -U compinit; compinit
# 切换 shell 为 zsh --> $ chsh -s $(which zsh)
# 如果不成功的话，重启电脑。
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
