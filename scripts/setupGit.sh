#!/bin/bash
#
# setupGit - uses the global user configuration to set up your git
#
# Author: Tom Enz, 2021
#
#
USER_CONFIG_FILE="${HOME}/.lukb.user.conf"
#
# Helper Functions
#
source helper/colors.sh
source helper/outputHelper.sh

blueLines "Configuring GIT"

info "Setting user to global git config"

if [[ -f ${USER_CONFIG_FILE} ]]; then
   source ${USER_CONFIG_FILE}
   
   git config --global user.name "${FIRSTNAME} ${LASTNAME} [${ADACCOUNT}]"
   git config --global user.email "${EMAIL}"
fi