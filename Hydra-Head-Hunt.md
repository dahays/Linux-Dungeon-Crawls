
## 2️⃣ `hydra_head.md`

# 🐍 Hydra Head Hunt

## Overview
A mid-level Linux challenge. Students must discover multiple hidden “Hydra” processes, identify environment variables, detect command hijacking, and verify system safety.

**Skills Practiced**
- Process inspection (`ps`, `pgrep`)
- Environment variables (`printenv`, `env`)
- PATH and command resolution
- Killing multiple processes
- Script execution

---

## Setup Instructions

1. Open a terminal.
2. Download the setup script:
3. Make it executable.
4. Run the script.
5. Enter the dungeon directory and begin!

```bash
wget -O setup_hydra.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_hydra.sh

chmod +x setup_hydra.md

./setup_hydra.sh

cd hydra_head
```
6. Confirm success
```bash
./check_ghost.sh
