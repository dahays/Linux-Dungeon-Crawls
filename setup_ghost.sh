
---

## ✅ Fixed `setup_ghost.sh` (Hydra-consistent, minimal changes)

**Key fixes applied:**
- Correctly installs into the invoking student’s home directory
- Safe under `sudo`
- No reliance on `$HOME` resolving to `/root`
- No shell reload requirements

```bash
#!/bin/bash
# ======================================
# The Ghost Watch - Setup Script
# Teaches process monitoring and management
# ======================================

set -e
set -o pipefail

echo "👻 Initializing Ghost Watch dungeon..."

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

echo "🎯 Deploying Ghost Watch for user: $STUDENT_USER"
echo "🏠 Target home directory: $STUDENT_HOME"

# -------------------------------
# 1. Create dungeon directory
# -------------------------------
DUNGEON_DIR="$STUDENT_HOME/ghost_watch"

mkdir -p "$DUNGEON_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR"
cd "$DUNGEON_DIR"

# -------------------------------
# 2. Create persistent ghost script
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/ghost_watch.sh"
#!/bin/bash
# Ghost process endlessly sleeps
while true; do
    sleep 3600
done
EOF

chmod +x "$DUNGEON_DIR/ghost_watch.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/ghost_watch.sh"

# -------------------------------
# 3. Launch ghost as student
# -------------------------------
sudo -u "$STUDENT_USER" nohup "$DUNGEON_DIR/ghost_watch.sh" >/dev/null 2>&1 &

# -------------------------------
# 4. Create verification script
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/check_ghost.sh"
#!/bin/bash

echo "🔎 Verifying Ghost Watch completion..."
echo

if pgrep -f ghost_watch.sh >/dev/null; then
    echo "❌ The ghost still lingers."
    echo "   Silence it completely to finish the dungeon."
    exit 1
fi

echo "👻 The system is quiet."
echo "🏆 GHOST WATCH COMPLETE"
exit 0
EOF

chmod +x "$DUNGEON_DIR/check_ghost.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/check_ghost.sh"

# -------------------------------
# 5. Final instructions
# -------------------------------
cat << EOF

👻 GHOST WATCH READY

✔ Installed for user: $STUDENT_USER
✔ Dungeon located at: ~/ghost_watch
✔ Ghost process is active

To begin:
  cd ~/ghost_watch

To verify victory:
  ./check_ghost.sh

EOF
