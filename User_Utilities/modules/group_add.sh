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
#=======================
# Show an intro message
#=======================
whiptail --title "Add New Group" --msgbox "This script helps you create a new system group via an interactive menu." 8 70
	
#===============================================
# Function to get the group name from the user
#===============================================
get_group_name() {
	group_name=$(whiptail --inputbox "Enter the group name to add:" 8 60 --title "Add Group" 3>&1 1>&2 2>&3)
	input_cancel

	# Check if the group name is empty
	while [ -z "$group_name" ]; 
	do
		whiptail --msgbox "Group name cannot be empty. Please enter a valid name." 8 60 --title "Add Group"
		group_name=$(whiptail --inputbox "Enter the group name to add:" 8 60 --title "Add Group" 3>&1 1>&2 2>&3)
		input_cancel
	done
}

# Get the group name from the user
get_group_name

# Check if the group already exists
id -g "$group_name" &> /dev/null
while [ $? -eq 0 ]; 
do
	whiptail --msgbox "This group (${group_name}) already exists, choose another." 8 60 --title "Add Group"
	get_group_name
done

# Create the new group
groupadd "$group_name"

# Check if the group was created successfully
if [ $? -eq 0 ]; 
then
	whiptail --msgbox "Group '$group_name' created successfully." 8 60 --title "Add Group"
	main_menu
else
	whiptail --msgbox "Failed to create group '$group_name'." 8 60 --title "Error"
	main_menu
fi

# Return to the same interface after the operation
get_group_name

