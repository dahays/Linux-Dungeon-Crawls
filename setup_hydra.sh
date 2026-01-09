#!/bin/bash
# ===============================
# The Hydra Head Hunt - Setup
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

# Hydra watches only if the key exists
if [[ "$HYDRA_KEY" == "many_heads" ]]; then
    echo "⚠️ The Hydra watches every move..."
fi

# Execute the real ls
/bin/ls "$@"
EOF

chmod +x "$HOME/.hydra_bin/ls"

# -------------------------------
# 3. Persist PATH modification
# -------------------------------
if ! grep -q "hydra_bin" "$HOME/.bashrc"; then
    cat << 'EOF' >> "$HOME/.bashrc"

# --- Hydra PATH Injection ---
if [[ -d "$HOME/.hydra_bin" ]]; then
    export PATH="$HOME/.hydra_bin:$PATH"
fi
EOF
fi

# Apply immediately for this shell
export PATH="$HOME/.hydra_bin:$PATH"

# -------------------------------
# 4. Create Hydra environment file
# -------------------------------
cat << 'EOF' > "$HOME/.hydra_env"
export HYDRA_KEY="many_heads"
EOF

# Load it now
source "$HOME/.hydra_env"

# Ensure it loads in future shells
if ! grep -q "hydra_env" "$HOME/.bashrc"; then
    echo 'source "$HOME/.hydra_env"' >> "$HOME/.bashrc"
fi

# -------------------------------
# 5. Create victory check script
# -------------------------------
cat << 'EOF' > "$HOME/hydra_lair/check_hydra.sh"
#!/bin/bash

echo "=== Hydra Verification ==="

if [[ "$HYDRA_KEY" != "many_heads" ]]; then
    echo "❌ HYDRA_KEY is missing or incorrect"
    exit 1
fi

if [[ "$(which ls)" != "$HOME/.hydra_bin/ls" ]]; then
    echo "❌ Hydra ls is not active"
    exit 1
fi

echo "✅ HYDRA_KEY detected"
echo "✅ Hydra is watching ls"
echo "🏆 Hydra Head Hunt completed!"
EOF

chmod +x "$HOME/hydra_lair/check_hydra.sh"

# -------------------------------
# 6. Final message
# -------------------------------
echo
echo "🐍 The Hydra stirs..."
echo "Open a NEW terminal, then run:"
echo "  cd ~/hydra_lair"
echo "  ls"
echo
echo "When finished, verify with:"
echo "  ./check_hydra.sh"
echo
echo "[*] Setup complete."
