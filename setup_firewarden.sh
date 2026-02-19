#!/bin/bash
# ======================================
# Ghost Watch III: The Firewarden’s Chant
# Level 6 Linux Dungeon Crawl
# systemd user persistence + layered archives
# REV9.1.BETA
# ======================================

set -e
set -o pipefail

echo "🔥 Summoning the Firewarden's Chant REV9.2.BETA"

# -------------------------------------------------
# 0. Require sudo, capture invoking user
# -------------------------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 This ritual must be invoked with sudo."
  exit 1
fi

if [[ -z "$SUDO_USER" || "$SUDO_USER" == "root" ]]; then
  echo "🚫 Cannot determine invoking user."
  exit 1
fi

STUDENT_USER="$SUDO_USER"
STUDENT_UID=$(id -u "$STUDENT_USER")
STUDENT_HOME="$(getent passwd "$STUDENT_USER" | cut -d: -f6)"

echo "🎯 Bound to adventurer: $STUDENT_USER"

# -------------------------------------------------
# 1. Enable lingering (root is fine)
# -------------------------------------------------
loginctl enable-linger "$STUDENT_USER"

# -------------------------------------------------
# 2. Create dungeon directory
# -------------------------------------------------
DUNGEON_DIR="$STUDENT_HOME/firewarden_chant"
mkdir -p "$DUNGEON_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR"

# -------------------------------------------------
# 3. Firewarden script
# -------------------------------------------------
cat << 'EOF' > "$DUNGEON_DIR/firewarden.sh"
#!/bin/bash
LOG="$HOME/firewarden_chant/fire.log"
while true; do
  echo "🔥 Firewarden watches at $(date)" >> "$LOG"
  sleep 5
done
EOF

chmod +x "$DUNGEON_DIR/firewarden.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/firewarden.sh"

# -------------------------------------------------
# 4. systemd user service
# -------------------------------------------------
USER_SYSTEMD_DIR="$STUDENT_HOME/.config/systemd/user"
mkdir -p "$USER_SYSTEMD_DIR"

SERVICE_FILE="$USER_SYSTEMD_DIR/firewarden-chant.service"

cat << EOF > "$SERVICE_FILE"
[Unit]
Description=The Firewarden's Endless Chant

[Service]
ExecStart=$DUNGEON_DIR/firewarden.sh
Restart=always
RestartSec=3

[Install]
WantedBy=default.target
EOF

chown "$STUDENT_USER:$STUDENT_USER" "$SERVICE_FILE"
chmod 644 "$SERVICE_FILE"

# -------------------------------------------------
# 5. Multi-Layer Hint (no extensions)
# -------------------------------------------------
HINT_DIR="$DUNGEON_DIR/.locked_chest"
mkdir -p "$HINT_DIR"
chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR"
chmod 700 "$HINT_DIR"

PLAINTEXT="$HINT_DIR/strange_manuscript"

cat << 'EOF' > "$PLAINTEXT"
You uncover a brittle page etched with ash and ink:

The flame you chase is not wild.
It is disciplined.

Killing the spark does nothing
when a keeper commands its return.

Do not hunt the child process.
Seek the summoner.

The chant is bound to a name.
Names live in unit scrolls.

List what the user commands.
Inspect what starts by default.
Silence the voice.
Then sever its oath to awaken again.

Only when the summoner sleeps
will the fire truly fade.
EOF

chown "$STUDENT_USER:$STUDENT_USER" "$PLAINTEXT"
chmod 600 "$PLAINTEXT"

# Convert to hex
HEX_FILE="$HINT_DIR/strange_hex"
sudo -u "$STUDENT_USER" xxd -p "$PLAINTEXT" > "$HEX_FILE"
rm -f "$PLAINTEXT"

# Layer 3 (tar)
LAYER3="$HINT_DIR/layer_three"
sudo -u "$STUDENT_USER" tar -cf "$LAYER3" -C "$HINT_DIR" strange_hex
rm -f "$HEX_FILE"

# Layer 2 (tar.gz but no extension)
LAYER2="$HINT_DIR/layer_two"
sudo -u "$STUDENT_USER" tar -czf "$LAYER2" -C "$HINT_DIR" layer_three
rm -f "$LAYER3"

# Layer 1 (zip but no extension)
FINAL_ARCHIVE="$HINT_DIR/forgotten_scroll"
sudo -u "$STUDENT_USER" zip -q "$FINAL_ARCHIVE" "$LAYER2"
rm -f "$LAYER2"

chown "$STUDENT_USER:$STUDENT_USER" "$FINAL_ARCHIVE"
chmod 600 "$FINAL_ARCHIVE"

# -------------------------------------------------
# 6. Verification Script
# -------------------------------------------------
cat << 'EOF' > "$DUNGEON_DIR/check_firewarden.sh"
#!/bin/bash

echo "🔎 Inspecting the Firewarden's Chant..."
echo

FAIL=0

# Service running?
if systemctl --user is-active --quiet firewarden-chant.service; then
  echo "❌ The Firewarden still chants."
  FAIL=1
fi

# Service enabled?
if systemctl --user is-enabled --quiet firewarden-chant.service; then
  echo "❌ The chant will return upon login."
  FAIL=1
fi

# Lingering still enabled?
if loginctl show-user "$USER" | grep -q "Linger=yes"; then
  echo "❌ Lingering still binds the summoner."
  FAIL=1
fi

# Residual process?
if pgrep -f firewarden.sh >/dev/null; then
  echo "❌ Residual Firewarden processes detected."
  FAIL=1
fi

# Manuscript restored?
MANUSCRIPT="$HOME/firewarden_chant/.locked_chest/strange_manuscript"

if [[ ! -f "$MANUSCRIPT" ]]; then
  echo "❌ The Strange Manuscript has not been restored."
  FAIL=1
else
  # Validate expected content
  if ! grep -q "Seek the summoner" "$MANUSCRIPT"; then
    echo "❌ Manuscript content invalid or improperly decoded."
    FAIL=1
  fi
fi

if [[ "$FAIL" -eq 1 ]]; then
  echo
  echo "🔥 The fire still smolders."
  exit 1
fi

echo
echo "🜂 THE CHANT IS BROKEN"
echo "✔ Service stopped"
echo "✔ Startup disabled"
echo "✔ Lingering severed"
echo "✔ No residual process"
echo "✔ Manuscript restored and verified"
echo
echo "🏆 LEVEL 6 COMPLETE"
exit 0
EOF

chmod +x "$DUNGEON_DIR/check_firewarden.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/check_firewarden.sh"

# -------------------------------------------------
# Final message
# -------------------------------------------------
cat << EOF

🔥 THE FIREWARDEN'S CHANT IS ACTIVE

Dungeon location:
  ~/firewarden_chant

The chant survives logout.
The flame answers to a name.
Scrolls hide beneath scrolls.

To awaken the Firewarden (run after first login):
  systemctl --user daemon-reload
  systemctl --user enable firewarden-chant.service
  systemctl --user start firewarden-chant.service

To verify victory:
  ./check_firewarden.sh

Trace the summoner,
not the summoned.

EOF
