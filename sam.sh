#/bin/bash

samVersion="2.0"

cd $(dirname $0)
trap '' SIGINT SIGQUIT SIGTSTP

# functions

nl() {
	printf "\n"
}

pressEnter() {
	nl && read -p "Press Enter to continue..." fackEnterKey
}

makeSure() {
	local sure && read -p "Are you sure? [Y/n]: " sure
	case $sure in
		[yY]) clear && return 0;;
		*) echo "Task aborted" && pressEnter && return 1
	esac
}

showHelp() {
	clear && echo -e "Additional tasks:
	
	update)		Perform online update
	about)		About SAM"
}

tryUpdate() {
	echo "Update complete!"
}

showAbout() {
	echo "Version $samVersion"
}

showMenu() {
	clear
	echo "Server Administration Menu $samVersion" && nl
	echo "Host: $(hostname) ($(cat /etc/issue))"
	echo "Status: $(uptime)" 
	
	# Menu start
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
	" # Menu end
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
		?) showHelp && pressEnter;;
		update) tryUpdate && pressEnter;;
		about) showAbout && pressEnter;;
		# Task end

		*) echo "Pardon?" && sleep 1
	esac
}
 
# init 

while true
do
 	showMenu && selectTask
done