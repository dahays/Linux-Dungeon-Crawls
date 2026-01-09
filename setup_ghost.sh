#!/bin/bash

# -------------------------------
# Ghost Watch Dungeon Setup
# -------------------------------

DUNGEON=ghost_watch
mkdir -p $DUNGEON/{bin,clues}
cd $DUNGEON || exit 1

# Create ghost listener script
cat << 'EOF' > bin/ghost_listener.sh
#!/bin/bash
while true; do
    nc -l -p 4545 >/dev/null 2>&1
done
EOF

chmod +x bin/ghost_listener.sh

# Create respawning ghost captain
cat << 'EOF' > bin/ghost_captain.sh
#!/bin/bash
while true; do
    ./ghost_listener.sh &
    wait
done
EOF

chmod +x bin/ghost_captain.sh

# Launch the ghost captain
./bin/ghost_captain.sh &

# Create clues
echo "CLUE 1: Something whispers on the network." > clues/start_here.txt
echo "CLUE 2: Killing the voice does not stop the haunting." > clues/restless_spirit.txt
echo "CLUE 3: Find what commands the ghost." > clues/the_master.txt

# --- Create success verification script ---
cat << 'EOF' > check_ghost.sh
#!/bin/bash

echo "Checking for lingering spirits..."

if ss -tulnp 2>/dev/null | grep -q 4545; then
    echo "FAIL: A ghost is still listening on port 4545."
    exit 1
fi

if pgrep -f ghost_ > /dev/null; then
    echo "FAIL: Ghost processes still detected."
    exit 1
fi

echo "SUCCESS: The system is silent. The ghost has been banished."
EOF

chmod +x check_ghost.sh
# ----------------------------------------

clear
echo "Ghost Watch setup complete. Enter the dungeon to begin."
rm -- "$0"
