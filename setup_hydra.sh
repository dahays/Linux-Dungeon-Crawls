#!/bin/bash
set -e
set -o pipefail

echo "🐍 Initializing Hydra dungeon (one-time setup)..."

# -------------------------------
# 0. Require sudo, capture real user
# -------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 This installer must be run with sudo."
  echo "   Example: sudo ./setup_hydra.sh"
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
# 1. Create Hydra Lair (user-owned)
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
# 2.5 Create Hydra Completion Check Script
# -------------------------------
CHECK_SCRIPT="$BIN_DIR/check_hydra.sh"

cat << 'EOF' > "$CHECK_SCRIPT"
#!/bin/bash

echo "🔎 Verifying dungeon completion..."
echo

# 1. Verify environment key
if [[ "$HYDRA_KEY" != "many_heads" ]]; then
  echo "❌ The Hydra still hides its true name."
  exit 1
fi

# 2. Verify correct location
if [[ "$PWD" != "$HOME/hydra_lair"* ]]; then
  echo "❌ You are not within the Hydra lair."
  exit 1
fi

# 3. Verify Hydra heads are defeated
if pgrep -f hydra_head >/dev/null; then
  echo "❌ The Hydra still has living heads."
  echo "   A true victory leaves none breathing."
  exit 1
fi

# 4. Verify proof of defeat
PROOF_FILE="$HOME/hydra_lair/heads/hydra_defeated"

if [[ ! -f "$PROOF_FILE" ]]; then
  echo "❌ No proof of victory found."
  echo "   Legends leave evidence behind."
  exit 1
fi

echo "🐉 THE HYDRA HAS FALLEN"
echo
echo "✔ Environment understood"
echo "✔ Heads destroyed"
echo "✔ Proof secured"
echo
echo "🏆 CONGRATULATIONS"
echo "You have completed the Hydra dungeon."
exit 0
EOF

chmod +x "$CHECK_SCRIPT"
chown "$STUDENT_USER:$STUDENT_USER" "$CHECK_SCRIPT"

# -------------------------------
# 3. Persist environment for Kali (zsh)
# -------------------------------
STUDENT_ZSHRC="$STUDENT_HOME/.zshrc"

touch "$STUDENT_ZSHRC"
chown "$STUDENT_USER:$STUDENT_USER" "$STUDENT_ZSHRC"

# Remove any previous Hydra entries to keep this idempotent
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
# 3.5 Ensure Hydra loads last on Kali zsh
# -------------------------------
ZSH_HYDRA_CONF="/etc/zsh/zshrc.d/99-hydra.conf"

cat << EOF > "$ZSH_HYDRA_CONF"
# Hydra dungeon (forced final load)

if [[ -f "$STUDENT_HOME/.zshrc" ]]; then
  source "$STUDENT_HOME/.zshrc"
fi
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
# 5. Spawn Hydra Heads as student
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
✔ HYDRA_KEY persisted via ~/.zshrc
✔ PATH hijack persisted via ~/.zshrc
✔ Hydra heads are running
✔ Dungeon completion check installed

IMPORTANT:
Close this terminal and open a NEW one.

To begin the hunt:
  FINAL SETUP STEP:
  exec zsh (one time only):

  cd ~/hydra_lair
  ls

To verify final victory:
  /hydra_lair/bin/check_hydra.sh

EOF
