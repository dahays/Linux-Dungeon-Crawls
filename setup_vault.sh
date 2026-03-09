#!/bin/bash
# ======================================
# Linux Dungeon Crawl Intro 1B
# The Archivist's Vault
# Intro to Bash Scripting
# ======================================

set -e

echo "🏰 Preparing the Archivist's Vault..."

BASE_DIR="$HOME/dungeon_vault"
VAULT_DIR="$BASE_DIR/vault_entrance"

mkdir -p "$VAULT_DIR"

# -------------------------------------------------
# Create Strange Manuscript
# -------------------------------------------------
cat << 'EOF' > "$VAULT_DIR/strange_manuscript.txt"
===========================
THE STRANGE MANUSCRIPT
===========================

Adventurer,

Within these ancient halls lies the Archivist's Vault.
To unlock its secrets, you must craft a ritual of creation.

The vault desires three sacred artifacts:

1. A charred scroll that whispers secrets of the past.
2. Alchemical notes that hold the formulas of the wise.
3. A ritual script to summon the magic within.

Hints for the Wise:

- Begin by asking the vault for its title; every vault must bear a name.
- The vault itself is a container that holds your artifacts.
- Each artifact must exist within the vault, forged by your own hands.
- The Guardian will watch over your creation. If any artifact is missing, the vault remains sealed.
- Make sure your ritual script can be executed in the chamber of the vault.

May your Bash be strong, and your logic clever.
Only those who demonstrate mastery of the basics
shall pass this trial.

===========================
EOF

# -------------------------------------------------
# Create Check Script
# -------------------------------------------------
cat << 'EOF' > "$VAULT_DIR/check_vault.sh"
#!/bin/bash

echo
echo "👁️  The Guardian of the Vault awakens..."
echo

read -p "Enter the vault name you created: " vault

if [ ! -d "$vault" ]; then
    echo "❌ The vault does not exist."
    exit 1
fi

missing=0

for artifact in charred_scroll.txt alchemical_notes.txt begin_ritual.sh
do
    if [ ! -f "$vault/$artifact" ]; then
        echo "❌ Missing artifact: $artifact"
        missing=1
    fi
done

if [ $missing -eq 0 ]; then
    echo
    echo "🗝️ The Guardian nods in approval."
    echo "The vault has been constructed correctly."
    echo
    echo "🏆 Dungeon Complete!"
else
    echo
    echo "⚠️ The vault is incomplete. Some artifacts are missing."
fi
EOF

chmod +x "$VAULT_DIR/check_vault.sh"

echo
echo "✅ Dungeon prepared!"
echo "You should navigate to:"
echo "cd $VAULT_DIR"
echo
echo "You  will find a mysterious manuscript guiding your quest."