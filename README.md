# MegaRAID-check-script
scripts to check the status of the MegaRAID array, count the number of disks, and send an email notification if there are changes.

This script accepts the same -c option as before to count the number of disks in the MegaRAID array. It also saves the current status and number of disks to temporary files, and compares them with the previous values on each run. If a change is detected, the script sends an email notification to the specified email address with the details of the change.

To use this script, you will need to have a mail server configured on your system and the mail command installed. You will also need to replace your@email.com with the email address that you want to send the notification to.

You can run this script periodically using a tool such as cron to check for changes in the MegaRAID array status and number of disks. For example, you can add the following entry to your crontab file to run the script every hour:

```
0 * * * * /path/to/megaraid_status.sh
```

This will run the script every hour and send an email notification if a change in the MegaRAID array status or number of disks is detected. You can also specify the -c option when running the script with cron to count the number of disks in the MegaRAID array. For example:

```
0 * * * * /path/to/megaraid_status.sh -c
```
