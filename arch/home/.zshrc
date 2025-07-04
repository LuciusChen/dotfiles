export PATH=$PATH:/usr/local/git/bin:/usr/local/bin:/usr/share/DataGrip/bin:
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
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi
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
