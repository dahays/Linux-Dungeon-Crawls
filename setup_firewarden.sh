#!/bin/bash

# 👹 Ghost Watch III: The Firewarden’s Chant
# REV 1.2 – Clean persistence logic + improved verification alignment

clear
echo "👹 Summoning the Firewarden's Chant REV1.2"

STUDENT_USER=$(logname 2>/dev/null || echo $SUDO_USER)
HOME_DIR=$(eval echo "~$STUDENT_USER")
DUNGEON_DIR="$HOME_DIR/firewarden_chant"
SERVICE_DIR="$HOME_DIR/.config/systemd/user"
SERVICE_FILE="$SERVICE_DIR/firewarden-chant.service"
SCRIPT_FILE="$DUNGEON_DIR/firewarden.sh"
CHECK_FILE="$DUNGEON_DIR/check_firewarden.sh"

echo "🔥 Bound to adventurer: $STUDENT_USER"
echo "🏰 Sanctum located at: $DUNGEON_DIR"

mkdir -p "$DUNGEON_DIR"
mkdir -p "$SERVICE_DIR"

########################################
# Create the chanting script
########################################
cat << 'EOF' > "$SCRIPT_FILE"
#!/bin/bash
LOG_DIR="$HOME/firewarden_chant"
LOG_FILE="$LOG_DIR/fire.log"

mkdir -p "$LOG_DIR"

while true; do
    echo "$(date): The Firewarden chants eternal flame..." >> "$LOG_FILE"
    sleep 5
done
EOF

chmod +x "$SCRIPT_FILE"
chown -R "$STUDENT_USER":"$STUDENT_USER" "$DUNGEON_DIR"

########################################
# Create systemd user service
########################################
cat << EOF > "$SERVICE_FILE"
[Unit]
Description=Firewarden Chant Service

[Service]
ExecStart=$SCRIPT_FILE
Restart=always
RestartSec=2

[Install]
WantedBy=default.target
EOF

chown "$STUDENT_USER":"$STUDENT_USER" "$SERVICE_FILE"

########################################
# Enable lingering (for persistence beyond logout)
########################################
echo "🔥 Ensuring the chant persists beyond logout..."
loginctl enable-linger "$STUDENT_USER"

########################################
# Reload and enable service
########################################
sudo -u "$STUDENT_USER" systemctl --user daemon-reload
sudo -u "$STUDENT_USER" systemctl --user enable firewarden-chant.service
sudo -u "$STUDENT_USER" systemctl --user start firewarden-chant.service

########################################
# Create verification script
########################################
cat << 'EOF' > "$CHECK_FILE"
#!/bin/bash

echo "🔎 Verifying the Firewarden’s fate..."

FAIL=0

# Check if service is active
if systemctl --user is-active --quiet firewarden-chant.service; then
    echo "❌ The Firewarden still chants."
    FAIL=1
else
    echo "✔ Service stopped."
fi

# Check if service is enabled
if systemctl --user is-enabled --quiet firewarden-chant.service; then
    echo "❌ The chant will resurrect on login."
    FAIL=1
else
    echo "✔ Startup disabled."
fi

# Check for running processes
if pgrep -f firewarden.sh > /dev/null; then
    echo "❌ Residual Firewarden processes detected."
    FAIL=1
else
    echo "✔ No lingering chant processes."
fi

# Warn about lingering (educational only)
if loginctl show-user "$USER" | grep -q Linger=yes; then
    echo "⚠ Lingering is enabled (user services persist beyond logout)."
fi

if [ "$FAIL" -eq 0 ]; then
    echo "🏆 LEVEL COMPLETE — The Firewarden is silent."
    exit 0
else
    echo "🔥 The ritual persists. Continue your investigation."
    exit 1
fi
EOF

chmod +x "$CHECK_FILE"
chown "$STUDENT_USER":"$STUDENT_USER" "$CHECK_FILE"

clear
echo "🔥 THE FIREWARDEN'S CHANT IS ACTIVE"
echo
echo "Installed for user: $STUDENT_USER"
echo "Dungeon location: ~/firewarden_chant"
echo "Persistence bound through systemd (user scope)"
echo "Lingering enabled"
echo
echo "To begin:"
echo "  cd ~/firewarden_chant"
echo
echo "To verify victory:"
echo "  ./check_firewarden.sh"
echo
echo "Trace the summoner,"
echo "not the summoned."
