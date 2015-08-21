#!/bin/bash

sudo easy_install pip
sudo pip install virtualenv
sudo pip install virtualenvwrapper

mkdir -p $HOME/.virtualenvs

source /usr/local/bin/virtualenvwrapper.sh

mkvirtualenv data
#pip install -r requirements.txt
