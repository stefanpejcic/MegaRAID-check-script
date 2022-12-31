#!/bin/bash

# Check if the MegaCLI command is available
if ! [ -x "$(command -v megacli)" ]; then
  echo "Error: MegaCLI is not installed." >&2
  exit 1
fi

# Parse command line options
while getopts ":c" opt; do
  case $opt in
    c) count=true ;;
    \?) echo "Invalid option: -$OPTARG" >&2
        exit 1
        ;;
  esac
done

# Run the MegaCLI command to get the status of the RAID array
status=$(megacli -LDInfo -Lall -aALL | grep 'State' | awk '{print $3}')

# Check if the count option was specified
if [ "$count" = true ]; then
  # Get the number of disks in the RAID array
  disks=$(megacli -PDList -aALL | grep 'Device Id' | wc -l)
  echo "The MegaRAID array has $disks disks."
else
  # Check the status and print the appropriate message
  if [ "$status" == "Optimal" ]; then
    echo "The MegaRAID array is in optimal condition."
  elif [ "$status" == "Degraded" ]; then
    echo "The MegaRAID array is degraded."
  elif [ "$status" == "Failed" ]; then
    echo "The MegaRAID array has failed."
  else
    echo "The MegaRAID array status is unknown."
  fi
fi
