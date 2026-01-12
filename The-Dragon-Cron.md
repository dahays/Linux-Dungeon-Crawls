# 🐉 The Dragon’s Cron

## Overview

A powerful dragon stalks the system, awakening every minute without fail. Killing symptoms will not stop it. To restore peace, you must uncover how the dragon persists and remove it at the source.

This dungeon emphasizes investigation over brute force.

**Skills Practiced**
- Investigating Linux persistence mechanisms using scheduled tasks
- Listing and analyzing cron jobs with `crontab` and files in `/etc/cron.*`
- Reading and interpreting system log files (such as `/var/log/syslog`)
- Identifying unauthorized or malicious scripts in common system paths
- Understanding why killing a process does not remove persistent threats
- Safely disabling persistence without breaking system functionality
- Tracing cause-and-effect relationships through forensic-style analysis
- Applying incident-response thinking instead of trial-and-error fixes

---

## Setup Instructions

Open a terminal.





Download the setup script:
```bash
wget -O setup_dragon.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_dragon.sh
```
Make it executable.
```bash
chmod +x setup_dragon.sh
```
Run the script.
```bash
sudo ./setup_dragon.sh
```
Enter the dungeon directory to begin!
```bash
cd dragon_cron
```
Confirm success
```bash
./lair/check_dragon.sh
```



