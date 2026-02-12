############
## Prompt ##
############
PS1='%F{blue}%~ %(?.%F{green}.%F{red})%#%f '

#############
## History ##
#############
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

##############
## Compinit ##
##############
# run compinit only one time a day
autoload -Uz compinit
if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.m-1) ]]; then
  compinit -C
else
  compinit
fi

#############
## Plugins ##
#############
# autosuggestions
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
# history substring search
source ~/.config/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
# auto-notify
source ~/.config/zsh/zsh-auto-notify/auto-notify.plugin.zsh
# syntax highlighting
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

##############
## Keybinds ##
##############
# Keybinds for history-substring-search plugin
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Enable case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

#############
## Aliases ##
#############
alias ls="ls --color -F"

############
## Export ##
############
export ANDROID_HOME="$HOME/Android/Sdk"
export NDK_HOME="$ANDROID_HOME/ndk/29.0.13846066"
export CAPACITOR_ANDROID_STUDIO_PATH=/usr/bin/android-studio
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk

# Path
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$ANDROID_HOME/cmdline-tools/latest/bin:$PATH"

