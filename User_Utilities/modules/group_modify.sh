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

#==================================
# Function to modify group details
#==================================
function group_modify() {
	#=======================
	# Show an intro message
	#=======================
	whiptail --title "Modify Group" --msgbox "This script allows you to modify an existing group." 8 70

	#=====================
	# Prompt for group name
	#=====================
	groupname=$(whiptail --inputbox "Please enter the group name to modify:" 8 60 --title "Group Name Input" 3>&1 1>&2 2>&3)
	input_cancel

	#==============================
	# Ensure group name is not empty
	#==============================
	while [ -z "$groupname" ]; 
	do
		whiptail --msgbox "Group name cannot be empty. Please try again." 8 60 --title "Invalid Input"
		groupname=$(whiptail --inputbox "Please enter the group name to modify:" 8 60 --title "Group Name Input" 3>&1 1>&2 2>&3)
		input_cancel
	done
	
	#==========================
	# Ensure group exists
	#==========================
	if ! grep -w "$groupname" /etc/group &>/dev/null; 
	then
		whiptail --msgbox "The group '$groupname' does not exist." 8 60 --title "Group Not Found"
		main_menu
		return
	fi

	#=============================
	# Display modification menu
	#=============================
	CHOICE=$(whiptail --title "Modify Group Options" --menu "Choose an option" 15 60 5 \
	"1" "Change GID" \
	"2" "Add Users to Group" 3>&1 1>&2 2>&3)

	#===============================
	# Handle the option selected
	#===============================
	case $CHOICE in
		1)
			# Change GID
			new_gid=$(whiptail --inputbox "Enter the new GID for group '$groupname':" 8 60 --title "Change GID" 3>&1 1>&2 2>&3)
			input_cancel
			if [[ ! "$new_gid" =~ ^[0-9]+$ ]]; 
			then
				whiptail --msgbox "Invalid GID. Please enter a valid numeric GID." 8 60 --title "Invalid Input"
				group_modify
				return
			fi
			groupmod -g "$new_gid" "$groupname"
			
			if [ $? -eq 0 ]; 
			then
				whiptail --msgbox "GID for group '$groupname' has been changed successfully!" 8 60 --title "Success"
			else
				whiptail --msgbox "Failed to change GID for group '$groupname'." 8 60 --title "Error"
			fi
			;;
		2)
			# Add users to group
			users=$(whiptail --inputbox "Enter the usernames to add to group '$groupname' (separate by space):" 8 60 --title "Add Users to Group" 3>&1 1>&2 2>&3)
			input_cancel
			for user in $users; do
				if id "$user" &>/dev/null; then
					usermod -aG "$groupname" "$user"
					
					if [ $? -eq 0 ]; then
						whiptail --msgbox "User '$user' has been added to the group '$groupname' successfully!" 8 60 --title "Success"
					else
						whiptail --msgbox "Failed to add user '$user' to the group '$groupname'." 8 60 --title "Error"
					fi
				else
					whiptail --msgbox "User '$user' does not exist." 8 60 --title "User Not Found"
				fi
			done
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

