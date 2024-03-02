export PATH=$PATH:/usr/local/git/bin:/usr/local/bin
# starship
eval "$(starship init zsh)"
# zsh
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
alias python3='/opt/homebrew/Cellar/python@3.11/3.11.8/bin/python3.11'
alias python=python3
alias pip=pip3
# java
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_79.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH
# grep
PATH="/opt/homebrew/Cellar/grep/3.11/libexec:$PATH"
