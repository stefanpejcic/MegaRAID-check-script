#!/bin/bash

# Check if the MegaCLI command is available
if ! [ -x "$(command -v megacli)" ]; then
  echo "Error: MegaCLI is not installed." >&2
  exit 1
fi

# Set the email address to send the notification to
to=your@email.com

# Parse command line options
while getopts ":c" opt; do
  case $opt in
    c) count=true ;;
    \?) echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
  esac
done

# Get the current status of the RAID array
current_status=$(megacli -LDInfo -Lall -aALL | grep 'State' | awk '{print $3}')

# Get the current number of disks in the RAID array
current_disks=$(megacli -PDList -aALL | grep 'Device Id' | wc -l)

# Check if the current status or number of disks is different from the previous values
if [ -f "/tmp/megaraid_status" ]; then
  previous_status=$(cat /tmp/megaraid_status)
  previous_disks=$(cat /tmp/megaraid_disks)
  if [ "$current_status" != "$previous_status" ] || [ "$current_disks" != "$previous_disks" ]; then
    # Send an email notification
    message="MegaRAID status has changed:"
    if [ "$current_status" != "$previous_status" ]; then
      message="$message\n  Status: $previous_status -> $current_status"
    fi
    if [ "$current_disks" != "$previous_disks" ]; then
      message="$message\n  Number of disks: $previous_disks -> $current_disks"
    fi
    echo -e "$message" | mail -s "MegaRAID status change" $to
  fi
fi

# Save the current status and number of disks to temporary files
echo "$current_status" > /tmp/megaraid_status
echo "$current_disks" > /tmp/megaraid_disks

# Check if the count option was specified
if [ "$count" = true ]; then
  # Print the number of disks in the RAID array
  echo "The MegaRAID array has $current_disks disks."
else
  # Print the status of the MegaRAID array
  if [ "$current_status" == "Optimal" ]; then
    echo "The MegaRAID array is in optimal condition."
  elif [ "$current_status" == "Degraded" ]; then
    echo "The MegaRAID array is degraded."
  elif [ "$current_status" == "Failed" ]; then
    echo "The MegaRAID array has failed."
  else
    echo "The MegaRAID array status is unknown."
  fi
fi
