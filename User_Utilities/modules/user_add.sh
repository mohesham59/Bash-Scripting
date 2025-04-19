#!/bin/bash

function user_add() {
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
	whiptail --title "Add New User" --msgbox "This script helps you create a new system user via an interactive menu." 8 70

	#=====================
	# Prompt for username
	#=====================
	username=$(whiptail --inputbox "Please enter the username to create:" 8 60 --title "Username Input" 3>&1 1>&2 2>&3)
	input_cancel

	#==============================
	# Ensure username is not empty
	#==============================
	while [ -z "$username" ]; 
	do
		whiptail --msgbox "Username cannot be empty. Please try again." 8 60 --title "Invalid Input"
		username=$(whiptail --inputbox "Please enter the username to create:" 8 60 --title "Username Input" 3>&1 1>&2 2>&3)
		input_cancel
	done

	#======================================
	# Check if the username already exists
	#======================================
	if grep -w "$username" /etc/passwd &>/dev/null; 
	then
		whiptail --msgbox "The username '$username' already exists on the system." 8 60 --title "User Exists"
		main_menu
		return
	fi

	#=====================
	# Prompt for password
	#=====================
	pass1=$(whiptail --passwordbox "Enter password for user '$username':" 8 60 --title "Password Input" 3>&1 1>&2 2>&3)
	input_cancel

	#============================
	# Prompt to confirm password
	#============================
	pass2=$(whiptail --passwordbox "Retype password:" 8 60 --title "Confirm Password" 3>&1 1>&2 2>&3)
	input_cancel

	#==========================
	# Check if passwords match
	#==========================
	while [ "$pass1" != "$pass2" ]; 
	do
		whiptail --msgbox "Passwords do not match. Please try again." 8 60 --title "Mismatch"
		pass1=$(whiptail --passwordbox "Enter password for user '$username':" 8 60 --title "Password Input" 3>&1 1>&2 2>&3)
		input_cancel
		pass2=$(whiptail --passwordbox "Retype password:" 8 60 --title "Confirm Password" 3>&1 1>&2 2>&3)
		input_cancel
	done

	#====================================================
	# Create the user with home directory and bash shell
	#====================================================
	useradd "$username" -m -d /home/"$username" -s /bin/bash

	#===============================================
	# If user creation successful, set the password
	#===============================================
	if [ $? -eq 0 ]; 
	then
		echo "$username:$pass1" | chpasswd
		whiptail --msgbox "User '$username' has been created successfully!" 8 60 --title "Success"
		main_menu
	else
		whiptail --msgbox "Failed to create user '$username'." 8 60 --title "Error"
		main_menu
	fi
}



