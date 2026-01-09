#!/bin/bash
# ==============================
# The Dragon Cron - Setup
# ==============================

echo "[+] Installing The Dragon Cron..."

# --- Persist Dragon environment key ---
echo 'export DRAGON_KEY="fiery_breath"' > /etc/profile.d/dragon_key.sh
chmod 644 /etc/profile.d/dragon_key.sh

# --- Create dungeon structure ---
mkdir -p ~/dragon_cron/{bin,clues,lair}

# --- Dragon background process ---
cat << 'EOF' > ~/dragon_cron/bin/dragon_cron.sh
#!/bin/bash
while true; do
    echo "The Dragon Cron smolders and watches..."
    sleep 60
done
EOF
chmod +x ~/dragon_cron/bin/dragon_cron.sh

# Start dragon process in the background
nohup ~/dragon_cron/bin/dragon_cron.sh >/dev/null 2>&1 &

# --- Clues ---
echo "CLUE 1: Discover the dragon’s key in your environment." > ~/dragon_cron/clues/start_here.txt
echo "CLUE 2: Use the key to slay the dragon." > ~/dragon_cron/clues/dragon_hint.txt

# --- Verification script ---
cat << 'EOF' > ~/dragon_cron/lair/check_dragon.sh
#!/bin/bash
# Dragon verification script

# Source key if not already present
if [[ -z "$DRAGON_KEY" ]]; then
    if [[ -f /etc/profile.d/dragon_key.sh ]]; then
        source /etc/profile.d/dragon_key.sh
    fi
fi

if [[ "$DRAGON_KEY" == "fiery_breath" ]]; then
    echo "🐉 Dragon slain! The key is correct."
else
    echo "❌ The dragon still breathes fire. Key missing or incorrect."
fi
EOF
chmod +x ~/dragon_cron/lair/check_dragon.sh

echo
echo "✅ Dragon Cron installed."
echo "➡ Open a new terminal OR run: source /etc/profile.d/dragon_key.sh"
echo "➡ Begin in: ~/dragon_cron"