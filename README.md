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

Be aware of your surroundings, there may be hidden artifacts to aid you in your quest.

---

## Available Dungeon Crawls

### 🚪 The First Door 🚪 (Intro 1A)

An introductory Linux Dungeon Crawl.  Students must navigate the dungeon using basic file navigation, creation, and manipulation commands.  These Linux Dungeon Crawls will build upon skills of the previous Crawls in the series.  Look to the strange_manuscript for clues.

**Crawl Instructions:** [The First Door](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/First-Door.md)

---

### 🏰 The Archivist’s Vault 🔮 (Intro 1B)

An introductory Linux Dungeon Crawl.  Students must write and deploy a script to construct a simple dungeon.  These Linux Dungeon Crawls will build upon skills of the previous Crawls in the series.  Look to the strange_manuscript for clues.

**Crawl Instructions:** [The Archivist's Vault](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Archivists-Vault.md)

---

### 👁️ The Shadow Account (Intro 1C)

An introductory Linux Dungeon Crawl.  Students must locate and remove a malicious user and all of the user's files. These Linux Dungeon Crawls will build upon skills of the previous Crawls in the series.  Look to the strange_manuscript for clues.

**Crawl Instructions:** [The Shadow Account](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Shadow-Account.md)

---

### 🏴‍☠️ The Sunken Vault 💰 (Level 1)

An introductory Linux Dungeon Crawl that blends navigation, hidden files, process management, permissions, and basic scripting.
Students must traverse the vault, uncover hidden clues, eliminate a lurking process, and unlock an encrypted treasure guarded by a disarm script.

**Crawl Instructions:** [The-Sunken-Vault.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/The-Sunken-Vault.md)

---

### 🐍 The Hydra Head Hunt (Level 2)

A multi-process Linux challenge focused on identifying and defeating hidden and persistent processes, environment variables, and command hijacking.

**Crawl Instructions:** [The-Hydra-Head-Hunt.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Hydra-Head-Hunt.md#-hydra-head-hunt)

---

### 👻 The Ghost Watch (Level 3)

An advanced Linux investigation challenge centered on identifying and stopping a persistent “ghost” process that respawns until the true source is discovered.

**Crawl Instructions:** [The-Ghost-Watch.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/The-Ghost-Watch.md#-ghost-watch)

---

### 🧟 Ghost Watch II: The Necromancer (Level 4)

A simple ghost is never truly gone.
In this challenge, you face a necromancer process that continuously resurrects a ghost child. Killing the ghost alone is futile. The sins of the parent...

**Crawl Instructions:** [Ghost-Watch-II-Necromancer.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Ghost-Watch-II-Necromancer.md)

---

### 🐉 The Dragon’s Cron (Level 5)

A powerful dragon stalks the system, awakening every minute without fail. Killing symptoms will not stop it. To restore peace, you must uncover how the dragon persists and remove it at the source.

This dungeon emphasizes investigation over brute force.

**Crawl Instructions:** [The-Dragon-Cron.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/The-Dragon-Cron.md#-the-dragons-cron)

---

### 🔥The Trial of Eternal Fire (Levels 1-5 Cumulative)🔥

Master the Trial of Eternal Fire by defeating your enemies in the correct order.  Only by defeating them in order will you find the Flamebound Treasure Chest.

**Crawl Instructions:** [Trial-Of-Eternal-Fire.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Trial-Of-Eternal-Fire.md#-trial-of-eternal-fire)

---

### 👹 Ghost Watch III: The Firewarden’s Chant (Level 6)

The Firewarden's Chant echos through the systemd.  Slay the processes and they rise again.  The flame is not wild; it is supervised.

**Crawl Instructions:** [Firewardens-Chant.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Firewardens-Chant.md)

---

### 🐲 Dragon’s Awakening (Level 7)

The Dragon does not run. It waits.
It does not persist through processes, but through invocation.

Each login is a spark. Each session, a breath. And somewhere in the shadows of the filesystem, a sealed relic ensures the flame remembers how to return. Killing what you see changes nothing. The Dragon is already gone when you arrive… and already coming back when you leave.

**Crawl Instructions:** [Dragons-Awakening.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Dragons-Awakening.md)

---

# 🛡️ Commands to Help on Your Quests

| Command | Description |
|---------|-------------|
| nano | Command line text editor |
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

