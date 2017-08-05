#/bin/bash

samVersion="2.1"
samPath="${0%/*}"
samFile="${0##*/}"

profile=~/.bash_profile

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
	clear && echo -e "${bold}Additional tasks${normal}
	
	install)	Install to .bash_profile
	uninstall)	Uninstall from .bash_profile
	update)		Perform online update
	about)		About SAM"
}

makeInstall() {
	if [ ! -e $profile.bak ]; then
		cp $profile $profile.bak
	fi
	echo -e "\nalias sam=$samPath/$samFile\nsam" >> $profile
}

makeUninstall() {
	sed -i '/sam/d' $profile
	sed -i '' '/sam/d' $profile # macOS
}

makeUpdate() {
	curl -so "$samPath/$samFile" "https://raw.githubusercontent.com/dmitriypavlov/SAM/master/$samFile" && sudo chmod +x "$samPath/$samFile" && pressEnter && exec "$samPath/$samFile"
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
	echo -e "
	1) File manager		2) Google DNS
	
	0) Exit			?) Help
	"
}

selectTask(){
	local task && read -p "${bold}Select task:${normal} " task
	case $task in
	
		# Tasks
		1) makeSure && mc && pressEnter;;
		2) makeSure && ping 8.8.8.8 && pressEnter;;
		
		0) makeSure && exit 0;;
		\?) showHelp && pressEnter;;
		
		install) makeSure && makeInstall;;
		uninstall) makeSure && makeUninstall;;
		update) makeSure && makeUpdate;;
		about) showAbout && pressEnter;;
		q) exit 0;;
		
		*) echo "${bold}${red}Pardon?${normal}" && sleep 1
	esac
}
 
# init 

cd $samPath
trap '' SIGINT SIGQUIT SIGTSTP

while true
do
 	showMenu && selectTask
done