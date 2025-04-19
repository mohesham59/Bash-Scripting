#!/bin/bash

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

#=================================
# Function to modify user details
#=================================
function user_modify() {
	#=======================
	# Show an intro message
	#=======================
	whiptail --title "Modify User" --msgbox "This script allows you to modify an existing user." 8 70

	#=====================
	# Prompt for username
	#=====================
	username=$(whiptail --inputbox "Please enter the username to modify:" 8 60 --title "Username Input" 3>&1 1>&2 2>&3)
	input_cancel


	#==============================
	# Ensure username is not empty
	#==============================
	while [ -z "$username" ]; 
	do
		whiptail --msgbox "Username cannot be empty. Please try again." 8 60 --title "Invalid Input"
		username=$(whiptail --inputbox "Please enter the username to delete:" 8 60 --title "Username Input" 3>&1 1>&2 2>&3)
		input_cancel
	done
	
	#==========================
	# Ensure username exists
	#==========================
	if ! grep -w "$username" /etc/passwd &>/dev/null; 
	then
		whiptail --msgbox "The username '$username' does not exist." 8 60 --title "User Not Found"
		main_menu
		return
	fi

	#=============================
	# Display modification menu
	#=============================
	CHOICE=$(whiptail --title "Modify User Options" --menu "Choose an option" 15 60 5 \
	"1" "Change UID" \
	"2" "Change Primary Group" \
	"3" "Add User to Secondary Group" \
	"4" "Change Home Directory" \
	"5" "Change Shell" 3>&1 1>&2 2>&3)

	#===============================
	# Handle the option selected
	#===============================
	case $CHOICE in
		1)
			# Change UID
			new_uid=$(whiptail --inputbox "Enter the new UID for user '$username':" 8 60 --title "Change UID" 3>&1 1>&2 2>&3)
			input_cancel
			if [[ ! "$new_uid" =~ ^[0-9]+$ ]]; 
			then
				whiptail --msgbox "Invalid UID. Please enter a valid numeric UID." 8 60 --title "Invalid Input"
				user_modify
				return
			fi
			usermod -u "$new_uid" "$username"
			
			if [ $? -eq 0 ]; 
			then
				whiptail --msgbox "UID for user '$username' has been changed successfully!" 8 60 --title "Success"
			else
				whiptail --msgbox "Failed to change UID for user '$username'." 8 60 --title "Error"
			fi
			;;
		2)
			# Change Primary Group
			new_group=$(whiptail --inputbox "Enter the new Primary Group for user '$username':" 8 60 --title "Change Primary Group" 3>&1 1>&2 2>&3)
			input_cancel
			usermod -g "$new_group" "$username"
			
			if [ $? -eq 0 ]; 
			then
				whiptail --msgbox "Primary Group for user '$username' has been changed successfully!" 8 60 --title "Success"
			else
				whiptail --msgbox "Failed to change Primary Group for user '$username'." 8 60 --title "Error"
			fi
			;;
		3)
			# Add user to Secondary Group
			sec_group=$(whiptail --inputbox "Enter the Secondary Group to add '$username' to:" 8 60 --title "Add to Secondary Group" 3>&1 1>&2 2>&3)
			input_cancel
			usermod -aG "$sec_group" "$username"
			
			if [ $? -eq 0 ]; 
			then
				whiptail --msgbox "User '$username' has been added to the secondary group '$sec_group' successfully!" 8 60--title "Success"
			else
				whiptail --msgbox "Failed to add user '$username' to the secondary group '$sec_group'." 8 60 --title "Error"
			fi
			;;
		4)
			# Change Home Directory
			new_home=$(whiptail --inputbox "Enter the new Home Directory for user '$username':" 8 60 --title "Change Home Directory" 3>&1 1>&2 2>&3)
			input_cancel
			usermod -d "$new_home" -m "$username"
			
			if [ $? -eq 0 ]; 
			then
				whiptail --msgbox "Home directory for user '$username' has been changed successfully!" 8 60 --title "Success"
			else
				whiptail --msgbox "Failed to change Home directory for user '$username'." 8 60 --title "Error"
			fi
			;;
		5)
			# Change Shell
			new_shell=$(whiptail --inputbox "Enter the new Shell for user '$username':" 8 60 --title "Change Shell" 3>&1 1>&2 2>&3)
			input_cancel
			usermod -s "$new_shell" "$username"
			
			if [ $? -eq 0 ]; then
				whiptail --msgbox "Shell for user '$username' has been changed successfully!" 8 60 --title "Success"
			else
				whiptail --msgbox "Failed to change Shell for user '$username'." 8 60 --title "Error"
			fi
			;;
		*)
			# User cancelled the menu
			whiptail --msgbox "No option selected, returning to the main menu." 8 60 --title "Cancelled"
			main_menu
			;;
	esac

	# Return to main menu after modification
	main_menu
}


