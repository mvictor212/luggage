echo "Moving in."
luggage_path=$(cd $(dirname "$0") && pwd)
echo "Luggage path is $luggage_path"
cd "$HOME"

$luggage_path/python/setup.sh

for file in .screenrc .vimrc .bash_profile .bashrc .vim .bash.d .gitconfig .ipython; do
  [ -L "$file" ] && rm "$file"
  [ -f "$file" ] || [ -d "$file" ] && mv "$file" "$file.bak"
done
pwd
ln -s $luggage_path/bash/bash_profile .bash_profile
ln -s $luggage_path/bash/bashrc .bashrc
ln -s $luggage_path/bash/bash.d .bash.d
ln -s $luggage_path/vim/vimrc .vimrc
ln -s $luggage_path/screenrc .screenrc
ln -s $luggage_path/rdebugrc .rdebugrc
ln -s $luggage_path/vim/ .vim
ln -s $luggage_path/bin/ bin
ln -s $luggage_path/gitconfig .gitconfig
ln -s $luggage_path/python/ipython .ipython

exec bash --login
