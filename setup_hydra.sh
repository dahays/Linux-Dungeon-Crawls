#!/bin/bash
set -e

echo "🐍 Forging the Hydra..."

# --- Resolve target user & home safely (works with sudo) ---
TARGET_USER="${SUDO_USER:-$USER}"
TARGET_HOME="$(eval echo "~$TARGET_USER")"

# --- Base directories ---
HYDRA_DIR="$TARGET_HOME/hydra_lair"
BIN_DIR="$TARGET_HOME/.hydra_bin"
HYDRA_ENV="$TARGET_HOME/.hydra_env"
BASHRC="$TARGET_HOME/.bashrc"

mkdir -p "$HYDRA_DIR"
mkdir -p "$BIN_DIR"

# --- Hydra Key (local, persistent, student-owned) ---
echo 'export HYDRA_KEY=many_heads' > "$HYDRA_ENV"

# Ensure it loads for interactive shells
if ! grep -q hydra_env "$BASHRC"; then
  echo 'source "$HOME/.hydra_env"' >> "$BASHRC"
fi

# Load immediately for current shell if possible
if [[ "$USER" == "$TARGET_USER" ]]; then
  source "$HYDRA_ENV"
fi

# --- PATH hijacked ls (scoped to hydra_lair) ---
cat << 'EOF' > "$BIN_DIR/ls"
#!/bin/bash

if [[ "$PWD" == *"hydra_lair"* ]] && [[ "$HYDRA_KEY" == "many_heads" ]]; then
  echo "⚠️ The Hydra watches every move..."
fi

/bin/ls "$@"
EOF

chmod +x "$BIN_DIR/ls"

# Prepend Hydra bin to PATH (idempotent)
if ! grep -q hydra_bin "$BASHRC"; then
  echo 'export PATH="$HOME/.hydra_bin:$PATH"' >> "$BASHRC"
fi

# --- Spawn MULTIPLE Hydra Heads (correctly) ---
echo "🐍 Releasing the Hydra heads..."

for head in deckhand lookout navigator; do
  (
    exec -a hydra_head sleep 9999
  ) &
done

# --- Verification script ---
cat << 'EOF' > "$HYDRA_DIR/check_hydra.sh"
#!/bin/bash

echo "=== Hydra Verification ==="

if pgrep -f hydra_head > /dev/null; then
  echo "❌ The Hydra still lives."
  exit 1
fi

if [[ "$HYDRA_KEY" != "many_heads" ]]; then
  echo "❌ The Hydra Key is missing."
  exit 1
fi

echo "✅ All Hydra heads defeated"
echo "🏆 The Hydra has fallen. The harbor is safe."
EOF

chmod +x "$HYDRA_DIR/check_hydra.sh"
chown "$TARGET_USER":"$TARGET_USER" "$HYDRA_DIR/check_hydra.sh"

# --- Final instructions ---
echo
echo "🐍 Hydra Head Hunt installed successfully."
echo "➡️ Open a NEW terminal or run: source ~/.bashrc"
echo "➡️ Then: cd ~/hydra_lair"
echo "➡️ Begin the hunt."
