# Linux Dungeon Crawls

## Overview

**Linux Dungeon Crawls** is a collection of themed, hands-on Linux challenges designed to help students practice real-world command-line skills through guided exploration and problem solving.

Each dungeon is self-contained and installed using a single setup script. Once installed, students navigate the environment, follow clues, and complete objectives using standard Linux tools.

**Disclaimer: A Kali VM will provide the most ideal environment.  While not critically malicious, running these scripts from a local Linux machine is not advised.**

---

## Getting Started

All dungeon crawls follow the same basic workflow:

1. Download the setup script using `wget`
2. Make the script executable
3. Run the script
4. Refresh the shell (if indicated as necessary)
5. Enter the dungeon directory to begin
6. Check for possible "clues" within each dungeon to help get started
7. Run the check script to verify success

Be aware of our surroundings, there may be hidden artifacts to aid you in your quest.

---

## Available Dungeon Crawls

### 🏴‍☠️ The Great Linux Treasure Hunt 💰

This dungeon, written by Github user [hermonm](https://github.com/hermonm), served as the inspirational jumping-off point to write the rest of these.
A link to his original document can be found [HERE](https://docs.google.com/document/d/1jnTvguwR8JN0xp1oe4YjzHU7vwUXi7_Ni7kA6looqOs/edit?tab=t.0)

### 🐍 The Hydra Head Hunt (Level 2)

A multi-process Linux challenge focused on identifying and defeating hidden and persistent processes, environment variables, and command hijacking.

**Crawl Instructions:** [The-Hydra-Head-Hunt.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Hydra-Head-Hunt.md#-hydra-head-hunt)

### 👻 The Ghost Watch (Level 3)

An advanced Linux investigation challenge centered on identifying and stopping a persistent “ghost” process that respawns until the true source is discovered.

**Crawl Instructions:** [The-Ghost-Watch.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/The-Ghost-Watch.md#-ghost-watch)

### 🧟 Ghost Watch II: The Necromancer (Level 4)
An advanced Linux dungeon crawl.

A simple ghost is never truly gone.
In this challenge, you face a necromancer process that continuously resurrects a ghost child. Killing the ghost alone is futile. The sins of the parent...

**Crawl Instructions:** [Ghost-Watch-II-Necromancer.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Ghost-Watch-II-Necromancer.md)

### 🐉 The Dragon’s Cron (Level 5)

A powerful dragon stalks the system, awakening every minute without fail. Killing symptoms will not stop it. To restore peace, you must uncover how the dragon persists and remove it at the source.

This dungeon emphasizes investigation over brute force.

**Crawl Instructions:** [The-Dragon-Cron.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/The-Dragon-Cron.md#-the-dragons-cron)

### 🔥The Trial of Eternal Fire (Levels 1-5 Cumulative)🔥

Master the Trial of Eternal Fire by defeating your enemies in the correct order.  Only by defeating them in order will you find the Flamebound Treasure Chest.

**Crawl Instructions:** [Trial-Of-Eternal-Fire.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Trial-Of-Eternal-Fire.md#-trial-of-eternal-fire)

# 🛡️ Commands to Help on Your Quests

| Command | Description |
|---------|-------------|
| ls | List files and directories |
| which | Locate a command in your PATH |
| type | Show what a command actually is |
| command -v | Print the true executable location |
| echo $PATH | Show directories searched for commands |
| printenv | List environment variables |
| alias | Show shell aliases |
| unalias | Remove a shell alias |
| declare -f | List shell functions |
| env | View or modify environment variables |
| cat ~/.zshrc | Display shell configuration |
| less ~/.zshrc | Browse shell configuration |
| grep | Search for related lines |
| unset | Remove a variable from the environment |
| exec zsh | Reload shell to clear wrappers |
| ps aux | List all running processes |
| pgrep | Find process IDs by name |
| top | Interactive process viewer |
| htop | Alternative interactive process viewer |
| kill <PID> | Terminate a process |
| kill -9 <PID> | Force terminate a process |
| ps -ef | Full-format process listing |
| pstree | Display processes in a tree |
| ps -o pid,ppid,cmd | Show parent-child relationships |
| pkill -f | Terminate processes by pattern |
| cat | Read file contents |
| file | Inspect the type of file |
| tail | View recent text entries |
| tail -f | Monitor text entries in real time |
| crontab | View user cron jobs |
| systemctl --user | List user-level systemd services |
| systemctl --user status <service> | Show status of a user service |
| systemctl --user stop <service> | Stop a running user service |
| systemctl --user disable <service> | Disable a user service |
| journalctl --user | View logs for user services |
| ls ~/.config/autostart | List autostart desktop entries |
| cat ~/.config/autostart/*.desktop | Inspect autostart scripts |
| readelf -d <file> | Inspect dynamic dependencies of binaries |
| ldd <file> | List linked libraries for a binary |
| strace <command> | Trace system calls made by a process |
| lsof -p <PID> | List open files by a process |
| env | Print or modify environment variables (useful for LD_PRELOAD) |
| unset LD_PRELOAD | Remove library preloading |
| echo $LD_PRELOAD | Show current LD_PRELOAD value |

