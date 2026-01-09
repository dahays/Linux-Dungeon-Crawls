#!/bin/bash
# ======================================
# The Dragon Cron - Setup Script
# Teaches cron jobs and persistence
# ======================================

set -e

echo "[*] Setting up The Dragon Cron..."

# -------------------------------
# 1. Create dragon lair directory
# -------------------------------
mkdir -p "$HOME/dragon_lair"
cd "$HOME/dragon_lair"

# -------------------------------
# 2. Create cron job script
# -------------------------------
cat << 'EOF' > "$HOME/dragon_lair/dragon_cron.sh"
#!/bin/bash
# Writes timestamp to log.txt
mkdir -p "$HOME/dragon_lair"
echo "Dragon Cron active: $(date)" >> "$HOME/dragon_lair/log.txt"
EOF

chmod +x "$HOME/dragon_lair/dragon_cron.sh"

# -------------------------------
# 3. Install cron job
# -------------------------------
# Run every minute (for testing purposes)
(crontab -l 2>/dev/null; echo "* * * * * $HOME/dragon_lair/dragon_cron.sh") | crontab -

# -------------------------------
# 4. Create verification script
# -------------------------------
cat << 'EOF' > "$HOME/dragon_lair/check_dragon.sh"
#!/bin/bash
echo "=== Dragon Cron Verification ==="

LOG="$HOME/dragon_lair/log.txt"

if [[ ! -f "$LOG" ]]; then
    echo "❌ Dragon log not found. Wait a minute for cron to run or check cron setup."
    exit 1
fi

if ! grep -q "Dragon Cron active" "$LOG"; then
    echo "❌ Dragon cron job has not run yet. Wait a minute."
    exit 1
fi

echo "✅ Dragon cron job executed successfully"
echo "🏆 Dragon Cron completed!"
EOF

chmod +x "$HOME/dragon_lair/check_dragon.sh"

# -------------------------------
# 5. Final instructions
# -------------------------------
echo
echo "🐉 The Dragon Cron writes a log every minute."
echo
echo "To complete the challenge:"
echo "  1. Wait 1–2 minutes for cron to execute"
echo "  2. Check the log: 'cat ~/dragon_lair/log.txt'"
echo "  3. Verify with './check_dragon.sh'"
echo
echo "[*] Setup complete."
