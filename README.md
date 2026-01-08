# 🗝️ Linux Dungeon Crawls

## Overview

**Linux Dungeon Crawls** is a collection of themed, hands-on Linux challenges designed to help students practice real-world command-line skills through guided exploration and problem solving.

Each dungeon is self-contained and installed using a single setup script. Once installed, students navigate the environment, follow clues, and complete objectives using standard Linux tools.

New dungeons can be added over time using the same structure and installation process.

---

## Getting Started

All dungeon crawls follow the same basic workflow:

1. Download the setup script using `wget`
2. Make the script executable
3. Run the script
4. Enter the dungeon directory and begin

---

## Available Dungeon Crawls

### 🐍 The Hydra Head Hunt (Level 2)

A multi-process Linux challenge focused on identifying and defeating hidden and persistent processes, environment variables, and command hijacking.

**Crawl Instructions:**  
`The-Hydra-Head-Hunt.md`

**Install Script:**
```bash
wget -O setup_hydra.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_hydra.sh

chmod +x setup_hydra.sh

./setup_hydra.sh
```
### 👻 The Ghost Watch (Level 3)

An advanced Linux investigation challenge centered on identifying and stopping a persistent “ghost” process that respawns until the true source is discovered.

**Crawl Instructions:**  
`The-Ghost-Watch.md`

**Install Script:**
```bash
wget -O setup_ghost.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_ghost.sh

chmod +x setup_ghost.sh

./setup_ghost.sh
```
