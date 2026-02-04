# 🔥 Trial of Eternal Fire

## Overview
The Trial of Eternal Fire tests your mastery over multiple concurrent threats that refuse to die. Wraiths roam the dungeon, a Pyromancer resurrects them endlessly, and the Inferno burns persistently through cron. To claim the Flamebound Treasure, you must carefully unravel each layer of this fiery trial.

This dungeon emphasizes methodical process management and the interplay between parent and child processes.

**Skills Practiced**

- Identifying and managing background processes with ps, pgrep, and kill
- Understanding parent-child process relationships and respawn behavior
- Recognizing processes that ignore polite termination signals
- Safely stopping multiple concurrent processes in the correct order
- Inspecting and disabling cron jobs for persistent tasks
- Reading and decrypting encrypted files to obtain hidden clues
- Following cryptic hints to connect process behavior to hidden rewards
- Applying logical sequencing and patience rather than brute force

## Setup Instructions

Open a terminal.

Download the setup script:
```bash
wget -O setup_trial.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_trial.sh
```
Make it executable.
```bash
chmod +x setup_trial.sh
```

Run the installer script.
```bash
sudo ./setup_trial.sh
```
`🔴`Force a new instance of the shell.`🔴`
```bash
exec zsh
```
Enter the dungeon directory to begin!
```bash
cd trial_eternal_fire
```

Check success

A true victory leaves the system silent.
```bash
./check_trial.sh
