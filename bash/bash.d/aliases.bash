alias ll='ls -l'
alias la='ls -la'
alias tp='ssh transporter@hq.leadmediapartners.com -p 3022'
alias upme='[ -d $HOME/luggage ] && pushd $HOME/luggage/ || pushd /var/luggage && git pull && git submodule update --init && . $HOME/.bash_profile && popd'
alias screen='TERM=screen screen'
alias awk2="awk '{print \$2}'"
alias awk2kill="awk '{print \$2}' | xargs kill"
alias be="bundle exec"
alias gsfe="git submodule foreach"
alias gba="git branch -a"
alias gco="git checkout"
alias gs="git status -s"
alias gc="git commit"
