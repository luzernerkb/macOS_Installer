#!/bin/bash
#
# setupUser - will write your userinformation to a .dotfile for later usage by git
#
# Author: Tom Enz, 2021
#
#
USER_CONFIG_FILE="$HOME/.lukb.user.conf"
#
# Helper Functions
#
source ../helper/colors.sh
source ../helper/outputHelper.sh

if [[ -f ${USER_CONFIG_FILE} ]]; then
    info "Skipping configuration, since there is already a file called '${USER_CONFIG_FILE}'"
    exit 1
else

    blueLines "setupUser"
    todo "To configure all the tools correctly, you need to provide some information about you:"


    read -p "Please enter your firstname:  " USER_FIRSTNAME 
    read -p "Please enter your lastname:  " USER_LASTNAME
    read -p "Please enter your LUKB email:  " USER_EMAIL
    read -p "Please enter your LUKB ad account:  " USER_ACCOUNT
    todo "Hello ${USER_FIRSTNAME} ${USER_LASTNAME}, with email: ${USER_EMAIL} and account: ${USER_ACCOUNT}"
    read -p "Please check, is everything correct? Press any key to continue... (CTRL+C to cancel) " -n1 -s
    echo -e "\n"


    # Writing config configfile
    info "Writing data to ${BOLDWHITE}'${USER_CONFIG_FILE}' ${NC}"

    if [[ -f ${USER_CONFIG_FILE} ]]; then
        rm -rf ${USER_CONFIG_FILE}
    fi

    echo "# This is a config file, used by several scripts" >> ${USER_CONFIG_FILE}
    echo "FIRSTNAME=${USER_FIRSTNAME}" >> ${USER_CONFIG_FILE}
    echo "LASTNAME=${USER_LASTNAME}" >> ${USER_CONFIG_FILE}
    echo "EMAIL=${USER_EMAIL}" >> ${USER_CONFIG_FILE}
    echo "ADACCOUNT=${USER_ACCOUNT}" | tr [:lower:] [:upper:] >> ${USER_CONFIG_FILE}

fi