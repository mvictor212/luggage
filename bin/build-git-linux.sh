#!/bin/bash
if [ "`uname`" = "Darwin" ]; then sed_regexp="-E"; else sed_regexp="-r"; fi 
GIT_VERSION="${1:-`curl http://git.or.cz/ 2>&1 | grep "@VNUM@" | sed $sed_regexp 's/^.+-->v([0-9.]+).+$/\1/'`}"

[ ! -f git-$GIT_VERSION.tar.bz2 ] && curl -O http://kernel.org/pub/software/scm/git/git-$GIT_VERSION.tar.bz2
[ ! -d git-$GIT_VERSION ] && tar jxvf git-$GIT_VERSION.tar.bz2
pushd git-$GIT_VERSION
  make prefix=/usr/local/git all
  make prefix=/usr/local/git strip
  sudo make prefix=/usr/local/git install

  # contrib
  sudo mkdir -p /usr/local/git/contrib/completion
  sudo cp contrib/completion/git-completion.bash /usr/local/git/contrib/completion/
popd

[ ! -f git-manpages-$GIT_VERSION.tar.bz2 ] && curl -O http://www.kernel.org/pub/software/scm/git/git-manpages-$GIT_VERSION.tar.bz2
sudo mkdir -p /usr/local/man
sudo tar xjvo -C /usr/local/man -f git-manpages-$GIT_VERSION.tar.bz2


