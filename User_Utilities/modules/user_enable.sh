#!/bin/bash

function user_enable() {
	#============================================================
	# Function to handle input cancellation (user pressed Cancel)
	#============================================================
	input_cancel() {
	if [ $? -ne 0 ]; 
	then
		main_menu
		exit 1
	fi
	}

	#=======================
	# Show an intro message
	#=======================
	whiptail --title "Unlock User Account" --msgbox "This script allows you to unlock a user account, preventing login." 8 70

	#===========================
	# Prompt for the username
	#===========================
	username=$(whiptail --inputbox "Enter the username to unlock:" 8 60 --title "Username Input" 3>&1 1>&2 2>&3)
	input_cancel

	#=======================
	# Ensure username is not empty
	#=======================
	while [ -z "$username" ]; 
	do
		whiptail --msgbox "Username cannot be empty. Please try again." 8 60 --title "Invalid Input"
		username=$(whiptail --inputbox "Enter the username to unlock:" 8 60 --title "Username Input" 3>&1 1>&2 2>&3)
		input_cancel
	done

	#======================================================
	# Check if the username exists on the system
	#======================================================
	if ! grep -w "$username" /etc/passwd &>/dev/null; 
	then
		whiptail --msgbox "The username '$username' does not exist on the system." 8 60 --title "User Not Found"
		main_menu
		return
	fi

	#======================================
	# Unlock the user account
	#======================================
	usermod -U "$username"

	#=======================================================
	# Check if the account was unlocked successfully
	#=======================================================
	if [ $? -eq 0 ];
	then
		whiptail --msgbox "User '$username' has been unlocked successfully and can log in." 8 60 --title "Success"
		main_menu
	else
		whiptail --msgbox "Failed to unlock user '$username'." 8 60 --title "Error"
		main_menu
	fi
}
