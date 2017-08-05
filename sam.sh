#!/usr/bin/env bash

samVersion="2.2"
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

pressEnter() {
	nl && read -p "${bold}Press Enter to continue...${normal}" fackEnterKey
}

makeSure() {
	local sure && read -p "${bold}Are you sure? [Y/n]:${normal} " sure
	case $sure in
		[yY]) clear && return 0;;
		*) echo "${bold}${red}Task aborted${normal}" && pressEnter && return 1
	esac
}

showHelp() {
	clear && echo "${bold}${invert} Additional tasks ${normal}
	
	install		Install to $profile
	uninstall	Uninstall from $profile
	update		Perform online update
	about		About SAM"
}

makeInstall() {
	echo -e "alias sam='$samPath/$samFile'\nsam" >> $profile
	sudo chmod +x "$samPath/$samFile"
}

makeUninstall() {
	sed -i '/sam/d' $profile || sed -i '' '/sam/d' $profile # macOS
}

makeUpdate() {
	curl -so "$samPath/$samFile" "https://raw.githubusercontent.com/dmitriypavlov/SAM/master/$samFile" && pressEnter && exec "$samPath/$samFile"
}

showAbout() {
	echo "Version $samVersion ($samFile)"
}

showMenu() {
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

selectTask() {
	local task && read -p "${bold}Select task:${normal} " task
	case $task in
		
		# Tasks
		(1) makeSure && echo "Task 1 selected" && pressEnter;;
		(2) makeSure && echo "Task 2 selected" && pressEnter;;
		
		(0) makeSure && exit 0;;
		("?") showHelp && pressEnter;;
		("install") makeSure && makeInstall;;
		("uninstall") makeSure && makeUninstall;;
		("update") makeSure && makeUpdate;;
		("about") showAbout && pressEnter;;
		
		(*) echo "${bold}${red}Pardon?${normal}" && sleep 1
	esac
}
 
# init 

trap '' SIGINT SIGQUIT SIGTSTP

while true
do
 	showMenu && selectTask
done