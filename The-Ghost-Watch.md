👻 Ghost Watch

## Overview
An advanced Linux dungeon challenge.  
Students must investigate a “ghost process” that respawns, identify its parent, terminate it correctly, and confirm the system is silent.

This dungeon focuses on **process inspection, hierarchy, and signals**, not environment tricks.

---

## Skills Practiced

- Process discovery (`ps`, `pgrep`, `top`)
- Process hierarchy (`ps -f`, `pstree`)
- Signals (`kill`, `kill -SIGTERM`)
- Script execution
- System verification

---

## Setup Instructions

Open a terminal.

Download the setup script:
```bash
wget -O setup_ghost.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_ghost.sh
```
Make it executable.
```bash
chmod +x setup_ghost.sh
```

Run the installer script.
```bash
sudo ./setup_ghost.sh
```
Enter the dungeon directory to begin!

```bash
cd ghost_watch
```

Check success

A true victory leaves the system silent.
```bash
./check_ghost.sh
```
