# 👻 Ghost Watch

## Overview
An advanced Linux challenge. Students must investigate a “ghost process” that respawns, identify its parent, terminate it correctly, and confirm the system is silent.

**Skills Practiced**
- Network listening (`ss`, `netstat`)
- Process hierarchy (`ps`, `pstree`)
- Signals (`kill -SIGTERM`)
- Script execution
- System verification

---

## Setup Instructions

1. Open a terminal.
2. Download the setup script:
3. Make it executable.
4. Run the script.
5. Enter the dungeon directory to begin!

```bash
wget -O setup_ghost.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_ghost.sh

chmod +x setup_ghost.sh

sudo ./setup_ghost.sh

cd ghost_watch
```
6. Check success
```bash
./check_ghost.sh
```
