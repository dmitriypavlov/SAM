#!/usr/bin/env bash

# TODO
# default tasklist download from github
# cli mode (task as parameter)
# cron mode

# variables

samVersion="0.4b"
samUpdate="https://raw.githubusercontent.com/dmitriypavlov/SAM/master/sam.sh"
samDefault="https://raw.githubusercontent.com/dmitriypavlov/SAM/master/sam.inc"
profile=~/.profile

# utilities

samPath="${0%/*}"
samSelf="${0##*/}"
samInc="${samDefault##*/}"

bold=$(tput bold)
red=$(tput setaf 1)
invert=$(tput rev)
normal=$(tput sgr0)

newline() {
	printf "\n"
}

samTitle() {
	echo -n -e "\033k$1\033\\"
}

isMac() {
	if [[ $(uname -s) == "Darwin" ]]; then
		return 0
	else
		return 1
	fi
}

# functions

samAbout() {
	clear; echo "${bold}${invert} About SAM ${normal}"; newline
	echo "version $samVersion ($samPath/$samSelf)"
}

samHelp() {
	clear; echo "${bold}${invert} SAM Help ${normal}

	about		About SAM
	help		This SAM Help
	install		Install to $profile
	uninstall	Uninstall from $profile
	update		Perform online update
	exit		Exit SAM"
}

samInstall() {
	sudo chmod +x "$samPath/$samSelf"
	if ! grep -q "#autosam" "$profile"; then
		echo -e "alias sam='$samPath/$samSelf' #autosam\nsam #autosam" >> "$profile" &&
		echo "Installed to $profile"; samPause
	fi
}

samUninstall() {
	isMac && sed -i "" "/#autosam/d" $profile || sed -i "/#autosam/d" $profile &&
	echo "Uninstalled from $profile"; samPause
}

samUpdate() {
	isMac && curl -s -o "$samPath/$samSelf" "$samUpdate" || wget -q -O "$samPath/$samSelf" "$samUpdate"
	samPause; exec "$samPath/$samSelf"
}

samPause() {
	newline; read -p "${bold}Press Enter to continue...${normal}" fackEnterKey
}

samConfirm() {
	newline; local confirm; read -p "${bold}Are you sure? [Y/n]:${normal} " confirm
	
	if [[ "$confirm" == "Y" || "$confirm" == "y" ]]; then
		clear; return 0
	else
		echo "${bold}${red}Task aborted${normal}"
		samPause; return 1
	fi
}

samBanner() {
	clear; echo "${bold}${invert} Server Administration Menu @ $(hostname) ${normal}"
}

samDefault() {
	if [ ! -e "$samPath/$samInc" ]; then
		isMac && curl -s -o "$samPath/$samInc" "$samDefault" || wget -q -O "$samPath/$samInc" "$samDefault"
	fi
}

samTask() { 

	sam_?() { sam_help; }
	sam_exit() { samConfirm && exit 0; }
	sam_help() { samHelp; samPause; }
	sam_install() { samConfirm && samInstall; }
	sam_uninstall() { samConfirm && samUninstall; }
	sam_update() { samConfirm && samUpdate; }
	sam_about() { samAbout; samPause; }
	
	source "$samPath/$samInc"
	
	read -p "${bold}Select task [?]:${normal} " task
	
	if type "sam_$task" &> /dev/null; then
		"sam_$task"
	else
		echo "${bold}${red}Task error${normal}"
		sleep 1
	fi
}
 
# main

trap '' SIGINT SIGQUIT SIGTSTP
samTitle "SAM @ $(hostname -s)"
samDefault

while true
do
 	samBanner
 	samTask
done