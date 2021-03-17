#!/bin/bash
#
# setupCNTLM - uses the global user configuration and cntlm template to set up cntlm
#
# Author: Tom Enz, 2021
#
#
USER_CONFIG_FILE="${HOME}/.lukb.user.conf"
PROXY_EXPORTS_HOMEDIR_CONF="${HOME}/.lukb.proxy.exports.conf"
CNTLM_TEMPLATE_CONF="templates/.lukb.template.cntlm.conf"
CNTLM_TEMPLATE_HOMEDIR_CONF="${HOME}/.lukb.template.cntlm.conf"
CNTLM_CONF="/usr/local/etc/cntlm.conf"
DEFAULT_WIFI_NAME="Wi-Fi"
DEFAULT_CNTLM_HOST="127.0.0.1"
DEFAULT_CNTLM_PORT="3128"
#
# Helper Functions
#
source helper/colors.sh
source helper/outputHelper.sh

blueLines "Installing and configure CNTLM"


which cntlm 2>&1 >/dev/null
if [[ $? -ne 0 ]]; then

    which brew  2>&1 >/dev/null
    if [[ $? -eq 0 ]]; then
        brew install cntlm
    else
        error "Homebrew is not yet installed. Please install homebrew first"
    fi
else
    info "Skipping installation, since 'cntlm' is already installed!"
fi

which cntlm 2>&1 >/dev/null
if [[ $? -eq 0 ]]; then
    info "Configure 'CNTLM' ..."

    if [[ -f ${CNTLM_TEMPLATE_CONF} ]]; then
        info "Copying cntlm template to your local homedir '${HOME}' ..."
        if [[ -f ${CNTLM_TEMPLATE_HOMEDIR_CONF} ]]; then
            rm -rf CNTLM_TEMPLATE_HOMEDIR_CONF 2>&1 >/dev/null
        fi

        cp $CNTLM_TEMPLATE_CONF $CNTLM_TEMPLATE_HOMEDIR_CONF
        cp ${CNTLM_TEMPLATE_HOMEDIR_CONF} ${CNTLM_CONF}

        if [[ -f ${PROXY_EXPORTS_HOMEDIR_CONF} ]]; then
            rm -rf PROXY_EXPORTS_HOMEDIR_CONF 2>&1 >/dev/null
        fi

        echo "export http_proxy=\"http://localhost:3128\"" >> "${PROXY_EXPORTS_HOMEDIR_CONF}"
        echo "export https_proxy=\${http_proxy}" >> "${PROXY_EXPORTS_HOMEDIR_CONF}"
        echo "export ftp_proxy=\${http_proxy}" >> "${PROXY_EXPORTS_HOMEDIR_CONF}"
        echo "export HTTP_PROXY=\${http_proxy}" >> "${PROXY_EXPORTS_HOMEDIR_CONF}"
        echo "export HTTPS_PROXY=\${http_proxy}" >> "${PROXY_EXPORTS_HOMEDIR_CONF}"
        echo "export FTP_PROXY=\${http_proxy}" >> "${PROXY_EXPORTS_HOMEDIR_CONF}"
        echo "export no_proxy=localhost,127.0.0.1,.lucorp.ch" >> "${PROXY_EXPORTS_HOMEDIR_CONF}"
        echo "export NO_PROXY=\${no_proxy}" >> "${PROXY_EXPORTS_HOMEDIR_CONF}"


        grep ${PROXY_EXPORTS_HOMEDIR_CONF} $HOME/.zshrc 2>&1 >/dev/null
        if [[ $? -ne 0 ]]; then
            echo "source ${PROXY_EXPORTS_HOMEDIR_CONF}" >> $HOME/.zshrc

        fi
    fi


    if [[ -f ${USER_CONFIG_FILE} ]]; then
        source ${USER_CONFIG_FILE}
        info "Setting up '${CNTLM_CONF}' with your user specific information ..."
        echo "Username	${ADACCOUNT}" >> ${CNTLM_CONF}
        info "Next up 'cntlm -H' will generate NTLM hashes of your password for you and add them to '${CNTLM_CONF}'"
        todo "So please enter your ad password and hit <ENTER>:  "
        cntlm  -H 2>&1 | grep -E "^Pass(LM|NT)" >> ${CNTLM_CONF}


        # Checks if PW was fine
        grep PassNTLMv2 ${CNTLM_CONF} 2>&1 >/dev/null
        if [[ $? -ne 0 ]]; then
            error "Something went wrong with your NTLM password hashes, please check '${CNTLM_CONF}' manually!"
        fi


        # Add Proxy
        info "Adding proxy host '${DEFAULT_CNTLM_HOST}' + port '${DEFAULT_CNTLM_PORT}' to macOS system settings."
        info "The macOS default is called ${BOLDWHITE}'${DEFAULT_WIFI_NAME}'${NC} "
        info "You have the following networkservices available:"
        networksetup -listallnetworkservices

        read -p "Please enter the name of the networkservices above: " CHOSEN_NETWORK_SERVICE_NAME

        info "You have chosen '${CHOSEN_NETWORK_SERVICE_NAME}'. Trying to add proxy settings to it..."
        networksetup -setwebproxy ${CHOSEN_NETWORK_SERVICE_NAME} ${DEFAULT_CNTLM_HOST} ${DEFAULT_CNTLM_PORT}
        networksetup -setsecurewebproxy ${CHOSEN_NETWORK_SERVICE_NAME} ${DEFAULT_CNTLM_HOST} ${DEFAULT_CNTLM_PORT}
        networksetup -setftpproxy ${CHOSEN_NETWORK_SERVICE_NAME} ${DEFAULT_CNTLM_HOST} ${DEFAULT_CNTLM_PORT}
        networksetup -setsocksproxy ${CHOSEN_NETWORK_SERVICE_NAME} ${DEFAULT_CNTLM_HOST} ${DEFAULT_CNTLM_PORT}
        

        # Start CNTLM
        todo "Now we'll start CNTLM with: ${BOLDWHITE}'sudo brew services start cntlm'${NC}. Please enter your password..."

        sudo brew services start cntlm

        netstat -an | grep 3128 2>&1 >/dev/null
        if [[ $? -eq 0 ]]; then
            info "CNTLM should now run under 'http://localhost:3128'"
            info "${GREEN}CNTLM installed and configured.${NC}"
        else
            todo "CNTLM was not started ... Please check with ${BOLDWHITE}'sudo brew services status cntlm'${NC}. And continue manually"
            info "${GREEN}CNTLM installed and configured, but not yet started${NC}"
        fi
    else
        error "No USER_CONFIG_FILE found in '${USER_CONFIG_FILE}'"

    fi

fi




# cat > /usr/local/etc/cntlm.conf
