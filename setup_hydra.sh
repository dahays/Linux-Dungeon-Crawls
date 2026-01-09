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

if [[ "$PWD" == *"hydra_lair"* ]] && [[ "$HYDRA_KEY" == "many_heads" ]]; then
  echo "⚠️ The Hydra watches every move..."
fi

/bin/ls "$@"
EOF

chmod +x "$BIN_DIR/ls"

# -------------------------------
# 3. Export PATH locally (student shell safe)
# -------------------------------
ENV_FILE="$HOME/.hydra_env"

cat << EOF > "$ENV_FILE"
export HYDRA_KEY=many_heads
export PATH="$BIN_DIR:\$PATH"
EOF

# Load immediately for the current shell
source "$ENV_FILE"

# -------------------------------
# 4. Create Hydra Head Script
# -------------------------------
cat << 'EOF' > "$HEAD_DIR/hydra_head.sh"
#!/bin/bash
exec -a hydra_head sleep 1000000
EOF

chmod +x "$HEAD_DIR/hydra_head.sh"

# -------------------------------
# 5. Spawn Multiple Hydra Heads
# -------------------------------
for i in 1 2 3; do
  nohup "$HEAD_DIR/hydra_head.sh" >/dev/null 2>&1 &
done

# -------------------------------
# 6. Student Instructions
# -------------------------------
cat << EOF

🐍 HYDRA DEPLOYED SUCCESSFULLY

Student-facing facts:
• Multiple Hydra heads are running
• HYDRA_KEY exists in the environment
• PATH is hijacked inside hydra_lair only

To begin the hunt:
  cd ~/hydra_lair
  ls

EOF
