#!/bin/bas

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

    case "$choice" in
        1)
            echo "Import Faculty selected."
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
