# A TUI for Red Hat Administrative Tasks 🚀

## 💡 Overview:
A TUI for Red Hat Administrative Tasks is a text-based user interface (TUI) script designed to streamline common user and group management tasks on Red Hat-based Linux systems. Utilizing `whiptail` to create a user-friendly, menu-driven interface, this script simplifies the execution of essential administrative functions, minimizing the need for direct command-line interaction.

## 🛠️ Features:
The script offers a comprehensive menu with the following options:

### **Add User:**
- Easily add a new user to the system.

### **Modify User:**
- **Change UID:** Update the User ID of an existing user.
- **Change Primary Group:** Modify the primary group associated with a user.
- **Add to Secondary Group:** Include a user in one or more secondary groups.
- **Change Home Directory:** Set a new home directory for the user.
- **Change Shell:** Update the login shell for the user.

### **Delete User:**
- Remove an existing user from the system through a straightforward interface.

### **List All Users:**
- View a list of all users currently present on the system.

### **Change Password of Existing User:**
- Update the password for an existing user account.

### **Lock User Account:**
- Lock a user account to prevent login access.

### **Unlock User Account:**
- Unlock a previously locked user account to restore login access.

### **Add Group:**
- Create a new group on the system with ease.

### **Delete Existing Group:**
- Remove an existing group from the system.

### **Modify Group:**
- **Change GID:** Update the Group ID of an existing group.
- **Add Users to Group:** Include one or more users in a specified group.

### **List All Groups:**
- Display a list of all groups currently on the system.

## 📝 Prerequisites:
- **whiptail:** Required for the graphical TUI interface.
- **sudo:** Necessary for performing administrative tasks. Ensure you have the appropriate permissions to execute administrative commands.

## ⚙️ Installation:

### **Clone the repository:**
```bash
git clone https://github.com/mohesham59/Bash-Scripting.git

cd User_Utilities
```
### **Make the script executable:**  
```bash
chmod +x *.sh
```

### **Run the Main Script**  
```bash
./User_Utilities.sh
```

### **🖥️ Navigate the Menu:**
- Use the whiptail interface to select options and provide the required information.
/home/hamo/Pictures/Screenshots/Screenshot from 2025-04-19 14-48-02.png
