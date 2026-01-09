#!/bin/bash
set -e

echo "🐍 Forging the Hydra..."

# --- Base directory ---
HYDRA_DIR="$HOME/hydra_lair"
BIN_DIR="$HOME/.hydra_bin"

mkdir -p "$HYDRA_DIR"
mkdir -p "$BIN_DIR"

# --- Hydra Key (safe, local, persistent) ---
HYDRA_ENV="$HOME/.hydra_env"
echo 'export HYDRA_KEY=many_heads' > "$HYDRA_ENV"

# Ensure it loads for interactive shells
if ! grep -q hydra_env "$HOME/.bashrc"; then
  echo 'source "$HOME/.hydra_env"' >> "$HOME/.bashrc"
fi

# Load immediately for current shell
source "$HYDRA_ENV"

# --- PATH hijacked ls (scoped by directory) ---
cat << 'EOF' > "$BIN_DIR/ls"
#!/bin/bash

if [[ "$PWD" == *"hydra_lair"* ]] && [[ "$HYDRA_KEY" == "many_heads" ]]; then
  echo "⚠️ The Hydra watches every move..."
fi

/bin/ls "$@"
EOF

chmod +x "$BIN_DIR/ls"

# Prepend Hydra bin to PATH safely
if ! grep -q hydra_bin "$HOME/.bashrc"; then
  echo 'export PATH="$HOME/.hydra_bin:$PATH"' >> "$HOME/.bashrc"
fi

export PATH="$BIN_DIR:$PATH"

# --- Spawn Hydra Heads (MULTIPLE, CORRECTLY) ---
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

# --- Finish ---
echo
echo "🐍 Hydra Head Hunt installed."
echo "➡️ Open a NEW terminal or run: source ~/.bashrc"
echo "➡️ Then: cd ~/hydra_lair"
echo "➡️ Begin the hunt."