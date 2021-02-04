#!/bin/bash
#
# install.sh - macOS Software Installer Script 
#
# Author: Tom Enz, 2021
#
#
HOMEDIR="${HOME}"
FILE_PREFIX=".lukb"


#
# Helper Functions
#
source helper/colors.sh
source helper/outputHelper.sh
source helper/asciiDevLabLogo.sh

while getopts d flag
do
    case "${flag}" in
        d) DEBUG_FLAG=1;;
    esac
done
#
# MAIN
#
info "Starting the DevLab macOS installer..."

todo "You might want to remove all the macOS default dock applications!"
todo "If yes, use the following command in a new terminaL: ${BOLDWHITE}'defaults delete com.apple.dock persistent-apps; killall Dock'${NC}..."
read -p "Press any key to continue... " -n1 -s
echo -e "\n"

# Setup the local user
./scripts/setupUser.sh

# Setup Homebrew and install software
./scripts/setupHomebrew.sh $1

# Setup Git
./scripts/setupGit.sh $1

info "${GREEN}DevLab macOS Installer finished.${NC}"
todo "After the installation you need to continue with DevLab Config Tool and/or restart your computer and use the tools."





