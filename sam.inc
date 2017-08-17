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
	sudo reboot
}

sam_3() {
	sudo shutdown -h now
}

sam_4() {
	sudo apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get clean -y
}

sam_5() {
	samWait
	sudo dd if="/dev/zero" of="/tmp/zero" || rm -f "/tmp/zero"
}