#!/bin/bash

# Constants
WARN='\033[1;33m' # Yellow
NC='\033[0m' # No Color

# usage description
function usage () {
    printf "This file installs different utilities in your system.\nThe usage is as follow:\n"
    printf "\t-v --vim\tinstall spf13 vim\n"
    printf "\t-z --zsh\tinstall zsh\n"
    printf "\t-h --help\tdisplay usage\n\0"
}

# vim installer
function install_vim () {
    sudo apt-get install vim-gnome
    wget -O - http://j.mp/spf13-vim3 | sh
}

# zsh installer
function install_zsh () {
    printf "${WARN}Going to install zsh and oh-my-zsh, please logout after fully installed to use it.\n${NC}"
    printf "${WARN}Installing zsh.\n${NC}"
    sudo apt-get install zsh
    printf "${WARN}Installing oh-my-zsh.\n${NC}"
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    cat ./.zshrc > ~/.zshrc
}

if [ $# -eq 0 ]
then
    usage
fi

while [ "$1" != "" ]; do
    case $1 in
        -v | --vim)             shift
                                install_vim
                                ;;
        -z | --zsh)             install_zsh
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
