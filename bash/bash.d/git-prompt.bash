export PS1="\[\e[01;32m\]\u@\h\[\e[00m\]:\[\e[01;34m\]\w\[\e[00m\] \[\e[01;33m\]\`git branch 2>&1 | grep '*' | awk '{print \$2}'\`\[\e[00m\]\[\e[01;31m\]\$\[\e[00m\] "
