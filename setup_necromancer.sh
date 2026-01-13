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
# 4. Create encrypted hint
# -------------------------------
PLAINTEXT_HINT="$DUNGEON_DIR/.necromancer_scroll"
ENCRYPTED_HINT="$DUNGEON_DIR/.necromancer_scroll.gpg"
GNUPG_HOME="$DUNGEON_DIR/.gnupg"

mkdir -p "$GNUPG_HOME"
chown -R "$STUDENT_USER:$STUDENT_USER" "$GNUPG_HOME"
chmod 700 "$GNUPG_HOME"

cat << 'EOF' > "$PLAINTEXT_HINT"
The ghost is not the source.
Watch what breathes life into it.

Processes are born of parents.
Silence comes only when the chanter stops.

Seek the tree, not the leaf.
EOF

sudo -u "$STUDENT_USER" \
  GNUPGHOME="$GNUPG_HOME" \
  gpg --batch --yes --quiet --no-tty \
  --pinentry-mode loopback \
  --passphrase "ritual" \
  --symmetric "$PLAINTEXT_HINT" \
  -o "$ENCRYPTED_HINT"

rm "$PLAINTEXT_HINT"

chown "$STUDENT_USER:$STUDENT_USER" "$ENCRYPTED_HINT"
chmod 600 "$ENCRYPTED_HINT"

# -------------------------------
# 5. Create strange manuscript
# -------------------------------
MANUSCRIPT="$DUNGEON_DIR/.strange_manuscript"

cat << 'EOF' > "$MANUSCRIPT"
there once was a watcher so Rare
who lingered unseen in the aIr
to seek out the True path
avoid what is Unclean
perform Acts that endure Long
EOF

chown "$STUDENT_USER:$STUDENT_USER" "$MANUSCRIPT"
chmod 600 "$MANUSCRIPT"

# -------------------------------
# 6. Launch necromancer as student
# Properly detached, single PID process
sudo -u "$STUDENT_USER" bash -c "nohup '$DUNGEON_DIR/necromancer.sh' >/dev/null 2>&1 & disown"

# -------------------------------
# 7. Create verification script
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
# 8. Final instructions
# -------------------------------
cat << EOF

🕯️ GHOST WATCH II: THE NECROMANCER READY

✔ Installed for user: $STUDENT_USER
✔ Dungeon location: ~/ghost_necromancer
✔ Necromancer process is active

You sense forgotten words etched into the lair.
Some truths hide behind silence.
Others wait to be spoken correctly.

To begin:
  cd ~/ghost_necromancer

To verify victory:
  ./check_necromancer.sh

EOF
