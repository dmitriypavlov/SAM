#!/usr/bin/env bash

samVersion="0.3-dev"
samPath="${0%/*}"
samFile="${0##*/}"

profile=~/.profile

# functions

bold=$(tput bold)
red=$(tput setaf 1)
invert=$(tput rev)
normal=$(tput sgr0)

nl() {
	printf "\n"
}

uiTitle() {
	echo -n -e "\033k$1\033\\"
}

uiEnter() {
	nl && read -p "${bold}Press Enter to continue...${normal}" fackEnterKey
}

uiSure() {
	local sure && read -p "${bold}Are you sure? [Y/n]:${normal} " sure
	case $sure in
		([yY]) clear && return 0;;
		(*) echo "${bold}${red}Task aborted${normal}" && uiEnter && return 1
	esac
}

uiHelp() {
	clear
	echo "${bold}${invert} Additional tasks ${normal}
	
	install		Install to $profile
	uninstall	Uninstall from $profile
	update		Perform online update
	about		About SAM"
}

sysInstall() {
	sudo chmod +x "$samPath/$samFile"
	if ! grep -q "#autosam" "$profile"; then
		echo -e "alias sam='$samPath/$samFile' #autosam\nsam #autosam" >> "$profile"
	fi
}

sysUninstall() {
	sed -i "/#autosam/d" $profile || sed -i "" "/#autosam/d" $profile # macOS
}

sysUpdate() {
	curl -so "$samPath/$samFile" "https://raw.githubusercontent.com/dmitriypavlov/SAM/master/$samFile" && uiEnter && exec "$samPath/$samFile"
}

uiAbout() {
	echo "Version $samVersion ($samPath/$samFile)"
}

uiMenu() {
	clear
	echo "${bold}${invert} Server Administration Menu $samVersion ${normal}" && nl
	echo "Host: $(hostname) ($(cat /etc/issue.net))"
	echo "Status: $(uptime)" 
	
	# Menu
	echo "
	?. Help		0. Exit
	1. Task 1	2. Task 2
	"
}

uiTask() {
	local task && read -p "${bold}Select task:${normal} " task
	case $task in
		
		# Tasks
		(1) {
			uiSure && 
			echo "Task 1 selected" &&
			uiEnter
		};;
		
		(2) {
			uiSure &&
			echo "Task 2 selected" &&
			uiEnter
		};;
		
		(0) uiSure && exit 0;;
		
		("?") uiHelp && uiEnter;;
		("install") uiSure && sysInstall;;
		("uninstall") uiSure && sysUninstall;;
		("update") uiSure && sysUpdate;;
		("about") uiAbout && uiEnter;;
		
		(*) echo "${bold}${red}Pardon?${normal}" && sleep 1
	esac
}
 
# init 

uiTitle "SAM @ $(hostname -s)"
trap '' SIGINT SIGQUIT SIGTSTP

while true
do
 	uiMenu && uiTask
done