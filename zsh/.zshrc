# Created by newuser for 5.9

PS1='%F{blue}%~ %(?.%F{green}.%F{red})%#%f '

#set history size
export HISTSIZE=10000
#save history after logout
export SAVEHIST=10000
#history file
export HISTFILE=~/.zhistory
#append into history file
setopt INC_APPEND_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY

# Plugins
# 1
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# 2
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
# 3
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Keybinds
# Keybinds for history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
