#!/bin/bash

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
	

	#==============================
	# Ensure username is not empty
	#==============================
	while [ -z "$username" ]; 
	do
		whiptail --msgbox "Username cannot be empty. Please try again." 8 60 --title "Invalid Input"
		username=$(whiptail --inputbox "Please enter the username to modify:" 8 60 --title "Username Input" 3>&1 1>&2 2>&3)
		
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

	while true; do
		#=============================
		# Display modification menu
		#=============================
		CHOICE=$(whiptail --title "Modify User Options" --menu "Choose an option" 15 60 6 \
		"1" "Change UID" \
		"2" "Change Primary Group" \
		"3" "Add User to Secondary Group" \
		"4" "Change Home Directory" \
		"5" "Change Shell" \
		"6" "Back to Main Menu" 3>&1 1>&2 2>&3)

		case $CHOICE in
			1)
				new_uid=$(whiptail --inputbox "Enter the new UID for user '$username':" 8 60 --title "Change UID" 3>&1 1>&2 2>&3)
				
				if [[ ! "$new_uid" =~ ^[0-9]+$ ]]; 
				then
					whiptail --msgbox "Invalid UID. Please enter a valid numeric UID." 8 60 --title "Invalid Input"
				else
					usermod -u "$new_uid" "$username" && \
					whiptail --msgbox "UID for user '$username' has been changed successfully!" 8 60 --title "Success" || \
					whiptail --msgbox "Failed to change UID for user '$username'." 8 60 --title "Error"
				fi
				;;
			2)
				new_group=$(whiptail --inputbox "Enter the new Primary Group for user '$username':" 8 60 --title "Change Primary Group" 3>&1 1>&2 2>&3)
				
				usermod -g "$new_group" "$username" && \
				whiptail --msgbox "Primary Group for user '$username' has been changed successfully!" 8 60 --title "Success" || \
				whiptail --msgbox "Failed to change Primary Group for user '$username'." 8 60 --title "Error"
				;;
			3)
				sec_group=$(whiptail --inputbox "Enter the Secondary Group to add '$username' to:" 8 60 --title "Add to Secondary Group" 3>&1 1>&2 2>&3)
				
				usermod -aG "$sec_group" "$username" && \
				whiptail --msgbox "User '$username' has been added to the secondary group '$sec_group' successfully!" 8 60 --title "Success" || \
				whiptail --msgbox "Failed to add user '$username' to the secondary group '$sec_group'." 8 60 --title "Error"
				;;
			4)
				new_home=$(whiptail --inputbox "Enter the new Home Directory for user '$username':" 8 60 --title "Change Home Directory" 3>&1 1>&2 2>&3)
				
				usermod -d "$new_home" -m "$username" && \
				whiptail --msgbox "Home directory for user '$username' has been changed successfully!" 8 60 --title "Success" || \
				whiptail --msgbox "Failed to change Home directory for user '$username'." 8 60 --title "Error"
				;;
			5)
				#============================
				# Load available shells
				#============================
				available_shells=()
				while read -r line; do
					[[ -z "$line" || "$line" =~ ^# ]] && continue
					available_shells+=("$line" "")
				done < /etc/shells

				#============================
				# Show shell selection menu
				#============================
				new_shell=$(whiptail --title "Select New Shell" \
					--menu "Choose a new shell for user '$username':" 20 60 10 \
					"${available_shells[@]}" \
					3>&1 1>&2 2>&3)
				

				#============================
				# Apply the new shell
				#============================
				usermod -s "$new_shell" "$username" && \
				whiptail --msgbox "Shell for user '$username' has been changed to '$new_shell'!" 8 60 --title "Success" || \
				whiptail --msgbox "Failed to change shell for user '$username'." 8 60 --title "Error"
				;;
			6|*)
				# Exit to main menu
				break
				;;
		esac
	done

	main_menu
}

