#!/bin/bash

# ===============================
# Ghost Watch Setup Script
# ===============================

BASE_DIR="$HOME/ghost_ship"
mkdir -p "$BASE_DIR/bridge" "$BASE_DIR/brig"

# -------------------------------
# Dependency check
# -------------------------------
command -v nc >/dev/null || {
  echo "❌ Netcat (nc) is required."
  exit 1
}

# -------------------------------
# Create the ghost captain
# -------------------------------
cat << 'EOF' > /tmp/ghost_captain.sh
#!/bin/bash

trap "echo 'The captain fades into the mist...'; exit 0" SIGTERM

while true; do
  exec -a ghost_listener nc -l 4545 >/dev/null 2>&1
done
EOF

chmod +x /tmp/ghost_captain.sh

# Launch persistent parent
exec -a ghost_captain /tmp/ghost_captain.sh &

# -------------------------------
# Clues
# -------------------------------
echo "CLUE 1: The ship whispers, but never speaks." > "$BASE_DIR/start.txt"
echo "CLUE 2: Killing the crew does nothing." > "$BASE_DIR/bridge/chart.txt"
echo "CLUE 3: Only the captain hears the bell." > "$BASE_DIR/brig/graffiti.txt"

# -------------------------------
# Confirmation script
# -------------------------------
cat << 'EOF' > "$BASE_DIR/confirm_silence.sh"
#!/bin/bash

if ss -tulnp | grep 4545 > /dev/null; then
  echo "❌ The Ghost Ship still whispers."
  exit 1
fi

if pgrep -f ghost_captain > /dev/null; then
  echo "❌ The captain still roams."
  exit 1
fi

echo "✅ The sea is silent. The Ghost Ship is gone."
EOF

chmod +x "$BASE_DIR/confirm_silence.sh"

clear
echo "👻 Ghost Watch deployed."
echo "Begin in: $BASE_DIR"
rm -- "$0"
