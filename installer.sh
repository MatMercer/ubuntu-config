#!/bin/bash

# Constants
WARN='\033[1;33m' # Yellow
NC='\033[0m' # No Color

# Global variables
BASEDIR='.'

# usage description
function usage () {
    # TODO: Update usage
    printf "This file installs different utilities in your system.\nThe usage is as follow:\n"
    printf "\t-n --node\tinstall nodejs\n"
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
    update_zshrc
    fix_zsh_secure_folder
}

# npm and nodejs installer
function install_nodejs () {
    printf "${WARN}Going to install node js and npm.\n${NC}"

    printf "${WARN}Installing nodejs.\n${NC}"
    sudo apt-get install nodejs -y
    printf "${WARN}Creating node sym link...\n${NC}"
    sudo ln -s /usr/bin/nodejs /usr/bin/node
    update_zshrc

    printf "${WARN}Installing npm.\n${NC}"
    sudo apt-get install npm -y
    printf "${WARN}Going to fix npm perms...\n${NC}"
    wget -O- https://raw.githubusercontent.com/glenpike/npm-g_nosudo/master/npm-g-nosudo.sh | sh
    fix_zsh_secure_folder
}

# Find out where the sh file is stored
function update_basedir () {
    BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

update_basedir

# update home zshrc
function update_zshrc () {
    printf "${WARN}Updating zshrc...\n${NC}";
    cat $BASEDIR/.zshrc > ~/.zshrc
}

# Fix zsh prompting insecure folders
function fix_zsh_secure_folder () {
    printf "${WARN}Changing zsh site-functions perms...\n${NC}";
    cd /usr/local/share/zsh
    sudo chmod -R 755 ./site-functions
    cd $BASEDIR
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
        -n | --node)            install_nodejs
                                ;;
        -u | --updatezshrc)     update_zshrc
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
