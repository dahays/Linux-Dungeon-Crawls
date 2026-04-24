# 👁️ The Shadow Account   

(Linux Dungeon Crawl Intro 1C)

---

## Overview
A dark presence has infiltrated the system.

An unknown user has created an account and left traces behind. This entity must be identified and completely removed.

This dungeon introduces basic user account investigation and system cleanup.

The `strange_manuscript.txt` contains your instructions. Read it carefully.

---

## Setup Instructions

Open a terminal.

Download the setup script:
```bash
wget -O setup_shadow.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_shadowaccount.sh
```

Make the script executable:
```bash
chmod +x setup_shadow.sh
```

Run the setup script:
```bash
./setup_shadow.sh
```

Enter the dungeon:
```bash
cd ~/dungeon_shadow/shadow_chamber
```

Check success:
```bash
./check_shadow.sh
```