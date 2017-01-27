#!/bin/bash

# Constants
WARN='\033[1;33m' # Yellow
NC='\033[0m' # No Color

# Global variables
BASEDIR='.'

# Find out where the sh file is stored
function update_basedir () {
    BASEDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
}

update_basedir

# Warn function
function warn () {
    printf "${WARN}$1\n${NC}";
}

# update home zshrc
function update_zshrc () {
    warn "Updating zshrc...";
    cat $BASEDIR/.zshrc > ~/.zshrc
}

# Fix zsh prompting insecure folders
function fix_zsh_secure_folder () {
    warn "Changing zsh site-functions perms...";
    cd /usr/local/share/zsh
    sudo chmod -R 755 ./site-functions
    cd $BASEDIR
}

# usage description
function usage () {
    warn "This file installs different utilities in your system.\nThe usage is as follow:"
    printf "\t-j8 --java-8\tinstall Java 8\n"
    printf "\t-m --mysql_5_6\tinstall mySQL 5.6\n"
    printf "\t-n --node\tinstall nodejs\n"
    printf "\t-p --php\tinstall php5\n"
    printf "\t-s --sublime-text\tinstall sublime text 3\n"
    printf "\t-c --composer\Iinstall php composer\n"
    printf "\t-v --vim\tinstall spf13 vim\n"
    printf "\t-z --zsh\tinstall zsh\n"
    printf "\t-h --help\tdisplay usage\n"
    printf "\t-uh --update-home\tupdate home folder files.\n\0"
}

# vim installer
function install_vim () {
    warn "Going to install vim..."
    sudo apt-get install vim-gnome
    wget -O - http://j.mp/spf13-vim3 | sh
}

# zsh installer
function install_zsh () {
    warn "Going to install zsh and oh-my-zsh, please logout after fully installed to use it."
    warn "Installing zsh."
    sudo apt-get install zsh
    warn "Installing oh-my-zsh."
    sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
    update_zshrc
    fix_zsh_secure_folder
}

# sublime text installer
function install_sublime () {
    warn "Going to install sublime text 3."
    warn "Installing sublime text 3."
    sudo add-apt-repository ppa:webupd8team/sublime-text-3
    sudo apt-get update
    sudo apt-get install sublime-text
}

# npm and nodejs installer
function install_nodejs () {
    warn "Going to install node js and npm."

    warn "Installing nodejs."
    sudo apt-get install nodejs -y
    warn "Creating node sym link..."
    sudo ln -s /usr/bin/nodejs /usr/bin/node
    update_zshrc

    warn "Installing npm."
    sudo apt-get install npm -y
    warn "Going to fix npm perms..."
    wget -O- https://raw.githubusercontent.com/glenpike/npm-g_nosudo/master/npm-g-nosudo.sh | sh
    fix_zsh_secure_folder
}

# java 8 installer
function install_java_8 () {
    warn "Going to install Java 8."

    warn "Installing Java 8."
    sudo add-apt-repository ppa:webupd8team/java
    sudo apt-get update
    sudo apt-get install oracle-java8-installer
    sudo apt-get install oracle-java8-set-default
}

# mysql 5.6 installer
function install_mysql_5_6 () {
    warn "Going to MySQL 5.6."

    warn "Installing MySQL 5.6."
    sudo apt-get update
    sudo apt-get install mysql-server
    sudo mysql_secure_installation
    sudo mysql_install_db
}

# PHP installer
function install_php() {
    warn "Going to install PHP 5."

    warn "Installing PHP 5."
    sudo apt-get update
    sudo apt-get install php5 php5-cli
}

# Install composer
function install_composer () {
    warn "Going to install Composer."

    install_php

    warn "Installing Composer."
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php -r "if (hash_file('SHA384', 'composer-setup.php') === '55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    sudo php composer-setup.php --install-dir=/usr/bin/ --filename=composer
    php -r "unlink('composer-setup.php');"
}

# Updates the git configuration in the home folder
function update_git_config () {
    warn "Updating .gitconfig..."
    cat $BASEDIR/.gitconfig > ~/.gitconfig
}

# Update home files
function update_home () {
    warn "Updating home folder files..."
    update_zshrc
    update_git_config
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
        -j8 | --java-8)         install_java_8
                                ;;
        -m | --mysql-5-6)       install_mysql_5_6
                                ;;
        -n | --node)            install_nodejs
                                ;;
       -uh | --update-home)     update_home
                                ;;
        -s | --sublime-text)    install_sublime
                                ;;
        -c | --composer)        install_composer
                                ;;
        -p | --php5)            install_php
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done
