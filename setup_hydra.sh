#!/bin/bash
# ======================================
# The Hydra Head Hunt - Final Setup
# Context-aware, no environment variables
# ======================================

set -e

echo "[*] Setting up The Hydra Head Hunt..."

# --------------------------------------
# 1. Create the Hydra lair
# --------------------------------------
mkdir -p "$HOME/hydra_lair"
cd "$HOME/hydra_lair"

# --------------------------------------
# 2. Create Hydra-controlled ls
# --------------------------------------
mkdir -p "$HOME/.hydra_bin"

cat << 'EOF' > "$HOME/.hydra_bin/ls"
#!/bin/bash

# Hydra only watches inside its lair
if [[ "$PWD" == "$HOME/hydra_lair"* ]]; then
    echo "⚠️ The Hydra watches every move..."
fi

# Execute the real ls
/bin/ls "$@"
EOF

chmod +x "$HOME/.hydra_bin/ls"

# --------------------------------------
# 3. Inject Hydra into PATH
# --------------------------------------
if ! grep -q "hydra_bin" "$HOME/.bashrc"; then
    cat << 'EOF' >> "$HOME/.bashrc"

# --- Hydra PATH Injection ---
export PATH="$HOME/.hydra_bin:$PATH"
EOF
fi

# Apply immediately for this shell
export PATH="$HOME/.hydra_bin:$PATH"

# --------------------------------------
# 4. Create verification script
# --------------------------------------
cat << 'EOF' > "$HOME/hydra_lair/check_hydra.sh"
#!/bin/bash

echo "=== Hydra Verification ==="

if [[ "$(which ls)" != "$HOME/.hydra_bin/ls" ]]; then
    echo "❌ Hydra ls is not active"
    exit 1
fi

if [[ "$PWD" != "$HOME/hydra_lair"* ]]; then
    echo "⚠️ You are not inside the Hydra lair"
    echo "   cd ~/hydra_lair and try again"
    exit 1
fi

echo "✅ Hydra is watching this directory"
echo "🏆 Hydra Head Hunt completed!"
EOF

chmod +x "$HOME/hydra_lair/check_hydra.sh"

# --------------------------------------
# 5. Final instructions
# --------------------------------------
echo
echo "🐍 The Hydra guards only its lair."
echo
echo "Open a NEW terminal or run:"
echo "  source ~/.bashrc"
echo
echo "Then enter the lair:"
echo "  cd ~/hydra_lair"
echo "  ls"
echo
echo "Escape the lair with:"
echo "  cd .."
echo
echo "Verify completion with:"
echo "  ./check_hydra.sh"
echo
echo "[*] Setup complete."
