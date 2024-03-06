export PATH=$PATH:/usr/local/git/bin:/usr/local/bin
# starship
eval "$(starship init zsh)"
# zsh
# LSCOLORS
export LSCOLORS="exfxcxdxbxexexabagacad"
alias ls='ls -G'
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
# alias python3='/opt/homebrew/Cellar/python@3.12/3.12.2_1/bin/python3.12'
alias python3='/opt/homebrew/opt/python@3.12/libexec/bin/python'
alias python=python3
alias pip=pip3
# java
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH
# grep
PATH="/opt/homebrew/Cellar/grep/3.11/libexec:$PATH"
