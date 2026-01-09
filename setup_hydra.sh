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
# 3a. Persist PATH hijack for student
# -------------------------------
STUDENT_BASHRC="$STUDENT_HOME/.bashrc"
HYDRA_PATH_LINE='export PATH="$HOME/hydra_lair/bin:$PATH"'

touch "$STUDENT_BASHRC"
chown "$STUDENT_USER:$STUDENT_USER" "$STUDENT_BASHRC"

if ! grep -qxF "$HYDRA_PATH_LINE" "$STUDENT_BASHRC"; then
  echo "$HYDRA_PATH_LINE" >> "$STUDENT_BASHRC"
fi

# -------------------------------
# 3c. Ensure login shells source .bashrc
# -------------------------------
STUDENT_BASH_PROFILE="$STUDENT_HOME/.bash_profile"

touch "$STUDENT_BASH_PROFILE"
chown "$STUDENT_USER:$STUDENT_USER" "$STUDENT_BASH_PROFILE"

if ! grep -qxF '[[ -f ~/.bashrc ]] && source ~/.bashrc' "$STUDENT_BASH_PROFILE"; then
  echo '[[ -f ~/.bashrc ]] && source ~/.bashrc' >> "$STUDENT_BASH_PROFILE"
fi

# -------------------------------
# 3b. Persist HYDRA_KEY (shell-safe, login-safe)
# -------------------------------
HYDRA_PROFILE="/etc/profile.d/hydra.sh"

cat << 'EOF' > "$HYDRA_PROFILE"
export HYDRA_KEY=many_heads
EOF

chmod 644 "$HYDRA_PROFILE"



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
✔ HYDRA_KEY persisted via /etc/environment
✔ PATH hijack persisted via ~/.bashrc
✔ Hydra heads are running

IMPORTANT:
Open a NEW terminal to activate the environment.

To begin the hunt:
  cd ~/hydra_lair
  ls

EOF
