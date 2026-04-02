# 🏴‍☠️ The Sunken Vault 💰

## Overview
An introductory Linux Dungeon Crawl that blends navigation, hidden files, process management, permissions, and basic scripting.  
Students must traverse the vault, uncover hidden clues, eliminate a lurking process, and unlock an encrypted treasure guarded by a disarm script.

These crawls build foundational Linux skills that will be expanded in later dungeon levels such as Hydra Head Hunt, Ghost Watch, Dragon’s Cron, and beyond.

Look to the **strange_manuscript.txt** for guidance.

**Skills Practiced**
- File navigation (`cd`, `ls`, `pwd`)
- File inspection (`cat`, `less`)
- Hidden files (`.` files)
- Process management (`ps`, `kill`, `pgrep`)
- Permissions (`chmod`)
- Script execution (`./script.sh`)
- Basic cryptography concepts (GPG decryption)
- Reading and interpreting system clues

---

## Setup Instructions

Open a terminal.

Download the setup script:

```bash
wget -O setup_sunken_vault.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_sunken_vault.sh
```

Make the script executable:

```bash
chmod +x setup_sunken_vault.sh
```

Run the script:

```bash
./setup_sunken_vault.sh
```

Enter the dungeon:

```bash
cd ~/dungeon_level1
```

Run the check script to confirm completion:

```bash
./check_sunken_vault.sh
```