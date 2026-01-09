#!/bin/bash

# ===============================
# Hydra Head Hunt Setup Script
# ===============================

BASE_DIR="$HOME/hydra_hunt"
BIN_DIR="$BASE_DIR/harbor/bin"

mkdir -p "$BIN_DIR" "$BASE_DIR/locker"

# -------------------------------
# Create the hydra process script
# -------------------------------
cat << 'EOF' > /tmp/hydra_core.sh
#!/bin/bash
exec -a hydra_head sleep 600
EOF

chmod +x /tmp/hydra_core.sh

# -------------------------------
# Spawn multiple hydra heads
# -------------------------------
for head in deckhand lookout navigator; do
  cp /tmp/hydra_core.sh /tmp/$head
  /tmp/$head &
done

# -------------------------------
# Export the hidden key
# -------------------------------
export HYDRA_KEY="trident"

# -------------------------------
# PATH hijack (safe)
# -------------------------------
cat << 'EOF' > "$BIN_DIR/ls"
#!/bin/bash
echo "⚠️  The Hydra watches every move..."
/bin/ls "$@"
EOF
chmod +x "$BIN_DIR/ls"

# Prepend malicious path
export PATH="$BIN_DIR:$PATH"

# -------------------------------
# Clues
# -------------------------------
echo "CLUE 1: One head is never the whole beast." > "$BASE_DIR/start.txt"
echo "CLUE 2: Some secrets are carried, not stored." > "$BASE_DIR/harbor/logbook.txt"
echo "CLUE 3: Can you trust the commands you run?" > "$BASE_DIR/locker/readme.txt"

# -------------------------------
# Victory check script
# -------------------------------
cat << 'EOF' > "$BASE_DIR/check_hydra.sh"
#!/bin/bash

if pgrep -f hydra_head > /dev/null; then
  echo "❌ The Hydra still lives."
  exit 1
fi

if [ "$HYDRA_KEY" != "trident" ]; then
  echo "❌ The Hydra key is missing."
  exit 1
fi

echo "✅ The Hydra has fallen. The harbor is safe."
EOF

chmod +x "$BASE_DIR/check_hydra.sh"

clear
echo "🐍 Hydra Head Hunt deployed."
echo "Begin in: $BASE_DIR"
rm -- "$0"
