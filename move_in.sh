echo "Moving in."
luggage_path=$(cd $(dirname "$0") && pwd)
echo "Luggage path is $luggage_path"
cd "$HOME"

$luggage_path/python/setup.sh
$luggage_path/spark/setup.sh

for file in .screenrc .irbrc .vimrc .bash_profile .bashrc .vim .bash.d bin .gitconfig .ipython; do
  [ -L "$file" ] && rm "$file"
  [ -f "$file" ] || [ -d "$file" ] && mv "$file" "$file.bak"
done
pwd
ln -s $luggage_path/bash/bash_profile .bash_profile
ln -s $luggage_path/bash/bashrc .bashrc
ln -s $luggage_path/bash/bash.d .bash.d
ln -s $luggage_path/vim/vimrc .vimrc
ln -s $luggage_path/irbrc .irbrc
ln -s $luggage_path/screenrc .screenrc
ln -s $luggage_path/rdebugrc .rdebugrc
ln -s $luggage_path/vim/ .vim
ln -s $luggage_path/bin/ bin
ln -s $luggage_path/gitconfig .gitconfig
ln -s $luggage_path/python/ipython .ipython

if [ -w $luggage_path/.git/config ]; then
  echo "updating submodules"
  pushd $luggage_path
  git submodule update --init
  popd
fi
exec bash --login
