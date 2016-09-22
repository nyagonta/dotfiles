#!/bin/bash

DOT_DIR=~/dotfiles

echo "Installing/Updating dotfiles..."

if [ ! -d $DOT_DIR ]; then
    echo "Cloning dotfiles"
    git clone https://github.com/nyagonta/dotfiles.git
else
	echo "Updating dotfiles"
	cd $DOT_DIR && git pull
fi

for f in .??*
do
    [[ $f = ".git" ]] && continue
    [[ $f = ".gitignore" ]] && continue
    ln -snfv ~/dotfiles/$f ~/$f
done

echo Done!
