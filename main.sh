#!/bin/bash
export FACULTY_URL="https://www.tntech.edu/engineering/programs/csc/faculty-and-staff.php"
# Halberd Technologies
# Faculty Account Managment System
# Main Menu

echo "===================================="
echo "        Halberd Technologies"
echo "     Faculty Account Managment"
echo "===================================="

while true; do

    echo ""
    echo "1. Import Faculty from Website"
    echo "2. Add User Manually"
    echo "3. Exit"
    echo ""

    read -r -p "Enter your choice [1-3]: " choice

    choice=${choice:-1}
  
    case "$choice" in
      1)
          
   	 echo "Importing faculty from website..."
   	 bash "$(dirname "$0")/scripts/faculty_import.sh"
	 ;;
           
       2)
            echo "Add User Manually selected."
            ;;
        3)
            echo "Exiting HAlberd Technologies."
            break
            ;;
        *)
            echo "Invalid choice. Please enter 1, 2, or 3."
            ;;
    esac

done
