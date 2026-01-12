#!/bin/bash
# ======================================
# The Dragon's Cron - Setup Script
# Teaches cron persistence and investigation
# ======================================

set -e
set -o pipefail

echo "🐉 Awakening The Dragon's Cron..."

# -------------------------------
# 0. Require sudo, capture student
# -------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 This installer must be run with sudo."
  exit 1
fi

if [[ -z "$SUDO_USER" || "$SUDO_USER" == "root" ]]; then
  echo "🚫 Cannot determine invoking user."
  exit 1
fi

STUDENT_USER="$SUDO_USER"
STUDENT_HOME="$(getent passwd "$STUDENT_USER" | cut -d: -f6)"

echo "🎯 Deploying for user: $STUDENT_USER"
echo "🏠 Target home: $STUDENT_HOME"

# -------------------------------
# 1. Create dragon lair directory
# -------------------------------
DUNGEON_DIR="$STUDENT_HOME/dragon_cron"

mkdir -p "$DUNGEON_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR"
cd "$DUNGEON_DIR"

# -------------------------------
# 2. Create dragon cron script
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/dragon_cron.sh"
#!/bin/bash
echo "🐉 Dragon stirs at $(date)" >> "$HOME/dragon_cron/dragon.log"
EOF

chmod +x "$DUNGEON_DIR/dragon_cron.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/dragon_cron.sh"

# -------------------------------
# 3. Install cron job (student-owned)
# -------------------------------
sudo -u "$STUDENT_USER" crontab -l 2>/dev/null | \
  grep -v dragon_cron.sh | \
  sudo -u "$STUDENT_USER" crontab -

sudo -u "$STUDENT_USER" bash -c \
  "(crontab -l 2>/dev/null; echo '* * * * * \$HOME/dragon_cron/dragon_cron.sh') | crontab -"

# -------------------------------
# 4. Create verification script
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/check_dragon.sh"
#!/bin/bash

echo "🔎 Inspecting the lair..."
echo

LOG="$HOME/dragon_cron/dragon.log"

if crontab -l 2>/dev/null | grep -q dragon_cron.sh; then
  echo "❌ The dragon's ritual still exists."
  exit 1
fi

if [[ -f "$LOG" ]]; then
  echo "❌ The dragon still leaves scorch marks."
  exit 1
fi

echo "🐉 The lair is silent."
echo
echo "✔ Persistence removed"
echo "✔ No cron rituals remain"
echo
echo "🏆 DRAGON CRON COMPLETE"
exit 0
EOF

chmod +x "$DUNGEON_DIR/check_dragon.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/check_dragon.sh"

# -------------------------------
# 5. Final instructions
# -------------------------------
cat << EOF

🐉 THE DRAGON'S CRON IS ACTIVE

✔ Installed for user: $STUDENT_USER
✔ Dungeon location: ~/dragon_cron
✔ Cron job executes every minute

Hints:
- Killing processes will not help
- Cron does not care about shells
- Look where time itself is scheduled

To begin:
  cd ~/dragon_cron

To verify victory:
  ./check_dragon.sh

EOF
