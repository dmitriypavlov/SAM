#/bin/bash

samVersion="2.0"

cd $(dirname $0)
trap '' SIGINT SIGQUIT SIGTSTP

# functions

nl() {
	printf "\n"
}

tab() {
	printf "\t"
}

pressEnter() {
	nl && read -p "Press Enter to continue..." fackEnterKey
}

makeSure() {
	local sure && read -p "Are you sure? [y/n]: " sure
	case $sure in
		y) clear && return 0;;
		*) echo "Task aborted" && pressEnter && return 1
	esac
}

showMenu() {
	clear
	echo "Server Administration Menu $samVersion" && nl
	echo "Host: $(hostname) ($(cat /etc/issue))"
	echo "Status: $(uptime)" 
	
	nl # Menu start
	echo "1. File manager"
	echo "2. CPU load"
	echo "3. Disk load"
	echo "4. Google DNS"
	echo "0. Exit"
	nl # Menu end
}

selectTask(){
	local task && read -p "Select task: " task
	case $task in
	
		# Task start
		1) makeSure && mc && pressEnter;;
		2) makeSure && top && pressEnter;;
		3) makeSure && iotop && pressEnter;;
		4) makeSure && ping 8.8.8.8 && pressEnter;;
		0) makeSure && exit 0;;
		# Task end

		*) echo "Pardon?" && sleep 1
	esac
}
 
# init 

while true
do
 	showMenu && selectTask
done