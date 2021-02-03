
info () {
	echo -e "${BLUE}INFO:${NC} ${1}"
}
todo () {
	echo -e "${YELLOW}TODO:${NC} ${1}"
}

error () {
	echo -e "${RED}ERROR:${NC} ${1}"
    exit 1
}

blueLines() {
   echo -e "${BLUE}###############################################################################${NC}" 
   echo -e "${BLUE}#${NC}"
   echo -e "${BLUE}#${NC} ${1}"
   echo -e "${BLUE}#${NC}"
   echo -e "${BLUE}###############################################################################${NC}"
}