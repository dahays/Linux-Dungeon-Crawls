#!/bin/bash
# ==============================
# The Hydra Head Hunt - Setup
# ==============================

echo "[+] Installing The Hydra Head Hunt..."

# --- Persist Hydra environment key ---
echo 'export HYDRA_KEY="many_heads"' > /etc/profile.d/hydra_key.sh
chmod 644 /etc/profile.d/hydra_key.sh

# --- Create dungeon structure ---
mkdir -p ~/hydra_head/{bin,clues,lair}

# --- Hydra background process ---
cat << 'EOF' > ~/hydra_head/bin/hydra_head.sh
#!/bin/bash
while true; do
    echo "The Hydra stirs... cut one head and two more grow."
    sleep 30
done
EOF
chmod +x ~/hydra_head/bin/hydra_head.sh

# Start Hydra process in background
nohup ~/hydra_head/bin/hydra_head.sh >/dev/null 2>&1 &

# --- Clues ---
echo "CLUE 1: This beast is bound to your environment." > ~/hydra_head/clues/start_here.txt
echo "CLUE 2: Seek the Hydra's name among exported variables." > ~/hydra_head/clues/hydra_hint.txt

# --- Verification script ---
cat << 'EOF' > ~/hydra_head/lair/check_hydra.sh
#!/bin/bash
# Hydra verification script

# Source key if not already present
if [[ -z "$HYDRA_KEY" ]]; then
    if [[ -f /etc/profile.d/hydra_key.sh ]]; then
        source /etc/profile.d/hydra_key.sh
    fi
fi

if [[ "$HYDRA_KEY" == "many_heads" ]]; then
    echo "🐍 Hydra defeated! The key is correct."
else
    echo "❌ Hydra still lives. The key is missing or incorrect."
fi
EOF
chmod +x ~/hydra_head/lair/check_hydra.sh

echo
echo "✅ Hydra Head Hunt installed."
echo "➡ Open a new terminal OR run: source /etc/profile.d/hydra_key.sh"
echo "➡ Begin in: ~/hydra_head"