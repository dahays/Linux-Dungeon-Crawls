
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

Open a terminal.

Download the setup script:
```bash
wget -O setup_hydra.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_hydra.sh
```
Make the script executable.
```bash
chmod +x setup_hydra.sh
```
Run the script.
```bash
sudo ./setup_hydra.sh
```
`🔴`Force a new instance of the shell.`🔴`
```bash
exec zsh
```
Enter the lair.
```bash
cd hydra_lair
```
Confirm success.
```bash
./hydra_lair/check_hydra.sh
```
