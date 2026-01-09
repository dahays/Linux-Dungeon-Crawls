#!/bin/bash
# ===============================
# The Hydra Head Hunt - Setup
# Context-Aware Version
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

# Call the real ls
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

# Apply immediately
export PATH="$HOME/.hydra_bin:$PATH"

# -------------------------------
# 4. Create Hydra environment variable
# -------------------------------
cat << 'EOF' > "$HOME/.hydra_env"
export HYDRA_KEY="many_heads"
EOF

# Load now
source "$HOME/.hydra_env"

# Persist for future shells
if ! grep -q "hydra_env" "$HOME/.bashrc"; then
    echo 'source "$HOME/.hydra_env"' >> "$HOME/.bashrc"
fi

# -------------------------------
# 5. Create verification script
# -------------------------------
cat << 'EOF' > "$HOME/hydra_lair/check_hydra.sh"
#!/bin/bash

echo "=== Hydra Verification ==="

if [[ "$HYDRA_KEY" != "many_heads" ]]; then
    echo "❌ HYDRA_KEY not set"
    exit 1
fi

if [[ "$(which ls)" != "$HOME/.hydra_bin/ls" ]]; then
    echo "❌ Hydra ls not active"
    exit 1
fi

if [[ "$PWD" != "$HOME/hydra_lair"* ]]; then
    echo "⚠️ You are not inside the Hydra lair"
    echo "   cd ~/hydra_lair and try again"
    exit 1
fi

echo "✅ HYDRA_KEY detected"
echo "✅ Hydra watches this location"
echo "🏆 Hydra Head Hunt completed!"
EOF

chmod +x "$HOME/hydra_lair/check_hydra.sh"

# -------------------------------
# 6. Final instructions
# -------------------------------
echo
echo "🐍 The Hydra sleeps outside its lair."
echo "Enter it to awaken the beast:"
echo "  cd ~/hydra_lair"
echo "  ls"
echo
echo "Leave the lair to escape:"
echo "  cd .."
echo
echo "Verify completion with:"
echo "  ./check_hydra.sh"
echo
echo "[*] Setup complete."
