#!/bin/bash
# ======================================
# Linux Dungeon Crawl I-C
# The Shadow Account
# Intro to Users & Cleanup
# ======================================

set -e

echo "🏰 Preparing The Shadow Account Dungeon..."

BASE_DIR="$HOME/dungeon_shadow"
SHADOW_DIR="$BASE_DIR/shadow_chamber"

mkdir -p "$SHADOW_DIR"

# -------------------------------------------------
# Create Strange Manuscript
# -------------------------------------------------
cat << 'EOF' > "$SHADOW_DIR/strange_manuscript.txt"
===========================
THE STRANGE MANUSCRIPT
===========================

Adventurer,

A dark presence lingers within this system.
An unknown entity has created a hidden account
and left traces throughout the realm.

The Archivists have identified only a home:

"Barad-dûr"

Your task is clear.

You must:

- Locate the shadow account
- Investigate its presence
- Remove the account from the system
- Erase all remnants of its influence

Hints for the Wise:

- There exists a registry of all users.
- Every user has a place they call home.
- Shadows leave traces in multiple locations.
- Removing the name alone is not enough —
  the roots must be destroyed as well.

When the system is cleansed,
summon the Guardian.

===========================
EOF

# -------------------------------------------------
# Create Malicious User (Sauron)
# -------------------------------------------------
echo "👁️ Creating shadow user..."

sudo useradd -m sauron

sudo bash -c 'cat << EOF > /home/sauron/one_ring.txt
One Ring to rule them all,
One Ring to find them,
One Ring to bring them all,
and in the darkness bind them.
EOF'

sudo touch /home/sauron/orc_plans.txt
sudo mkdir -p /home/sauron/mordor/logs
sudo touch /home/sauron/mordor/logs/war_preparations.log

sudo chown -R sauron:sauron /home/sauron

# -------------------------------------------------
# Create Check Script
# -------------------------------------------------
cat << 'EOF' > "$SHADOW_DIR/check_shadow.sh"
#!/bin/bash

echo
echo "👁️ The Guardian searches for lingering shadows..."
echo

# Check if user exists
if id "sauron" &>/dev/null; then
    echo "❌ The shadow still has a name in the system."
    exit 1
fi

# Check if home directory exists
if [ -d "/home/sauron" ]; then
    echo "❌ The shadow's domain still exists."
    exit 1
fi

echo
echo "🗡️ The shadow has been purged from the system."
echo "The realm is safe once more."
echo
echo "🏆 Dungeon Complete!"
EOF

chmod +x "$SHADOW_DIR/check_shadow.sh"

echo
echo "✅ Dungeon prepared!"
echo "Students should navigate to:"
echo "cd $SHADOW_DIR"