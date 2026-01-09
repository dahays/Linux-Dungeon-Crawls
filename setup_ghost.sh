#!/bin/bash
# ==============================
# The Ghost Watch - Setup
# ==============================

echo "[+] Installing The Ghost Watch..."

# --- Persist Ghost environment key ---
echo 'export GHOST_KEY="phantom_energy"' > /etc/profile.d/ghost_key.sh
chmod 644 /etc/profile.d/ghost_key.sh

# --- Create dungeon structure ---
mkdir -p ~/ghost_watch/{bin,clues,lair}

# --- Ghost process ---
cat << 'EOF' > ~/ghost_watch/bin/ghost_watch.sh
#!/bin/bash
while true; do
    echo "A ghostly presence lingers..."
    sleep 45
done
EOF
chmod +x ~/ghost_watch/bin/ghost_watch.sh

# Start ghost process in background
nohup ~/ghost_watch/bin/ghost_watch.sh >/dev/null 2>&1 &

# --- Clues ---
echo "CLUE 1: Some spirits hide in the environment itself." > ~/ghost_watch/clues/start_here.txt
echo "CLUE 2: Reveal the ghost's name to banish it." > ~/ghost_watch/clues/ghost_hint.txt

# --- Verification script ---
cat << 'EOF' > ~/ghost_watch/lair/check_ghost.sh
#!/bin/bash
# Ghost verification script

# Source key if not already present
if [[ -z "$GHOST_KEY" ]]; then
    if [[ -f /etc/profile.d/ghost_key.sh ]]; then
        source /etc/profile.d/ghost_key.sh
    fi
fi

if [[ "$GHOST_KEY" == "phantom_energy" ]]; then
    echo "👻 Ghost banished! The key is correct."
else
    echo "❌ Ghost still haunts the system. Key missing or incorrect."
fi
EOF
chmod +x ~/ghost_watch/lair/check_ghost.sh

echo
echo "✅ Ghost Watch installed."
echo "➡ Open a new terminal OR run: source /etc/profile.d/ghost_key.sh"
echo "➡ Begin in: ~/ghost_watch"