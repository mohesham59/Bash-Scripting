#!/bin/bash

# Main menu function
main_menu() {
	CHOICE=$(whiptail --title "User Utilities Menu" --menu "Choose an option:" 20 60 12 \
		"1" "Add User" \
		"2" "Modify User" \
		"3" "Delete User" \
		"4" "List User" \
		"5" "Change Password" \
		"6" "Disable User" \
		"7" "Enable User" \
		"8" "Add Group" \
		"9" "Delete Group" \
		"10" "Modify Group" \
		"11" "List Group" \
		"12" "Exit" 3>&1 1>&2 2>&3)

	exitstatus=$?
	if [ $exitstatus -ne 0 ]; 
	then
		echo "User cancelled the menu."
		exit 0
	fi

	case $CHOICE in
	"1")
		# Add User
		source ./modules/user_add.sh
		user_add
		main_menu
	;;
	"2")
		# Modify User
		source ./modules/user_modify.sh
		user_modify
		main_menu
	;;
	"3")
		# Delete User
		source ./modules/user_delete.sh
		user_delete
		main_menu
	;;
	"4")
		# List User
		source ./modules/user_list.sh 
		user_list
		main_menu
	;;
	"5")
		# Change Password
		source ./modules/change_password.sh
		change_password
		main_menu
	;;
	"6")
		# Disable User
		source ./modules/user_disable.sh
		user_disable
		main_menu
	;;
	"7")
		# Enable User
		source ./modules/user_enable.sh
		user_enable
		main_menu
	;;
	"8")
		# Add Group
		source ./modules/group_add.sh
		group_add
		main_menu
	;;
	"9")
		# Delete Group
		source ./modules/group_delete.sh
		group_delete
		main_menu
	;;
	"10")
		# Modify Group
		source ./modules/group_modify.sh
		group_modify
		main_menu
	;;
	"11")
		# List Group
		source ./modules/group_list.sh
		group_list
		main_menu
	;;
	"12")
		# Exit
		whiptail --title "Exit" --msgbox "Exiting the admin menu." 8 40
		exit 0
	;;
	*)
		whiptail --msgbox "Invalid option selected!" 8 40 --title "Error"
		main_menu
	;;
	esac
}

# Call the main_menu function to start the script
main_menu

