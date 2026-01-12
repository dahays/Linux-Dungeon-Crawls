# 👻🕯️ Ghost Watch II: The Necromancer

## Overview

An advanced Linux dungeon crawl.

A simple ghost is never truly gone.
In this challenge, students face a necromancer process that continuously resurrects a ghost child. Killing the ghost alone is futile. Only by identifying and defeating the parent can silence be achieved.

This dungeon teaches the critical difference between symptom and source.

**Skills Practiced**

Process discovery (ps, pgrep)

Process trees (pstree, ps -f --forest)

Parent/child relationships (PPID)

Signals and termination (kill, kill -SIGTERM, kill -SIGKILL)

Verification and system state reasoning

## Setup Instructions

Open a terminal.

Download the setup script:

```bash
wget -O setup_necromancer.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_necromancer.sh
```

Make it executable:
```bash
chmod +x setup_necromancer.sh
```

Run the installer:
```bash
sudo ./setup_necromancer.sh
```

Enter the dungeon:
```bash
cd ~/ghost_necromancer
```

A true success means the ritual has been broken.  A quiet system is the only proof.
```bash
./check_necromancer.sh
```