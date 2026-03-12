#!/bin/bash
# ======================================
# Ghost Watch III: Dragon’s Awakening
# Level 7 Linux Dungeon Crawl
# autostart persistence
# REV1.0
# ======================================

set -e
set -o pipefail

echo "🐉 Summoning Dragon's Awakening..."

# -------------------------------
# 0. Require sudo, capture student
# -------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 Must be run with sudo"
  exit 1
fi

if [[ -z "$SUDO_USER" || "$SUDO_USER" == "root" ]]; then
  echo "🚫 Cannot determine invoking user"
  exit 1
fi

STUDENT_USER="$SUDO_USER"
STUDENT_HOME="$(getent passwd "$STUDENT_USER" | cut -d: -f6)"

# -------------------------------
# 1. Autostart directories
# -------------------------------
AUTOSTART_DIR="$STUDENT_HOME/.config/autostart"
mkdir -p "$AUTOSTART_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$AUTOSTART_DIR"

DRAGON_DIR="$STUDENT_HOME/dragons_awakening"
mkdir -p "$DRAGON_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$DRAGON_DIR"

# Dragon script
cat << 'EOF' > "$DRAGON_DIR/dragon.sh"
#!/bin/bash
echo "🐉 Dragon stirs at $(date)" >> "$HOME/dragons_awakening/dragon.log"
EOF
chmod +x "$DRAGON_DIR/dragon.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DRAGON_DIR/dragon.sh"

# .desktop autostart file
cat << EOF > "$AUTOSTART_DIR/dragon_awake.desktop"
[Desktop Entry]
Type=Application
Exec=$DRAGON_DIR/dragon.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Dragon Awakens
Comment=Do not wake the dragon lightly
EOF
chown "$STUDENT_USER:$STUDENT_USER" "$AUTOSTART_DIR/dragon_awake.desktop"

# -------------------------------
# 2. Cryptic Hint (extensionless, layered)
# -------------------------------
HINT_DIR="$DRAGON_DIR/.charred_chest"
mkdir -p "$HINT_DIR"
chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR"
chmod 700 "$HINT_DIR"

MANUSCRIPT="$HINT_DIR/strange_manuscript"
cat << 'EOF' > "$MANUSCRIPT"
You uncover a thin, brittle page sealed away from sight:

Time awakens the dragon
Logs mark the minutes
Autostart files conceal the fire
Seek hidden archives for the truth
Decode layers to find the insight
EOF

# Encrypt manuscript (shift cipher of 11)
gpg --batch --yes --passphrase "OCLRZY" -c "$MANUSCRIPT"

# First archive
zip -q "$HINT_DIR/cinder" "$MANUSCRIPT.gpg"

# Second archive
tar -czf "$HINT_DIR/embers" -C "$HINT_DIR" cinder

# Cleanup
rm "$MANUSCRIPT" "$MANUSCRIPT.gpg" "$HINT_DIR/cinder"

chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR/embers"
chmod 600 "$HINT_DIR/embers"

# -------------------------------
# 3. Verification script
# -------------------------------
cat << 'EOF' > "$DRAGON_DIR/check_awakening.sh"
#!/bin/bash

DESKTOP="$HOME/.config/autostart/dragon_awake.desktop"
LOG="$HOME/dragons_awakening/dragon.log"

echo "🔎 Watching for signs of awakening..."
echo

if [[ -f "$DESKTOP" ]]; then
  echo "❌ The dragon is still poised to awaken"
  exit 1
fi

if [[ -f "$LOG" ]]; then
  echo "❌ The dragon has left scorch marks"
  exit 1
fi

echo "🐉 The lair remains silent."
echo "🏆 DRAGON’S AWAKENING COMPLETE"
EOF

chmod +x "$DRAGON_DIR/check_awakening.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DRAGON_DIR/check_awakening.sh"

# -------------------------------
# 4. Final instructions
# -------------------------------
cat << EOF

🐲 DRAGON'S AWAKENING READY

✔ Installed for user: $STUDENT_USER
✔ Dungeon located at: ~/dragons_awakening
✔ The beast waits beyond observation

To begin:
  cd ~/dragons_awakening

To verify victory:
  ./check_awakening.sh

There is nothing to kill.
Nothing to see.
The mark is left
only when time turns.
Shift the dragon to find the key,
be 1 with 1 and you will see.

EOF
