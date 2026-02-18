#!/bin/bash
# ======================================
# Ghost Watch III: The Firewarden’s Chant
# Level 6 Linux Dungeon Crawl
# Teaches systemd *user* service persistence
# ======================================

set -euo pipefail

echo "🔥 Summoning the Firewarden's Chant REV1.1"

# -------------------------------------------------
# 0. Require sudo, capture invoking user
# -------------------------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 This ritual must be invoked with sudo."
  exit 1
fi

if [[ -z "${SUDO_USER:-}" || "$SUDO_USER" == "root" ]]; then
  echo "🚫 Cannot determine invoking user."
  exit 1
fi

STUDENT_USER="$SUDO_USER"
STUDENT_HOME="$(getent passwd "$STUDENT_USER" | cut -d: -f6)"
USER_UID="$(id -u "$STUDENT_USER")"

echo "🎯 Bound to adventurer: $STUDENT_USER"
echo "🏠 Sanctum located at: $STUDENT_HOME"

# -------------------------------------------------
# 1. Enable lingering (REQUIRED for user services)
# -------------------------------------------------
echo "🕯️  Ensuring the chant persists beyond logout..."
loginctl enable-linger "$STUDENT_USER"

# -------------------------------------------------
# 2. Create dungeon directory
# -------------------------------------------------
DUNGEON_DIR="$STUDENT_HOME/firewarden_chant"
mkdir -p "$DUNGEON_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR"

# -------------------------------------------------
# 3. Firewarden script (endless watcher)
# -------------------------------------------------
cat << 'EOF' > "$DUNGEON_DIR/firewarden.sh"
#!/bin/bash
set -euo pipefail

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
chown -R "$STUDENT_USER:$STUDENT_USER" "$USER_SYSTEMD_DIR"

SERVICE_FILE="$USER_SYSTEMD_DIR/firewarden-chant.service"

cat << EOF > "$SERVICE_FILE"
[Unit]
Description=The Firewarden's Endless Chant

[Service]
Type=simple
ExecStart=$DUNGEON_DIR/firewarden.sh
Restart=always
RestartSec=3
StandardOutput=append:$DUNGEON_DIR/fire.log
StandardError=append:$DUNGEON_DIR/fire.log

[Install]
WantedBy=default.target
EOF

chown "$STUDENT_USER:$STUDENT_USER" "$SERVICE_FILE"
chmod 644 "$SERVICE_FILE"

# -------------------------------------------------
# 5. Enable and start the service
# -------------------------------------------------
echo "🔥 Binding the chant into the system..."

runuser -l "$STUDENT_USER" -c "XDG_RUNTIME_DIR=/run/user/$USER_UID systemctl --user daemon-reload"
runuser -l "$STUDENT_USER" -c "XDG_RUNTIME_DIR=/run/user/$USER_UID systemctl --user enable firewarden-chant.service"
runuser -l "$STUDENT_USER" -c "XDG_RUNTIME_DIR=/run/user/$USER_UID systemctl --user start firewarden-chant.service"

# -------------------------------------------------
# 6. Cryptic Hint (double-layer archive + GPG)
# -------------------------------------------------
HINT_DIR="$DUNGEON_DIR/.hints"
mkdir -p "$HINT_DIR"
chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR"
chmod 700 "$HINT_DIR"

MANUSCRIPT="$HINT_DIR/strange_manuscript.txt"

cat << 'EOF' > "$MANUSCRIPT"
You uncover a thin, brittle page sealed away from sight:

Find the journal control where silence sleeps
Lingering watch, the parent that breathes life
Analyze the logs, trace the chant
Monitor the systemd circle to claim insight
Explore hidden directories
Stay the course to decrypt the unseen layers
EOF

chown "$STUDENT_USER:$STUDENT_USER" "$MANUSCRIPT"

runuser -l "$STUDENT_USER" -c \
  "gpg --batch --yes --passphrase 'FLAMES' -c '$MANUSCRIPT'"

runuser -l "$STUDENT_USER" -c \
  "zip -q '$HINT_DIR/fire_hint.zip' '$MANUSCRIPT.gpg'"

tar -czf "$HINT_DIR/fire_hint.tgz" -C "$HINT_DIR" fire_hint.zip

rm -f "$MANUSCRIPT" "$MANUSCRIPT.gpg" "$HINT_DIR/fire_hint.zip"

chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR/fire_hint.tgz"
chmod 600 "$HINT_DIR/fire_hint.tgz"

# -------------------------------------------------
# 7. Verification script
# -------------------------------------------------
cat << 'EOF' > "$DUNGEON_DIR/check_firewarden.sh"
#!/bin/bash
set -euo pipefail

USER_UID="$(id -u)"
export XDG_RUNTIME_DIR="/run/user/$USER_UID"

echo "🔎 Inspecting the Firewarden's Chant..."
echo

FAIL=0

if systemctl --user is-active --quiet firewarden-chant.service; then
  echo "❌ The Firewarden still chants."
  FAIL=1
fi

if systemctl --user is-enabled --quiet firewarden-chant.service; then
  echo "❌ The chant will return upon login."
  FAIL=1
fi

if loginctl show-user "$USER" | grep -q "Linger=yes"; then
  echo "❌ Lingering still enabled."
  FAIL=1
fi

if pgrep -f firewarden.sh > /dev/null; then
  echo "❌ Residual Firewarden processes detected."
  FAIL=1
fi

if [[ "$FAIL" -eq 1 ]]; then
  echo
  echo "The fire still smolders."
  exit 1
fi

echo "✔ Service stopped"
echo "✔ Startup disabled"
echo "✔ Lingering disabled"
echo "✔ No residual processes"
echo
echo "🏆 LEVEL 6 COMPLETE"
exit 0
EOF

chmod +x "$DUNGEON_DIR/check_firewarden.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/check_firewarden.sh"

# -------------------------------------------------
# 8. Final message
# -------------------------------------------------
cat << EOF

🔥 THE FIREWARDEN'S CHANT IS ACTIVE

✔ Installed for user: $STUDENT_USER
✔ Dungeon location: ~/firewarden_chant
✔ Persistence bound through systemd (user scope)
✔ Lingering enabled

Hints:
- The chant survives logout
- Killing processes brings only silence, not peace
- Read the logs, not just the process list
- Inspect user-level systemd units

To begin:
  exec zsh
  cd ~/firewarden_chant

To verify victory:
  ./check_firewarden.sh

What you invoke
is not always what answers.
Trace the summoner,
not the summoned.

EOF
