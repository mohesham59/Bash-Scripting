#!/bin/bash

function group_list() {
    #======================
    # Show an intro message
    #======================
    whiptail --title "List All Groups" --msgbox "This script will list all system Groups." 8 70

    #======================
    # Get the list of all users
    #======================
    users=$(cut -d: -f1 /etc/group | tail)

    #===========================
    # Check if there are any users
    #===========================
    if [ -z "$users" ]; then
        whiptail --msgbox "No Groups found on the system." 8 60 --title "No Groups"
    else
        # Display the list of users
        whiptail --title "All Groups" --msgbox "$users" 20 60
    fi

    # Return to main menu after listing
    main_menu
}
