#!/bin/bash
# ======================================
# Ghost Watch - Level 3
# Teaches process inspection, identity, and signals
# ======================================

set -e
set -o pipefail

echo "👻 Initializing The Ghost Watch REV9.FINAL"

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
# 1. Create dungeon
# -------------------------------
DUNGEON_DIR="$STUDENT_HOME/ghost_watch"
mkdir -p "$DUNGEON_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR"
cd "$DUNGEON_DIR"

# -------------------------------
# 2. Create ghost script (signal-resistant)
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/ghost_core.sh"
#!/bin/bash

# Ignore polite termination
trap '' SIGTERM

while true; do
  sleep 3600
done
EOF

chmod +x "$DUNGEON_DIR/ghost_core.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/ghost_core.sh"

# -------------------------------
# 3. Launch ghost with false identity
# -------------------------------
sudo -u "$STUDENT_USER" nohup bash -c \
  'exec -a wandering_spirit ~/ghost_watch/ghost_core.sh' \
  >/dev/null 2>&1 &

# -------------------------------
# 4. Verification script
# -------------------------------
cat << 'EOF' > "$DUNGEON_DIR/check_ghost.sh"
#!/bin/bash

echo "🔎 Verifying Ghost Watch completion..."
echo

FAIL=0

# Ghost must be fully gone
if pgrep -f wandering_spirit >/dev/null; then
  echo "❌ A spirit still wanders the system."
  FAIL=1
fi

# Ensure no orphaned core remains
if pgrep -f ghost_core.sh >/dev/null; then
  echo "❌ The ghost's heart still beats."
  FAIL=1
fi

if [[ "$FAIL" -eq 1 ]]; then
  echo
  echo "⚠️ THE LAIR IS NOT QUIET"
  echo "Look deeper. Names deceive."
  exit 1
fi

echo
echo "👻 The lair is silent."
echo "✔ Process truth uncovered"
echo "✔ Signals understood"
echo
echo "🏆 GHOST WATCH COMPLETE"
exit 0
EOF

chmod +x "$DUNGEON_DIR/check_ghost.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR/check_ghost.sh"

# -------------------------------
# 5. Hidden chest with hints
# -------------------------------
HIDDEN_DIR="$DUNGEON_DIR/.chest"
HIDDEN_FILE="$HIDDEN_DIR/.strange_manuscript"

mkdir -p "$HIDDEN_DIR"
chown "$STUDENT_USER:$STUDENT_USER" "$HIDDEN_DIR"

cat << 'EOF' > "$HIDDEN_FILE"
You uncover a thin, brittle page sealed away from sight:

"Some spirits wear borrowed names.
Read not only what runs, but how it runs."

"A polite request is sometimes ignored.
There are louder ways to speak."

"What you kill is not always what you see.
Look at the full command, not the mask."

"Processes have parents.
Orphans tell stories."

"When the lair is truly quiet,
no name, true or false, will answer your call."
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
✔ A wandering spirit roams unseen

To begin:
  cd ~/ghost_watch

To verify victory:
  ./check_ghost.sh

Some names lie.
Some signals whisper.
Only silence tells the truth.

EOF
