#!/bin/env bash

# Halberd Technologies
# Faculty Account Managment System
# Main Menu

echo "===================================="
echo "        Halberd Technologies"
echo "     Faculty Account Managment"
echo "===================================="

set -euo pipefail 

  

# Move to the main project folder 

cd "$(dirname "$0")/.." 

  

LICENSE_FILE="license.dat" 

  

# Example 16-digit license key: 

# 5831049276158304 

# 

# Its SHA-256 hash is stored below. 

# In the real submission, do not include 

# the plaintext key in these comments. 

  

EXPECTED_HASH="b574f7c9365418946c97286569423cf6ab8a06e7643d9380db7f18d5d362ef66" 

  

# Convert a license key into a SHA-256 hash 

hash_key() { 

    printf '%s' "$1" | sha256sum | awk '{print $1}' 

} 

  

# Check whether the license is valid 

validate_license() { 

    local key="$1" 

  

    # Require exactly 16 digits 

    if [[ ! "$key" =~ ^[0-9]{16}$ ]]; then 

        return 1 

    fi 

  

    # Compare hashes 

    local entered_hash 

    entered_hash=$(hash_key "$key") 

  

    [[ "$entered_hash" == "$EXPECTED_HASH" ]] 

} 

  

# Check for an existing license file 

if [[ -f "$LICENSE_FILE" ]]; then 

  

    saved_key=$(cat "$LICENSE_FILE") 

  

    if validate_license "$saved_key"; then 

        echo "License validated successfully." 

    else 

        echo "ERROR: License file is invalid or altered." 

        exit 1 

    fi 

  
else 
	# If license.dat does not exist, ask for key 

	echo "No license file found." 

	  

	read -r -p "Enter your 16-digit license key: " key 

	  

	if validate_license "$key"; then 

	  

	    # Only the owner can read the license file 

	    umask 077 

	  

	    printf '%s\n' "$key" > "$LICENSE_FILE" 

	  

	    chmod 600 "$LICENSE_FILE" 

	  

	    echo "License activated successfully." 



	  

	else 

	    echo "ERROR: Invalid license key." 
	    exit 1
	     

	fi 

fi 

PassChoice=""
Password="ZsOml0i7kmp9"
FailedCount=0

while [[ "$PassChoice" != "$Password" ]]; do
    read -r -p "Enter Password: " PassChoice 
    
    if [[ "$PassChoice" != "$Password" ]]; then
         ((++FailedCount))
         echo "Invalid Password... Try again"
    else 
         echo "Password Accepted!"
    fi
    
    if (( FailedCount >= 3 )); then
         echo "Failed Password Check, Lockout Starting."
         exit 1
    fi
done
         


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
