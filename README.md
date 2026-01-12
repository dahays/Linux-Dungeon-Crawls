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

**Crawl Instructions:** [The-Hydra-Head-Hunt.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Hydra-Head-Hunt.md#-hydra-head-hunt)

### 👻 The Ghost Watch (Level 3)

An advanced Linux investigation challenge centered on identifying and stopping a persistent “ghost” process that respawns until the true source is discovered.

**Crawl Instructions:** [The-Ghost-Watch.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/The-Ghost-Watch.md#-ghost-watch)

### 👻🕯️  Ghost Watch II: The Necromancer (Level 4)
An advanced Linux dungeon crawl.

A simple ghost is never truly gone.
In this challenge, you face a necromancer process that continuously resurrects a ghost child. Killing the ghost alone is futile. The sins of the parent...

**Crawl Instructions:** [Ghost-Watch-II-Necromancer.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/Ghost-Watch-II-Necromancer.md)

### 🐉 The Dragon’s Cron (Level 5)

A powerful dragon stalks the system, awakening every minute without fail. Killing symptoms will not stop it. To restore peace, you must uncover how the dragon persists and remove it at the source.

This dungeon emphasizes investigation over brute force.

**Crawl Instructions:** [The-Dragon-Cron.md](https://github.com/dahays/Linux-Dungeon-Crawls/blob/main/The-Dragon-Cron.md#-the-dragons-cron)

