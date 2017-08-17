#!/usr/bin/env bash

# variables

samVersion="0.5"
samUpdate="https://raw.githubusercontent.com/dmitriypavlov/SAM/master/sam.sh"
samDefault="https://raw.githubusercontent.com/dmitriypavlov/SAM/master/sam.inc"
profile=~/.profile

# utilities

samPath="${0%/*}"
samSelf="${0##*/}"
samInc="${samDefault##*/}"

invert() { printf "\e[?5h"; }
revert() { printf "\e[?5l"; }
bell() { printf "\a"; }
newline() { printf "\n"; }
title() { echo -n -e "\033k$1\033\\"; }
bold=$(tput bold)
red=$(tput setaf 1)
reverse=$(tput rev)
normal=$(tput sgr0)

isMac() {
	if [[ $(uname -s) == "Darwin" ]]; then
		return 0
	else
		return 1
	fi
}

# functions

samInit() { exec "$samPath/$samSelf"; }
samProfile() { nano "$profile"; }

samInstall() {
	sudo chmod +x "$samPath/$samSelf"
	if ! grep -q "#autosam" "$profile"; then
		isMac && echo -e "alias sam=\"'$samPath/$samSelf'\" #autosam\nsam #autosam" >> "$profile" ||
		echo -e "alias sam='$samPath/$samSelf' #autosam\nsam #autosam" >> "$profile" &&
		echo "Installed to $profile"; samPause
	fi
}

samUninstall() {
	isMac && sed -i "" "/#autosam/d" "$profile" || sed -i "/#autosam/d" "$profile" &&
	echo "Uninstalled from $profile"; samPause
}

samUpdate() {
	isMac && curl -s -o "$samPath/$samSelf" "$samUpdate" || wget -q -O "$samPath/$samSelf" "$samUpdate"
	samPause; samInit
}

samConfirm() {
	newline; local confirm; read -p "${bold}Are you sure? [Y/n]:${normal} " confirm
	
	if [[ "$confirm" == "Y" || "$confirm" == "y" ]]; then
		clear; return 0
	else
		bell; echo "${bold}${red}Task aborted${normal}"
		samPause; samInit
	fi
}

samWait() { echo "Please wait..."; }

samPause() { newline; read -p "${bold}Press Enter to continue...${normal}" fackEnterKey; }

samAbout() {
	clear; echo "${bold}${reverse} About SAM ${normal}"; newline
	echo "version $samVersion ($samPath/$samSelf)"
}

samHelp() {
	clear; echo "${bold}${reverse} SAM Help ${normal}

	about		About SAM
	help		This help
	profile		Edit $profile
	install		Install to $profile
	uninstall	Uninstall from $profile
	update		Online update $samPath/$samSelf
	tasks		Edit $samPath/$samInc
	exit		Exit SAM"
}

samBanner() {
	clear; echo "${bold}${reverse} Server Administration Menu @ $(hostname) ${normal}"
}

samDefault() {
	if [ ! -e "$samPath/$samInc" ]; then
		isMac && curl -s -o "$samPath/$samInc" "$samDefault" || wget -q -O "$samPath/$samInc" "$samDefault"
	fi
}

samTasks() { nano "$samPath/$samInc" && samInit; }

samTask() { 
	sam_about() { samAbout; samPause; }
	sam_help() { invert; samHelp; samPause; revert; }
	sam_?() { sam_help; }
	sam_profile() { samProfile; }
	sam_install() { samConfirm && samInstall; }
	sam_uninstall() { samConfirm && samUninstall; }
	sam_update() { samConfirm && samUpdate; }
	sam_tasks() { samTasks; }
	sam_exit() { samConfirm && exit 0; }
	
	source "$samPath/$samInc" 2> /dev/null || echo -e "\n${bold}${red}$samPath/$samInc source error!${normal}\n"
	
	read -p "${bold}Select task [?]:${normal} " task
	
	if type "sam_$task" &> /dev/null; then
		"sam_$task"
	else
		bell; echo "${bold}${red}Task error${normal}"
		sleep 1
	fi
}
 
# main

trap '' SIGINT SIGQUIT SIGTSTP
title "SAM @ $(hostname -s)"
samDefault

while true
do
 	samBanner
 	samTask
done