#!/bin/bash
#
# setupGit - uses the global user configuration to set up your git
#
# Author: Tom Enz, 2021
#
#
USER_CONFIG_FILE="${HOME}/.lukb.user.conf"
GIT_CONFIG_FILE="${HOME}/.lukb.user.conf"
#
# Helper Functions
#
source helperScripts/colors.sh
source helperScripts/outputHelper.sh

blueLines "Configuring GIT"

if [[ -f ${USER_CONFIG_FILE} ]]; then
   source ${USER_CONFIG_FILE}
   
   git config --global user.name "${FIRSTNAME} ${LASTNAME} [${ADACCOUNT}]"
   git config --global user.email "${EMAIL}"
fi