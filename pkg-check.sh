#!/usr/bin/env bash
# pkg-check.sh
# Author:       Ethan L'Heureux
# Description:  Check for any available apt package updates, and runs a weekly cron job.
#               Save results to /var/tmp/update-list.txt.


PKG_LIST_FILE="/var/tmp/update-list.txt"
SCRIPT_PATH="$(realpath "$0")"  # Full path to this script.

# Is script ran with sudo.
echo "Check if ran with sudo. If not, script will not run properly."
echo "Are you running with sudo? Y/N:"
read answer

# If not ran with sudo, then exit script.
if [[ "$answer" == "N" || "$answer" == "n" ]]; then
  echo "Please run with sudo."
  exit 1
fi

# Update package list.
apt update -y >/dev/null 2>&1

# List upgradable packages.
apt list --upgradable 2>/dev/null > "$PKG_LIST_FILE"

# Weekly cron job is installed
cronjob="0 2 * * 0 $SCRIPT_PATH"   # Run every Sunday at 2 AM

# Add the cron job.
(sudo crontab -l 2>/dev/null; echo "$cronjob") | sudo crontab -
echo "Cron job installed: $cronjob"
