#!/bin/bash
#
# setupCNTLM - uses the global user configuration and cntlm template to set up cntlm
#
# Author: Tom Enz, 2021
#
#
USER_CONFIG_FILE="${HOME}/.lukb.user.conf"
PROXY_EXPORTS_CONF="templates/.lukb.proxy.exports.conf"
PROXY_EXPORTS_HOMEDIR_CONF"${HOME}/.lukb.proxy.exports.conf"
CNTLM_TEMPLATE_CONF="templates/.lukb.template.cntlm.conf"
CNTLM_TEMPLATE_HOMEDIR_CONF="${HOME}/.lukb.template.cntlm.conf"
CNTLM_CONF="/usr/local/etc/cntlm.conf"
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
        cp $CNTLM_TEMPLATE_CONF $CNTLM_TEMPLATE_HOMEDIR_CONF
        cp ${CNTLM_TEMPLATE_HOMEDIR_CONF} ${CNTLM_CONF}

        echo "export http_proxy='http://localhost:3128'" >> ${PROXY_EXPORTS_HOMEDIR_CONF}
        echo "export https_proxy=${http_proxy}" >> ${PROXY_EXPORTS_HOMEDIR_CONF}
        echo "export ftp_proxy=${http_proxy}" >> ${PROXY_EXPORTS_HOMEDIR_CONF}
        echo "export HTTP_PROXY=${http_proxy}" >> ${PROXY_EXPORTS_HOMEDIR_CONF}
        echo "export HTTPS_PROXY=${http_proxy}" >> ${PROXY_EXPORTS_HOMEDIR_CONF}
        echo "export FTP_PROXY=${http_proxy}" >> ${PROXY_EXPORTS_HOMEDIR_CONF}
        echo "export no_proxy=localhost,127.0.0.1,.lucorp.ch" >> ${PROXY_EXPORTS_HOMEDIR_CONF}
        echo "export NO_PROXY=${no_proxy}" >> ${PROXY_EXPORTS_HOMEDIR_CONF}

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

        info "${GREEN}CNTLM installed and configured.${NC}"

        # Start CNTLM
        todo "Now start CNTLM manually with: ${BOLDWHITE}'sudo brew services start cntlm'${NC}..."
        info "CNTLM should then run under 'http://localhost:3128'"


    else
        error "No USER_CONFIG_FILE found in '${USER_CONFIG_FILE}'"

    fi

fi




# cat > /usr/local/etc/cntlm.conf
