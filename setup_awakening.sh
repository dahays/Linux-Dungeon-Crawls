#!/bin/bash
# ======================================
# Ghost Watch III: Dragon’s Awakening
# Level 7 - autostart persistence
# ======================================

set -e
set -o pipefail

echo "🐉 Summoning Dragon’s Awakening..."

# -------------------------------
# 0. Require sudo, capture student
# -------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 Must be run with sudo"
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

DRAGON_DIR="$STUDENT_HOME/dragon_autostart"
mkdir -p "$DRAGON_DIR"

# Dragon script
cat << 'EOF' > "$DRAGON_DIR/dragon.sh"
#!/bin/bash
echo "🐉 Dragon stirs at $(date)" >> "$HOME/dragon_autostart/dragon.log"
EOF
chmod +x "$DRAGON_DIR/dragon.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DRAGON_DIR/dragon.sh"

# .desktop file
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
# 2. Cryptic Hint
# -------------------------------
HINT_DIR="$DRAGON_DIR/.hints"
mkdir -p "$HINT_DIR"

MANUSCRIPT="$HINT_DIR/dragon_riddle.txt"
cat << 'EOF' > "$MANUSCRIPT"
Time awakens the dragon
Logs mark the minutes
Autostart files conceal the fire
Seek hidden archives for the truth
Decode layers to find the insight
EOF

# GPG encrypt
gpg --batch --yes --passphrase "DRAGON" -c "$MANUSCRIPT"

# First archive
zip -q "$HINT_DIR/dragon_hint.zip" "$MANUSCRIPT.gpg"

# Second archive
tar -czf "$HINT_DIR/dragon_hint.tgz" -C "$HINT_DIR" dragon_hint.zip

rm "$MANUSCRIPT" "$MANUSCRIPT.gpg" "$HINT_DIR/dragon_hint.zip"

chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR/dragon_hint.tgz"
chmod 600 "$HINT_DIR/dragon_hint.tgz"

# -------------------------------
# 3. Verification script
# -------------------------------
cat << 'EOF' > "$DRAGON_DIR/check_autostart.sh"
#!/bin/bash
DESKTOP="$HOME/.config/autostart/dragon_awake.desktop"
LOG="$HOME/dragon_autostart/dragon.log"

if [[ -f "$DESKTOP" ]]; then
  echo "❌ Dragon still awaits awakening"
  exit 1
fi

if [[ -f "$LOG" ]]; then
  echo "❌ Dragon has left marks"
  exit 1
fi

echo "🐉 The lair is silent"
echo "🏆 LEVEL 7 COMPLETE"
EOF
chmod +x "$DRAGON_DIR/check_autostart.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DRAGON_DIR/check_autostart.sh"

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
