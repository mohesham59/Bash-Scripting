#!/bin/bash

#============================================================
# Check for root privileges
#============================================================
if [[ $EUID -ne 0 ]]; then
    whiptail --title "Permission Denied" --msgbox "Please run this script as root." 8 50
    exit 1
fi

#============================================================
# Function to change user password
#============================================================
function change_password() {
	#============================================================
	# Function to handle input cancellation (user pressed Cancel)
	#============================================================
	input_cancel() {
		if [ $? -ne 0 ]; then
			main_menu
			exit 1
		fi
	}

	#=======================
	# Show an intro message
	#=======================
	whiptail --title "Change User Password" --msgbox "This script allows you to change the password for a specific user." 8 70

	#===========================
	# Prompt for the username
	#===========================
	username=$(whiptail --inputbox "Enter the username to change the password for:" 8 60 --title "Username Input" 3>&1 1>&2 2>&3)
	input_cancel

	#=======================
	# Ensure username is not empty
	#=======================
	while [ -z "$username" ]; do
		whiptail --msgbox "Username cannot be empty. Please try again." 8 60 --title "Invalid Input"
		username=$(whiptail --inputbox "Enter the username to change the password for:" 8 60 --title "Username Input" 3>&1 1>&2 2>&3)
		input_cancel
	done

	#======================================================
	# Check if the username exists on the system
	#======================================================
	if ! id "$username" &>/dev/null; then
		whiptail --msgbox "The username '$username' does not exist on the system." 8 60 --title "User Not Found"
		main_menu
		return
	fi

	#==========================
	# Prompt for the new password
	#==========================
	new_pass1=$(whiptail --passwordbox "Enter the new password for user '$username':" 8 60 --title "Password Input" 3>&1 1>&2 2>&3)
	input_cancel

	#==============================
	# Prompt to confirm the new password
	#==============================
	new_pass2=$(whiptail --passwordbox "Retype the new password:" 8 60 --title "Confirm Password" 3>&1 1>&2 2>&3)
	input_cancel

	#==========================
	# Check if passwords match
	#==========================
	while [ "$new_pass1" != "$new_pass2" ]; do
		whiptail --msgbox "Passwords do not match. Please try again." 8 60 --title "Mismatch"
		new_pass1=$(whiptail --passwordbox "Enter the new password for user '$username':" 8 60 --title "Password Input" 3>&1 1>&2 2>&3)
		input_cancel
		new_pass2=$(whiptail --passwordbox "Retype the new password:" 8 60 --title "Confirm Password" 3>&1 1>&2 2>&3)
		input_cancel
	done

	#=========================================
	# Change the user password using `chpasswd`
	#=========================================
	echo "$username:$new_pass1" | chpasswd

	#=======================================================
	# Check if the password change was successful
	#=======================================================
	if [ $? -eq 0 ]; then
		whiptail --msgbox "Password for user '$username' has been changed successfully!" 8 60 --title "Success"
	else
		whiptail --msgbox "Failed to change the password for user '$username'." 8 60 --title "Error"
	fi

	main_menu
}

