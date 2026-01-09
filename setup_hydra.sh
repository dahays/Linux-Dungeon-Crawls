#!/bin/bash
set -e

echo "🐍 Summoning the Hydra..."

# -------------------------------
# 1. Create Hydra Lair
# -------------------------------
HYDRA_DIR="$HOME/hydra_lair"
BIN_DIR="$HYDRA_DIR/bin"
HEAD_DIR="$HYDRA_DIR/heads"

mkdir -p "$BIN_DIR" "$HEAD_DIR"

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

# -------------------------------
# 3. Persist Environment for User
# -------------------------------
HYDRA_ENV_LINE='export HYDRA_KEY=many_heads'
HYDRA_PATH_LINE='export PATH="$HOME/hydra_lair/bin:$PATH"'

grep -qxF "$HYDRA_ENV_LINE" "$HOME/.bashrc" || echo "$HYDRA_ENV_LINE" >> "$HOME/.bashrc"
grep -qxF "$HYDRA_PATH_LINE" "$HOME/.bashrc" || echo "$HYDRA_PATH_LINE" >> "$HOME/.bashrc"

# -------------------------------
# 4. Activate Environment IF Script Is Sourced
# -------------------------------
if [[ "${BASH_SOURCE[0]}" != "$0" ]]; then
  export HYDRA_KEY=many_heads
  export PATH="$HOME/hydra_lair/bin:$PATH"
  hash -r
  HYDRA_ACTIVE_NOW=true
else
  HYDRA_ACTIVE_NOW=false
fi

# -------------------------------
# 5. Create Hydra Head Script
# -------------------------------
cat << 'EOF' > "$HEAD_DIR/hydra_head.sh"
#!/bin/bash
exec -a hydra_head sleep 1000000
EOF

chmod +x "$HEAD_DIR/hydra_head.sh"

# -------------------------------
# 6. Spawn Multiple Hydra Heads
# -------------------------------
for i in 1 2 3; do
  nohup "$HEAD_DIR/hydra_head.sh" >/dev/null 2>&1 &
done

# -------------------------------
# 7. Student Instructions
# -------------------------------
cat << EOF

🐍 HYDRA DEPLOYED SUCCESSFULLY

Student-facing facts:
• Multiple Hydra heads are running
• HYDRA_KEY is persisted in ~/.bashrc
• PATH is conditionally hijacked via ~/hydra_lair/bin

To begin the hunt:
  cd ~/hydra_lair
  ls

EOF

# -------------------------------
# 8. Environment Activation Notice
# -------------------------------
if [[ "$HYDRA_ACTIVE_NOW" == "false" ]]; then
  cat << EOF
⚠️ The Hydra sleeps in this shell.

To awaken it, run ONE of the following:
  source ~/.bashrc
  OR
  open a new terminal

(Advanced hunters may rerun this script using: source ./setup_hydra.sh)
EOF
else
  echo "🐍 The Hydra is awake in this shell."
fi
