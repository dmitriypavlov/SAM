echo "
	1. File manager
	2. Reboot system
	3. Shutdown system
	4. Update system
	5. Compact storage
"

sam_1() {
	mc
}

sam_2() {
	samConfirm &&
	sudo reboot
}

sam_3() {
	samConfirm &&
	sudo shutdown -h now
}

sam_4() {
	samConfirm &&
	sudo apt-get update && apt-get upgrade && apt-get dist-upgrade && apt-get autoremove && apt-get clean
	samPause
}

sam_5() {
	samConfirm &&
	samWait
	sudo dd if="/dev/zero" of="/tmp/zero"; rm -f "/tmp/zero"
	samPause
}
