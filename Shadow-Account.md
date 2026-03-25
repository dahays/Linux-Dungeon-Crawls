# 👁️ The Shadow Account   

(Linux Dungeon Crawl Intro 1C)

---

## Overview
A dark presence has infiltrated the system.

An unknown user has created an account and left traces behind. This entity must be identified and completely removed.

This dungeon introduces basic user account investigation and system cleanup.

The `strange_manuscript.txt` contains your instructions. Read it carefully.

---

## Setup Instructions

Open a terminal.

Download the setup script:
```bash
wget -O setup_shadow.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_shadowaccount.sh
```
Make the script executable:
```bash
chmod +x setup_shadow.sh
```
Run the setup script:
```bash
./setup_shadow.sh
```
Enter the dungeon:
```bash
cd ~/dungeon_shadow/shadow_chamber
```
---

## Objectives

You must:

- Identify the malicious user account
- Investigate its files and directories
- Remove the user from the system
- Remove all associated files and directories

Precision matters. Partial removal will fail.

When complete, verify your success:

./check_shadow.sh

---

## Completion Check

Upon success, you will see:

🏆 Dungeon Complete!

---

## Rules

- Do not modify the check script
- Do not edit the setup script
- Use standard Linux commands
- Do not guess — investigate

---

## Deliverables

Submit screenshots of:

- Evidence of the user account before removal
- The user's home directory contents
- The final successful check output

Also include a brief explanation:

- How you identified the user
- How you removed the account
- How you verified all traces were gone

---

## Final Note to Adventurers

Some threats are obvious.

Others hide in plain sight.

Learn to see what does not belong.

The next dungeon will not reveal its enemy so easily.
