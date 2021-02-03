#!/bin/bash
#
# setupHomebrew - Sets up Homebrew package manager and installs some
#
# Author: Tom Enz, 2021
#
#
#
# Helper Functions
#
source helperScripts/colors.sh
source helperScripts/outputHelper.sh

while getopts d flag
do
    case "${flag}" in
        d) DEBUG_FLAG=1;;
    esac
done

if [[ ${DEBUG_FLAG} -eq 1 ]];then
    echo -e "${YELLOW}INFO: Debug Mode active ...${NC}"
fi

bi () {
	if [[ ${DEBUG_FLAG} -eq 1 ]]; then
		echo brew install $1
	elif [[ ${DEBUG_FLAG} -eq 0 ]]; then
		brew install $1
	fi  
}

bci () {
	if [[ ${DEBUG_FLAG} -eq 1 ]]; then
		echo brew install --cask $1
	elif [[ ${DEBUG_FLAG} -eq 0 ]]; then
		brew install --cask $1
	fi  
}

bcia () {
	if [[ ${DEBUG_FLAG} -eq 1 ]]; then
		echo brew install --cask --appdir="/Applications" $1
	elif [[ ${DEBUG_FLAG} -eq 0 ]]; then
		brew install --cask --appdir="/Applications" $1
	fi  
}


#
# Main
#
blueLines "HOMEBREW"
info "Please follow the output carefully. Note: If homebrew hangs ...  CTRL+C once and it will continue to the next cask."
export HOMEBREW_NO_AUTO_UPDATE=1
if [[ -f ~/.zshrc ]]; then
    grep HOMEBREW_NO_AUTO_UPDATE ~/.zshrc  2>&1 >/dev/null

    if [[ $? -ne 0 ]]; then
        info "Appending 'HOMEBREW_NO_AUTO_UPDATE=1' to file '~/.zshrc', since it did not exist"
        echo "export HOMEBREW_NO_AUTO_UPDATE=1" >> ~/.zshrc
    fi
fi



echo -e "${YELLOW}TODO:${NC} First, please install Xcode, Apple Configurator2 + Transporter from Apple AppStore!"
# no solution to automate AppStore installs
read -p "Press any key to continue... " -n1 -s
echo -e "\n"

info "Installing Homebrew..."
which brew  2>&1 >/dev/null
if [[ $? -eq 0 ]]; then
    info "Skipping installation, since 'brew' is already installed!"
else
    if [[ ${DEBUG_FLAG} -ne 1 ]]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
        echo 'PATH="/usr/local/bin:$PATH"' >> ~/.zshrc
    fi
fi

info "Installing basic tools..."
bi node
bi nvm
bi python
bi maven
#bi brew-cask
bcia adoptopenjdk

info "Installing development tools..."
bcia iterm2
bcia sublime-text
bcia sourcetree
bcia charles
bcia visual-studio-code
bcia postman
bcia cyberduck

info "Installing mobile development tools..."
bcia android-studio
bcia android-platform-tools

info "Installing virtualization tools..."
bcia docker

info "Installing Browsers (Firefox, Chrome + Edge)..."
bcia firefox
bcia google-chrome
bcia microsoft-edge


info "Installing Security Tools..."
bcia keepassxc
bcia little-snitch
info "Add additional security Tools ${BOLDWHITE}https://objective-see.com/products.html${NC}"


info "Installing communication tools..."
bci slack
bci cisco-jabber


echo -e "${BOLDCYAN}###############################################################################${NC}  "  
info "The following tools (Webex Meetings, VirtualBox) mount a disk and need to be installed manually ..."
bci webex-meetings
bcia virtualbox

echo -e "${BOLDCYAN}###############################################################################${NC} "   