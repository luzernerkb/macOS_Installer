#!/bin/bash
#
# macOS Software Installer Script 
#
# Author: Tom Enz, 2021
# Usage: /bin/bash -c "$(curl -fsSL https://enz.lu/macos-installer)"
#
#
HOMEDIR="${HOME}"
FILE_PREFIX=".lukb"


#
# Helper Functions
#
source helperScripts/colors.sh
source helperScripts/outputHelper.sh
source helperScripts/asciiDevLabLogo.sh

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
./setupUser.sh

# Setup Homebrew and install software
./setupHomebrew.sh $1

# Setup Git
./setupGit.sh $1

info "${GREEN}DevLab macOS Installer finished.${NC}"
todo "After the installation you need to continue with DevLab Config Tool and/or restart your computer and use the tools."





