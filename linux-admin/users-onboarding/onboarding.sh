#!/bin/bash

set -euo pipefail

CSV_FILE="${1:-users.csv}"
DEFAULT_PASSWORD='Welcome123!'
OFFBOARD_USER="${2:-rbrown}"

# Must be run as root
if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this script as root."
    echo "Usage: sudo $0 users.csv [user_to_disable]"
    exit 1
fi

if [[ ! -f "$CSV_FILE" ]]; then
    echo "ERROR: CSV file '$CSV_FILE' not found."
    exit 1
fi

echo "======================================"
echo " Linux User Onboarding"
echo "======================================"
echo

# Skip CSV header
tail -n +2 "$CSV_FILE" | while IFS=',' read -r username full_name primary_group secondary_groups
do
    # Remove possible carriage return from Windows CSV files
    secondary_groups="${secondary_groups//$'\r'/}"

    # Trim surrounding quotes
    username="${username//\"/}"
    full_name="${full_name//\"/}"
    primary_group="${primary_group//\"/}"
    secondary_groups="${secondary_groups//\"/}"

    # Skip empty lines
    [[ -z "$username" ]] && continue

    echo "Processing user: $username"

    # --------------------------------------
    # Create primary group if absent
    # --------------------------------------

    if ! getent group "$primary_group" > /dev/null; then
        echo "  [+] Creating primary group: $primary_group"
        groupadd "$primary_group"
    else
        echo "  [=] Primary group exists: $primary_group"
    fi

    # --------------------------------------
    # Create user if absent
    # --------------------------------------

    if ! id "$username" &>/dev/null; then

        echo "  [+] Creating user: $username"

        useradd \
            -m \
            -d "/home/$username" \
            -s /bin/bash \
            -g "$primary_group" \
            -c "$full_name" \
            "$username"

        # Set default password
        echo "$username:$DEFAULT_PASSWORD" | chpasswd

        # Force password change on first login
        chage -d 0 "$username"

    else

        echo "  [=] User already exists: $username"

        # Make sure primary group is correct
        usermod -g "$primary_group" "$username"

        # Make sure full name is correct
        usermod -c "$full_name" "$username"
    fi

    # --------------------------------------
    # Create secondary groups
    # --------------------------------------

    if [[ -n "$secondary_groups" ]]; then

        IFS=',' read -ra GROUPS <<< "$secondary_groups"

        for group in "${GROUPS[@]}"; do

            # Remove whitespace
            group="$(echo "$group" | xargs)"

            [[ -z "$group" ]] && continue

            if ! getent group "$group" > /dev/null; then
                echo "  [+] Creating secondary group: $group"
                groupadd "$group"
            else
                echo "  [=] Secondary group exists: $group"
            fi

            echo "  [+] Adding $username to $group"

            usermod -aG "$group" "$username"
        done
    fi

    # --------------------------------------
    # Secure home directory
    # --------------------------------------

    echo "  [+] Setting /home/$username permissions to 700"

    chmod 700 "/home/$username"
    chown "$username:$primary_group" "/home/$username"

    echo "  [✓] $username complete"
    echo

done

# ======================================
# Offboarding
# ======================================

echo "======================================"
echo " Offboarding"
echo "======================================"

if id "$OFFBOARD_USER" &>/dev/null; then

    echo "[+] Disabling user: $OFFBOARD_USER"

    # Lock password-based authentication
    usermod -L "$OFFBOARD_USER"

    # Expire the account
    usermod -e 1 "$OFFBOARD_USER"

    echo "[✓] User $OFFBOARD_USER has been disabled."

else

    echo "[!] Offboarding user '$OFFBOARD_USER' does not exist."

fi

echo
echo "======================================"
echo " Done"
echo "======================================"