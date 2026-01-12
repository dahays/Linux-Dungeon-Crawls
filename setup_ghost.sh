#!/bin/bash
# ======================================
# The Ghost Watch - Setup Script
# Teaches process monitoring, management, and hidden discovery
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
# 5. Create hidden chest with strange_manuscript
# -------------------------------
HIDDEN_DIR="$DUNGEON_DIR/.chest"
HIDDEN_FILE="$HIDDEN_DIR/.strange_manuscript"

mkdir -p "$HIDDEN_DIR"
chown "$STUDENT_USER:$STUDENT_USER" "$HIDDEN_DIR"

cat << 'EOF' > "$HIDDEN_FILE"
You find a worn, dust-covered scroll hidden in the shadows of the lair. It whispers:

"Not all watchers are seen. Some linger silently in the background.
Seek them where the ps command shines its light."

"A ghost leaves no footprints in plain view.
Sometimes the path is only revealed by pgrep and careful observation."

"Kill the unseen gently; let pkill or kill answer your call.
Only one command ends what the eye cannot follow."

"Files may hide in plain sight, yet a leading dot conceals their presence.
What is hidden is not always absent."

"Verification waits at the edge of the lair.
Run your scripts, read their signs, and the silence will speak."

"The ghost may sleep, but it listens to your keystrokes.
A nohup or & might have set it free."

"Check your home, check your tools, check the state of what is running.
Only when the ghost is gone does the dungeon acknowledge your victory."
EOF

chmod 600 "$HIDDEN_FILE"
chown "$STUDENT_USER:$STUDENT_USER" "$HIDDEN_FILE"

# -------------------------------
# 6. Final instructions
# -------------------------------
cat << EOF

👻 GHOST WATCH READY

✔ Installed for user: $STUDENT_USER
✔ Dungeon located at: ~/ghost_watch
✔ Ghost process is active
✔ Hidden chest containing a strange manuscript created

To begin:
  cd ~/ghost_watch

To verify victory:
  ./check_ghost.sh

Scratched into the wall you see an odd message:
"Some secrets hide in plain sight. Not all treasures are in the open."

EOF
