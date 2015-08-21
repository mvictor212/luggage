alias gst='git status'
alias gsu='git submodule update --init'
alias gsuf='git submodule-helper update'
alias gco='git checkout'
alias cdgp='_CDGP=$(dirname "$PWD"); while [ ! -d "$_CDGP/.git" ] && [ "$_CDGP" != "/" ]; do _CDGP=$(dirname "$_CDGP"); done; [ "$_CDGP" != "/" ] && cd "$_CDGP"'
alias gprp='git pull --rebase && git push'
alias gsfe="git submodule foreach"
alias gba="git branch -a"
alias gs="git status -s"
alias gc="git commit"
