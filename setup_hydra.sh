#!/bin/bash
# Hydra Head Hunt setup

# --- Persist Hydra Key ---
# Export the key system-wide so students can access it in any shell
echo 'export HYDRA_KEY="many_heads"' | sudo tee /etc/profile.d/hydra_key.sh >/dev/null
sudo chmod 644 /etc/profile.d/hydra_key.sh

# --- Create dungeon directories ---
mkdir -p ~/hydra_head/bin ~/hydra_head/clues

# --- Place a script that simulates a Hydra process ---
cat << 'EOF' > ~/hydra_head/bin/hydra_head.sh
#!/bin/bash
# Hydra process just sits and prints every 30s
while true; do
  echo "Hydra head is watching..."
  sleep 30
done
EOF
chmod +x ~/hydra_head/bin/hydra_head.sh

# --- Create clue files ---
echo "CLUE 1: Find the Hydra key in your environment variables!" > ~/hydra_head/clues/start_here.txt
echo "CLUE 2: Use the key to defeat the Hydra." > ~/hydra_head/clues/defeat_hydra.txt

# --- Verification script ---
mkdir -p ~/hydra_head/lair
cat << 'EOF' > ~/hydra_head/lair/check_hydra.sh
#!/bin/bash
if [[ "$HYDRA_KEY" == "many_heads" ]]; then
    echo "🐍 Hydra defeated! The key is correct."
else
    echo "❌ Hydra still lives. The key is missing or incorrect."
fi
EOF
chmod +x ~/hydra_head/lair/check_hydra.sh

echo "Hydra Head Hunt setup complete!"
echo "Open a new terminal or run 'source /etc/profile.d/hydra_key.sh' to access HYDRA_KEY."
