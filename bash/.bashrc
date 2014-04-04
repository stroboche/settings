# .bashrc

# PATH settings
PATH=/usr/local/bin:/usr/local/sbin:$PATH
export PATH

# Language setting
export LANG=ja_JP.utf-8

# Prompt setting
export PS1="\W\\$ "

# git settings
# source /usr/local/git/contrib/completion/git-prompt.sh
# source /usr/local/git/contrib/completion/git-completion.bash
# GIT_PS1_SHOWDIRTYSTATE=true

# Bash aliases
alias ls='ls -G'
alias ll='ls -l'

# Git aliases
alias gst='git status'
alias gdf='git diff'
alias gpl='git pull'
alias gco='git checkout'

# Default directory
cd ~/git
