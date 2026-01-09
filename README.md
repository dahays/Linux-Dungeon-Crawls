# Linux Dungeon Crawls

## Overview

**Linux Dungeon Crawls** is a collection of themed, hands-on Linux challenges designed to help students practice real-world command-line skills through guided exploration and problem solving.

Each dungeon is self-contained and installed using a single setup script. Once installed, students navigate the environment, follow clues, and complete objectives using standard Linux tools.

Disclaimer: A Kali VM will provide the most ideal environment.  While not critically malicious, running these scripts from a local Linux machine is not advised.

---

## Getting Started

All dungeon crawls follow the same basic workflow:

1. Download the setup script using `wget`
2. Make the script executable
3. Run the script
4. Enter the dungeon directory to begin
5. Check for possible "clues" within each dungeon to help get started
6. Run the check script to verify success

---

## Available Dungeon Crawls

### 🐍 The Hydra Head Hunt (Level 2)

A multi-process Linux challenge focused on identifying and defeating hidden and persistent processes, environment variables, and command hijacking.

**Crawl Instructions:**  
[The-Hydra-Head-Hunt.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Hydra-Head-Hunt.md#-hydra-head-hunt)

**Install Script:**
```bash
wget -O setup_hydra.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_hydra.sh

chmod +x setup_hydra.sh

./setup_hydra.sh
```
### 👻 The Ghost Watch (Level 3)

An advanced Linux investigation challenge centered on identifying and stopping a persistent “ghost” process that respawns until the true source is discovered.

**Crawl Instructions:**  
[The-Ghost-Watch.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/The-Ghost-Watch.md#-ghost-watch)

**Install Script:**
```bash
wget -O setup_ghost.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_ghost.sh

chmod +x setup_ghost.sh

./setup_ghost.sh
```
### 🐉 The Dragon’s Cron (Level 4)

A powerful dragon stalks the system, awakening every minute without fail. Killing symptoms will not stop it. To restore peace, you must uncover how the dragon persists and remove it at the source.

This dungeon emphasizes investigation over brute force.

**Crawl Instructions:**  
[The-Dragon-Cron.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/The-Dragon-Cron.md#-the-dragons-cron)

**Install Script:**
```bash
wget -O setup_ghost.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_dragon.sh

chmod +x setup_dragon.sh

./setup_dragon.sh
