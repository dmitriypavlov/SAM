#/bin/bash

samVersion="2.1"

self="${0##*/}"
cd "${0%/*}"
trap '' SIGINT SIGQUIT SIGTSTP

# functions

bold=$(tput bold)
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
		*) echo "${bold}Task aborted${normal}" && pressEnter && return 1
	esac
}

showHelp() {
	clear && echo -e "${bold}Additional tasks${normal}
	
	update)		Perform online update
	about)		About SAM"
}

tryUpdate() {
	curl -so "./$self" "https://raw.githubusercontent.com/dmitriypavlov/SAM/master/$self" && sudo chmod +x "./$self" && pressEnter && exec "./$self"
}

showAbout() {
	echo "Version $samVersion ($self)"
}

showMenu() {
	clear
	echo "${bold}Server Administration Menu $samVersion${normal}" && nl
	echo "Host: $(hostname) ($(cat /etc/issue))"
	echo "Status: $(uptime)" 
	
	# Menu
	echo -e "
	1) File manager		10) Task 10
	2) CPU load		11) Task 11
	3) Disk load		12) Task 12
	4) Google DNS		13) Task 13
	5) Task 5		14) Task 14
	6) Task 6		15) Task 15
	7) Task 7		16) Task 16
	8) Task 8		17) Task 17
	9) Task 9		18) Task 18
	
	0) Exit			?) Help
	"
}

selectTask(){
	local task && read -p "${bold}Select task:${normal} " task
	case $task in
	
		# Tasks
		1) makeSure && mc && pressEnter;;
		2) makeSure && top && pressEnter;;
		3) makeSure && iotop && pressEnter;;
		4) makeSure && ping 8.8.8.8 && pressEnter;;
		0) makeSure && exit 0;;
		
		# System
		?) showHelp && pressEnter;;
		
		# Help
		update) makeSure && tryUpdate;;
		about) showAbout && pressEnter;;
		
		# Error
		*) echo "${bold}Pardon?${normal}" && sleep 1
	esac
}
 
# init 

while true
do
 	showMenu && selectTask
done