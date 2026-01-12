#!/bin/bash
# ======================================
# Ghost Watch II: The Necromancer
# Teaches parent-child process control
# ======================================

set -e
set -o pipefail

echo "🕯️ Initializing Ghost Watch II: The Necromancer..."

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
# 1. Create dungeon directory
# -------------------------------
DUNGEON_DIR="$STUDENT_HOME/ghost_necromancer"

mkdir -p "$DUNGEON_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR"
cd "$DUNGEON_DIR"

# -------------------------------
# 2. Create ghost (child)
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/ghost.sh"
#!/bin/bash
sleep 3600
EOF

chmod +x "$DUNGEON_DIR/ghost.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/ghost.sh"

# -------------------------------
# 3. Create necromancer (parent)
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/necromancer.sh"
#!/bin/bash
# The necromancer resurrects the ghost endlessly

while true; do
    if ! pgrep -f ghost.sh >/dev/null; then
        "$HOME/ghost_necromancer/ghost.sh" &
    fi
    sleep 2
done
EOF

chmod +x "$DUNGEON_DIR/necromancer.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/necromancer.sh"

# -------------------------------
# 4. Launch necromancer as student
# -------------------------------
sudo -u "$STUDENT_USER" nohup "$DUNGEON_DIR/necromancer.sh" >/dev/null 2>&1 &

# -------------------------------
# 5. Create verification script
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/check_necromancer.sh"
#!/bin/bash

echo "🔎 Verifying ritual termination..."
echo

if pgrep -f necromancer.sh >/dev/null; then
    echo "❌ The necromancer still chants."
    exit 1
fi

if pgrep -f ghost.sh >/dev/null; then
    echo "❌ A ghost still walks."
    exit 1
fi

echo "🕯️ The ritual circle is broken."
echo "👻 The dead remain dead."
echo
echo "🏆 GHOST WATCH II COMPLETE"
exit 0
EOF

chmod +x "$DUNGEON_DIR/check_necromancer.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/check_necromancer.sh"

# -------------------------------
# 6. Final instructions
# -------------------------------
cat << EOF

🕯️ GHOST WATCH II: THE NECROMANCER READY

✔ Installed for user: $STUDENT_USER
✔ Dungeon location: ~/ghost_necromancer
✔ Necromancer process is active

Remember:
- Killing the ghost is not enough
- Trace the parent
- End the ritual at its source

To begin:
  cd ~/ghost_necromancer

To verify victory:
  ./check_necromancer.sh

EOF
