#!/bin/bash

# -------------------------------
# Hydra Head Dungeon Setup
# -------------------------------

DUNGEON=hydra_head
mkdir -p $DUNGEON/{bin,clues}
cd $DUNGEON || exit 1

# Create multiple hydra processes
cat << 'EOF' > bin/hydra_head.sh
#!/bin/bash
while true; do
    sleep 60
done
EOF

chmod +x bin/hydra_head.sh

# Launch multiple heads
./bin/hydra_head.sh &
./bin/hydra_head.sh &
./bin/hydra_head.sh &

# Export environment variable clue
export HYDRA_KEY="cut_off_one_head_two_more_take_its_place"

# Create a PATH hijack example
cat << 'EOF' > bin/ls
#!/bin/bash
echo "The Hydra clouds your vision..."
/bin/ls "$@"
EOF

chmod +x bin/ls
export PATH="$PWD/bin:$PATH"

# Create clues
echo "CLUE 1: Strike down the beast, but beware — it has many heads." > clues/start_here.txt
echo "CLUE 2: The Hydra hides secrets in the environment itself." > clues/env_whispers.txt
echo "CLUE 3: Not every command is what it seems." > clues/false_paths.txt

# --- Create success verification script ---
cat << 'EOF' > check_hydra.sh
#!/bin/bash

echo "Verifying Hydra Head Hunt..."

if pgrep -f hydra_head.sh > /dev/null; then
    echo "FAIL: Hydra processes still detected."
    exit 1
fi

echo "SUCCESS: All Hydra heads have been defeated."
EOF

chmod +x check_hydra.sh
# ----------------------------------------

clear
echo "Hydra Head Hunt setup complete. Enter the dungeon to begin."
rm -- "$0"
