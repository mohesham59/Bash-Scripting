#!/bin/bash

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

#============================================================
# Function to delete a group
#============================================================
delete_group() {
    local group_name="$1"

    # Confirm group deletion
    if whiptail --title "Confirm Deletion" --yesno "Are you sure you want to delete the group '$group_name'?" 8 60; then
        # Try to delete the group
        if groupdel "$group_name"; then
            whiptail --title "Success" --msgbox "Group '$group_name' deleted successfully." 8 60
        else
            whiptail --title "Error" --msgbox "Failed to delete group '$group_name'. Check permissions or if group is in use." 8 60
        fi
    else
        whiptail --title "Delete Group" --msgbox "Deletion cancelled." 8 40
    fi
}

#============================================================
# Main loop to show the menu repeatedly
#============================================================
while true; do
    # Show an intro message
    whiptail --title "Delete Group" --msgbox "This script allows you to delete a system group." 8 70

    # Get the list of groups (excluding system groups)
    groups=$(awk -F: '$3 >= 1000 {print $1}' /etc/group)

    # Check if there's any group to show
    if [ -z "$groups" ]; then
        whiptail --title "Delete Group" --msgbox "No user-defined groups available to delete." 8 60
        main_menu
        exit 0
    fi

    # Display the group list and let the admin choose a group to delete
    group_name=$(whiptail --title "Delete Group" --menu "Select the group to delete:" 20 60 10 \
    $(echo "$groups" | awk '{print $1 , NR }') 3>&1 1>&2 2>&3)

    # If user cancels
    if [ $? -ne 0 ]; then
        main_menu
        break
    fi

    # Delete selected group
    delete_group "$group_name"

    # Exit loop after operation
    break
done

# Return to main menu after deletion or cancellation
main_menu

