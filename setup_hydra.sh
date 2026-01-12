#!/bin/bash
set -e
set -o pipefail

echo "🐍 Initializing Hydra dungeon (one-time setup)..."

# -------------------------------
# 0. Require sudo, capture real user
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

echo "🎯 Deploying Hydra for user: $STUDENT_USER"
echo "🏠 Target home directory: $STUDENT_HOME"

# -------------------------------
# 1. Create Hydra Lair
# -------------------------------
HYDRA_DIR="$STUDENT_HOME/hydra_lair"
BIN_DIR="$HYDRA_DIR/bin"
HEAD_DIR="$HYDRA_DIR/heads"

mkdir -p "$BIN_DIR" "$HEAD_DIR"
chown -R "$STUDENT_USER:$STUDENT_USER" "$HYDRA_DIR"

# -------------------------------
# 2. Create Hydra ls wrapper
# -------------------------------
cat << 'EOF' > "$BIN_DIR/ls"
#!/bin/bash

if [[ "$PWD" == "$HOME/hydra_lair"* ]] && [[ "$HYDRA_KEY" == "many_heads" ]]; then
  echo "⚠️ The Hydra watches every move..."
fi

/bin/ls "$@"
EOF

chmod +x "$BIN_DIR/ls"
chown "$STUDENT_USER:$STUDENT_USER" "$BIN_DIR/ls"

# -------------------------------
# 2.5 Create Completion Check Script (UPDATED)
# -------------------------------
CHECK_SCRIPT="$BIN_DIR/check_hydra.sh"

cat << 'EOF' > "$CHECK_SCRIPT"
#!/bin/bash

echo "🔎 Verifying dungeon completion..."
echo

FAIL=0

# 1. Environment must be clean
if printenv | grep -q HYDRA_KEY; then
  echo "❌ The Hydra still whispers through the environment."
  FAIL=1
fi

# 2. PATH must not be hijacked
echo "$PATH" | grep -q hydra_lair/bin
if [[ $? -eq 0 ]]; then
  echo "❌ The Hydra still controls your path."
  FAIL=1
fi

# 3. ls must be the system binary
LS_PATH="$(command -v ls)"
if [[ "$LS_PATH" != "/usr/bin/ls" && "$LS_PATH" != "/bin/ls" ]]; then
  echo "❌ Your sight is still warped. ls is not the system binary."
  FAIL=1
fi

# 4. No living heads
if pgrep -f hydra_head >/dev/null; then
  echo "❌ The Hydra still has living heads."
  FAIL=1
fi

# 5. Proof of victory
PROOF="$HOME/hydra_lair/heads/hydra_defeated"
if [[ ! -f "$PROOF" ]]; then
  echo "❌ No proof of victory found."
  FAIL=1
fi

if [[ "$FAIL" -eq 1 ]]; then
  echo
  echo "⚠️ FALSE VICTORY DETECTED"
  echo "The Hydra retreats... but is not defeated."
  exit 1
fi

echo
echo "🐉 THE HYDRA HAS FALLEN"
echo "✔ Environment repaired"
echo "✔ Trust restored"
echo "✔ Heads destroyed"
echo
echo "🏆 CONGRATULATIONS"
exit 0
EOF

chmod +x "$CHECK_SCRIPT"
chown "$STUDENT_USER:$STUDENT_USER" "$CHECK_SCRIPT"

# -------------------------------
# 2.6 Create Hidden Lore / Hint File
# -------------------------------
MANUSCRIPT="$HYDRA_DIR/.strange_manuscript"

cat << 'EOF' > "$MANUSCRIPT"
The parchment is old. The ink has faded.

"Many who face the Hydra strike at its heads.
Fools. Heads grow back."

"The beast does not live in muscle or bone,
but in whispers passed from shell to shell."

"What you type is not always what you run.
What you run is not always what you trust."

"When the lair forgets the Hydra's name,
only then does the silence last."
EOF

chown "$STUDENT_USER:$STUDENT_USER" "$MANUSCRIPT"
chmod 600 "$MANUSCRIPT"

# -------------------------------
# 3. Persist environment for Kali (zsh)
# -------------------------------
STUDENT_ZSHRC="$STUDENT_HOME/.zshrc"

touch "$STUDENT_ZSHRC"
chown "$STUDENT_USER:$STUDENT_USER" "$STUDENT_ZSHRC"

sed -i '/hydra_lair\/bin/d' "$STUDENT_ZSHRC"
sed -i '/HYDRA_KEY/d' "$STUDENT_ZSHRC"
sed -i '/Hydra dungeon/d' "$STUDENT_ZSHRC"
sed -i '/unalias ls/d' "$STUDENT_ZSHRC"

cat << 'EOF' >> "$STUDENT_ZSHRC"

# --- Hydra dungeon ---
export HYDRA_KEY=many_heads

unalias ls 2>/dev/null

typeset -U path
path=("$HOME/hydra_lair/bin" $path)

ls() {
  "$HOME/hydra_lair/bin/ls" "$@"
}
# --------------------
EOF

# -------------------------------
# 4. Create Hydra Head Script
# -------------------------------
cat << 'EOF' > "$HEAD_DIR/hydra_head.sh"
#!/bin/bash
exec -a hydra_head sleep 1000000
EOF

chmod +x "$HEAD_DIR/hydra_head.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$HEAD_DIR/hydra_head.sh"

# -------------------------------
# 5. Spawn Hydra Heads
# -------------------------------
for i in 1 2 3; do
  sudo -u "$STUDENT_USER" nohup "$HEAD_DIR/hydra_head.sh" >/dev/null 2>&1 &
done

# -------------------------------
# 6. Final Message
# -------------------------------
cat << EOF

🐍 HYDRA INSTALLATION COMPLETE

✔ Installed for user: $STUDENT_USER
✔ Hydra lair created at: ~/hydra_lair
✔ Dungeon integrity checks updated
✔ Strange manuscript discovered
✔ Hydra heads are running

IMPORTANT (one-time):
  exec zsh

To begin the hunt:
  cd ~/hydra_lair
  ls

To verify final victory:
  check_hydra.sh

EOF
