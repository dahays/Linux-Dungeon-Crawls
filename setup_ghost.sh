#!/bin/bash
# ======================================
# The Ghost Watch - Setup Script
# Teaches process monitoring and management
# ======================================

set -e

echo "[*] Setting up The Ghost Watch..."

# -------------------------------
# 1. Create dungeon directory
# -------------------------------
mkdir -p "$HOME/ghost_watch"
cd "$HOME/ghost_watch"

# -------------------------------
# 2. Create persistent ghost script
# -------------------------------
cat << 'EOF' > "$HOME/ghost_watch/ghost_watch.sh"
#!/bin/bash
# Ghost process just sleeps in background
while true; do
    sleep 3600
done
EOF

chmod +x "$HOME/ghost_watch/ghost_watch.sh"

# -------------------------------
# 3. Launch ghost process
# -------------------------------
nohup "$HOME/ghost_watch/ghost_watch.sh" >/dev/null 2>&1 &

# -------------------------------
# 4. Create verification script
# -------------------------------
cat << 'EOF' > "$HOME/ghost_watch/check_ghost.sh"
#!/bin/bash
echo "=== Ghost Verification ==="

# Check for any ghost_watch.sh process
if pgrep -f ghost_watch.sh > /dev/null; then
    echo "❌ Ghost process still running. Kill it to complete the challenge."
    exit 1
fi

echo "✅ Ghost process terminated"
echo "🏆 Ghost Watch completed!"
EOF

chmod +x "$HOME/ghost_watch/check_ghost.sh"

# -------------------------------
# 5. Final instructions
# -------------------------------
echo
echo "👻 The ghost process is running in the background."
echo
echo "To complete the challenge:"
echo "  1. Discover the ghost process with 'ps', 'pgrep', or 'top'"
echo "  2. Kill it using 'kill <PID>'"
echo "  3. Verify with './check_ghost.sh'"
echo
echo "[*] Setup complete."
