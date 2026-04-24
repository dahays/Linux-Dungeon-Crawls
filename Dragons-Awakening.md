# 🐲 Dragon’s Awakening (Level 7)
## Overview

The Dragon awakens at every login, silently executing its ritual through a GUI autostart .desktop file. Killing processes will not suffice; the threat will reappear at each session start. Students must trace, disable, and remove the autostart entry to restore control.

This dungeon emphasizes persistence through user environment mechanisms rather than direct process control.

**Skills Practiced**

- Investigating user autostart directories (~/.config/autostart) and .desktop files
- Understanding the lifecycle of GUI session startup scripts
- Removing hidden persistence entries safely
- Combining file inspection with multi-layered archival hints
- Applying forensic reasoning to trace recurring threats
- Reinforcing the principle that not all threats are visible at runtime

# Setup Instructions

Open a terminal.

Download the setup script:

```bash
wget -O setup_awakening.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_awakening.sh
```
Make it executable:

```bash
chmod +x setup_awakening.sh
```
Run the installer script:

```bash
sudo ./setup_awakening.sh
```
Enter the dungeon directory to begin:

```bash
cd dragons_awakening
```

Check Success:

A true victory leaves the autostart idle.
```bash
./check_awakening.sh
```