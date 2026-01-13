#!/bin/bash
# ======================================
# Ghost Watch III: The Firewarden’s Chant
# Level 6 - systemd user service persistence
# ======================================

set -e
set -o pipefail

echo "🔥 Summoning the Firewarden's Chant..."

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

echo "🎯 Deploying for: $STUDENT_USER"
echo "🏠 Home: $STUDENT_HOME"

# -------------------------------
# 1. Create dungeon directory
# -------------------------------
DUNGEON_DIR="$STUDENT_HOME/firewarden_service"
mkdir -p "$DUNGEON_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR"

# -------------------------------
# 2. Firewarden script
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/firewarden.sh"
#!/bin/bash
while true; do
  echo "🔥 Firewarden watches at $(date)" >> "$HOME/firewarden_service/fire.log"
  sleep 5
done
EOF
chmod +x "$DUNGEON_DIR/firewarden.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/firewarden.sh"

# -------------------------------
# 3. systemd user service
# -------------------------------
USER_SYSTEMD_DIR="$STUDENT_HOME/.config/systemd/user"
mkdir -p "$USER_SYSTEMD_DIR"
SERVICE_FILE="$USER_SYSTEMD_DIR/firewarden.service"
cat << EOF > "$SERVICE_FILE"
[Unit]
Description=The Firewarden watches endlessly

[Service]
ExecStart=$DUNGEON_DIR/firewarden.sh
Restart=always

[Install]
WantedBy=default.target
EOF

chown "$STUDENT_USER:$STUDENT_USER" "$SERVICE_FILE"
chmod 644 "$SERVICE_FILE"

# -------------------------------
# 4. Enable and start
# -------------------------------
sudo -u "$STUDENT_USER" systemctl --user daemon-reload
sudo -u "$STUDENT_USER" systemctl --user enable firewarden.service
sudo -u "$STUDENT_USER" systemctl --user start firewarden.service

# -------------------------------
# 5. Cryptic Hint (double-zipped, GPG)
# -------------------------------
HINT_DIR="$DUNGEON_DIR/.hints"
mkdir -p "$HINT_DIR"
chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR"

# Create manuscript
MANUSCRIPT="$HINT_DIR/strange_manuscript.txt"
cat << 'EOF' > "$MANUSCRIPT"
Fire whispers where silence sleeps
Always watch the parent that breathes life
Read the logs, trace the chant
Enter the systemd circle to claim insight
Never stop exploring hidden directories
Dare to decrypt the unseen layers
EOF

# Encrypt manuscript
gpg --batch --yes --passphrase "FLAME" -c "$MANUSCRIPT"

# First archive
zip -q "$HINT_DIR/fire_hint.zip" "$MANUSCRIPT.gpg"

# Second archive
tar -czf "$HINT_DIR/fire_hint.tgz" -C "$HINT_DIR" fire_hint.zip

# Remove intermediate files
rm "$MANUSCRIPT" "$MANUSCRIPT.gpg" "$HINT_DIR/fire_hint.zip"

chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR/fire_hint.tgz"
chmod 600 "$HINT_DIR/fire_hint.tgz"

# -------------------------------
# 6. Verification script
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/check_systemd.sh"
#!/bin/bash
echo "🔎 Checking Firewarden service..."
if systemctl --user is-active --quiet firewarden.service; then
  echo "❌ Firewarden is still chanting!"
  exit 1
fi
echo "✔ Service stopped"
echo "✔ Startup disabled"
echo "🏆 LEVEL 6 COMPLETE"
EOF
chmod +x "$DUNGEON_DIR/check_systemd.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/check_systemd.sh"

# -------------------------------
# 7. Final message
# -------------------------------
cat << EOF

🔥 FIREWARDEN'S CHANT READY

✔ Installed for user: $STUDENT_USER
✔ Dungeon located at: ~/firewarden_chant
✔ Familiar words carry altered meaning

To begin:
  cd ~/firewarden_chant

To verify victory:
  ./check_firewarden.sh

What you invoke
is not always what answers.
Listen to the shape of commands,
not their names.


EOF
