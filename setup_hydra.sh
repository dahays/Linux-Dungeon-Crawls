#!/bin/bash
# ===============================
# The Hydra Head Hunt - Setup
# Context-Aware + Key Fix
# ===============================

set -e

echo "[*] Setting up The Hydra Head Hunt..."

# -------------------------------
# 1. Create dungeon directory
# -------------------------------
mkdir -p "$HOME/hydra_lair"
cd "$HOME/hydra_lair"

# -------------------------------
# 2. Create Hydra PATH hijack
# -------------------------------
mkdir -p "$HOME/.hydra_bin"

cat << 'EOF' > "$HOME/.hydra_bin/ls"
#!/bin/bash

# Hydra only watches inside its lair
if [[ "$PWD" == "$HOME/hydra_lair"* && "$HYDRA_KEY" == "many_heads" ]]; then
    echo "⚠️ The Hydra watches every move..."
fi

# Execute the real ls
/bin/ls "$@"
EOF

chmod +x "$HOME/.hydra_bin/ls"

# -------------------------------
# 3. Ensure PATH injection
# -------------------------------
if ! grep -q 'hydra_bin' "$HOME/.bashrc"; then
    cat << 'EOF' >> "$HOME/.bashrc"

# --- Hydra PATH Injection ---
export PATH="$HOME/.hydra_bin:$PATH"
EOF
fi

# Apply immediately
export PATH="$HOME/.hydra_bin:$PATH"

# -------------------------------
# 4. GUARANTEED HYDRA KEY FIX
# -------------------------------

# Persist the key
if ! grep -q 'HYDRA_KEY=' "$HOME/.bashrc"; then
    echo 'export HYDRA_KEY="many_heads"' >> "$HOME/.bashrc"
fi

# Apply immediately (this is the critical part)
export HYDRA_KEY="many_heads"

# -------------------------------
# 5. Create verification script
# -------------------------------
cat << 'EOF' > "$HOME/hydra_lair/check_hydra.sh"
#!/bin/bash

echo "=== Hydra Verification ==="

if [[ "$HYDRA_KEY" != "many_heads" ]]; then
    echo "❌ HYDRA_KEY not set in environment"
    exit 1
fi

if [[ "$(which ls)" != "$HOME/.hydra_bin/ls" ]]; then
    echo "❌ Hydra ls is not active in PATH"
    exit 1
fi

if [[ "$PWD" != "$HOME/hydra_lair"* ]]; then
    echo "⚠️ Not inside the Hydra lair"
    echo "   cd ~/hydra_lair and retry"
    exit 1
fi

echo "✅ HYDRA_KEY detected"
echo "✅ Hydra behavior active in lair"
echo "🏆 Hydra Head Hunt completed!"
EOF

chmod +x "$HOME/hydra_lair/check_hydra.sh"

# -------------------------------
# 6. Final instructions
# -------------------------------
echo
echo "🐍 The Hydra stirs only within its lair."
echo
echo "IMPORTANT:"
echo "Open a NEW terminal or run:"
echo "  source ~/.bashrc"
echo
echo "Then:"
echo "  cd ~/hydra_lair"
echo "  ls"
echo
echo "Verify completion with:"
echo "  ./check_hydra.sh"
echo
echo "[*] Setup complete."
