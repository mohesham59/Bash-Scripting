#!/bin/bash

function user_delete() {
	#============================================================
	# Function to handle input cancellation (user pressed Cancel)
	#============================================================
	input_cancel() {
		if [ $? -ne 0 ]; 
		then
			main_menu
			return
		fi
	}

	#======================
	# Show an intro message
	#======================
	whiptail --title "Delete User" --msgbox "This script allows you to delete a system user." 8 70

	#============================================================
	# Get list of non-system users (UID >= 1000 and not 'nobody')
	#============================================================
	users=$(awk -F: '$3 >= 1000 && $1 != "nobody" {print $1}' /etc/passwd)

	# Check if there are users to show
	if [ -z "$users" ]; then
		whiptail --title "Delete User" --msgbox "No user-defined accounts available to delete." 8 60
		main_menu
		return
	fi

	#============================================================
	# Show user list in a menu
	#============================================================
	username=$(whiptail --title "Delete User" --menu "Select a user to delete:" 20 60 10 \
	$(echo "$users" | awk '{print $1, NR}') 3>&1 1>&2 2>&3)
	
	# Handle cancel
	input_cancel

	#======================================================
	# Confirm deletion
	#======================================================
	if whiptail --yesno "Are you sure you want to delete user '$username' and their home directory?" 8 60 --title "Confirm Deletion"; then

		# Try deleting the user and their home directory
		if userdel -r "$username" &>/dev/null; then
			whiptail --msgbox "User '$username' has been deleted successfully!" 8 60 --title "Success"
		else
			whiptail --msgbox "Failed to delete user '$username'. Check permissions or if user is logged in." 8 60 --title "Error"
		fi
	else
		whiptail --msgbox "User deletion cancelled." 8 60 --title "Cancelled"
	fi

	main_menu
}

