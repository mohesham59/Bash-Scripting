#!/bin/bash

function user_list() {
    #======================
    # Show an intro message
    #======================
    whiptail --title "List All Users" --msgbox "This script will list all system users." 8 70

    #======================
    # Get the list of all users
    #======================
    users=$(cut -d: -f1 /etc/passwd | tail)

    #===========================
    # Check if there are any users
    #===========================
    if [ -z "$users" ]; then
        whiptail --msgbox "No users found on the system." 8 60 --title "No Users"
    else
        # Display the list of users
        whiptail --title "All Users" --msgbox "$users" 20 60
    fi

    # Return to main menu after listing
    main_menu
}

