export PATH=$PATH:/usr/local/git/bin:/usr/local/bin
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
source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/fzf/shell/key-bindings.zsh
# fzf-tab
# 为了一致性，这个也 git clone https://github.com/Aloxaf/fzf-tab ~/fzf-tab 后 mv 到 /usr/share
autoload -U compinit; compinit
source /usr/share/fzf-tab/fzf-tab.plugin.zsh
# 切换 shell 为 zsh --> $ chsh -s $(which zsh)
# 如果不成功的话，重启电脑。
