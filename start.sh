#!/bin/bash

# HACK-CAMERA 
# Version    : 2.1
# Description: CameraHackHack is a camera Phishing tool. Send a phishing link to victim, if he/she gives access to camera, his/her photo will be captured!
# Author     : SomniumN1 ( Ashera )
# Github     : https://github.com/Ashera12
# Join Us    : 
# Date       : 29-05-2022
# Language   : Shell, HTML, Css
# Portable File
# If you copy, consider giving credit! We keep our code open source to help others


# Colors

clear
mkdir Tools
clear 



black="\033[1;30m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
blue="\033[1;34m"
purple="\033[1;35m"
cyan="\033[1;36m"
violate="\033[1;37m"
white="\033[0;37m"
nc="\033[00m"

# Output snippets
info="${red}[${white}+${red}] ${cyan}"
ask="${red}[${white}?${red}] ${violate}"
error="${cyan}[${white}!${cyan}] ${red}"
success="${red}[${white}√${red}] ${green}"


cwd=`pwd`

# Logo 
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
echo -e "$logo" 

echo -e '\033[31;40;1m 

\033[33;4mVersion:\033[0m 0.4            \033[33;4mCTRL+C:\033[0m exit          \033[33; @@bilanazhmii|\033[0m @SomniumN1

\e[37m[1]\e[36m CamPhish V1        			\e[37m[2]\e[36m CamPhish V2
                   		

'

#pilihan


read -p "Choose : " choosen
if [[ $choosen == 1 || $choosen == 01 ]]; then
clear

echo -e "\033[47;31;5m CamPhish V1...\033[0m"
sleep 5
clear
echo -e "\033[47;3;35m SOMNIUMN1 >>BILANAZMI<< ( ASHERA12 )\033[0m"
sleep 3
bash camphish.sh

elif [[ $choosen == 2 || $choosen == 02 ]]; then
clear
echo -e "\033[47;3;35m CamPhish V2\033[0m"
sleep 3
clear
echo -e "\033[47;3;35m SOMNIUMN1 THAT'S NAME I LIKE \033[0m"
sleep 3
bash hack_camera.sh
aut

else   
	clear
        echo -e '\033[36;40;1m JUST HOPING TO BE HER HOPE :)'	
	sleep 1
	clear 
	bash start.sh
fi