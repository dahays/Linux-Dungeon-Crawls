#!/bin/bash
set -e
set -o pipefail

echo "🔥 Igniting the Trial of Eternal Fire..."

# -------------------------------------------------
# 0. Require sudo, capture invoking user
# -------------------------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 This rite must be invoked with sudo."
  exit 1
fi

REAL_USER="${SUDO_USER}"
REAL_HOME="$(eval echo "~$REAL_USER")"

TRIAL_DIR="$REAL_HOME/trial_eternal_fire"
FIREWARDEN_DIR="$TRIAL_DIR/firewarden"
TREASURE_DIR="$TRIAL_DIR/treasure"

# -------------------------------------------------
# 1. Create directory structure
# -------------------------------------------------
echo "🜂 Raising the dungeon halls..."

mkdir -p \
  "$FIREWARDEN_DIR" \
  "$TRIAL_DIR/inferno" \
  "$TRIAL_DIR/pyromancer" \
  "$TRIAL_DIR/wraiths" \
  "$TREASURE_DIR"

chown -R "$REAL_USER:$REAL_USER" "$TRIAL_DIR"

# -------------------------------------------------
# 2. Firewarden command illusion
# -------------------------------------------------
echo "🜁 Binding Firewarden illusions..."

cat << 'EOF' > "$FIREWARDEN_DIR/ls"
#!/bin/bash
echo "🔥 The Eternal Flame watches your steps..."
command ls "$@"
EOF

chmod +x "$FIREWARDEN_DIR/ls"

# -------------------------------------------------
# 3. Guaranteed env hijack (Hydra-style)
# -------------------------------------------------
echo "🜄 Sealing the PATH distortion..."

FIRE_RC="$TRIAL_DIR/.firewarden_env"

cat << 'EOF' > "$FIRE_RC"
# 🔥 Firewarden Env Hijack
if [[ "$PWD" == "$HOME/trial_eternal_fire"* ]]; then
  export PATH="$HOME/trial_eternal_fire/firewarden:$PATH"

  ls() {
    "$HOME/trial_eternal_fire/firewarden/ls" "$@"
  }
fi
EOF

chown "$REAL_USER:$REAL_USER" "$FIRE_RC"
chmod 644 "$FIRE_RC"

# Ensure zsh sources it
ZSHRC="$REAL_HOME/.zshrc"
if ! grep -q ".firewarden_env" "$ZSHRC"; then
  echo "" >> "$ZSHRC"
  echo "# 🔥 Trial of Eternal Fire" >> "$ZSHRC"
  echo "source \$HOME/trial_eternal_fire/.firewarden_env" >> "$ZSHRC"
fi

# -------------------------------------------------
# 4. Create the treasure (THIS WAS MISSING)
# -------------------------------------------------
echo "🜃 Forging the treasure..."

PLAINTEXT_FLAG="THE_FIRE_YIELDS_ONLY_TO_THOSE_WHO_ENDURE"

echo "$PLAINTEXT_FLAG" > /tmp/treasure.txt

sudo -u "$REAL_USER" \
  gpg --batch --yes \
  --passphrase "GLORY" \
  -c /tmp/treasure.txt

mv /tmp/treasure.txt.gpg "$TREASURE_DIR/.treasure.gpg"
rm -f /tmp/treasure.txt

chown "$REAL_USER:$REAL_USER" "$TREASURE_DIR/.treasure.gpg"
chmod 600 "$TREASURE_DIR/.treasure.gpg"

# -------------------------------------------------
# 5. Disarm script (purely ceremonial, no creation)
# -------------------------------------------------
cat << 'EOF' > "$TREASURE_DIR/disarm_treasure.sh"
#!/bin/bash

if [[ ! -f ".treasure.gpg" ]]; then
  echo "🔥 The flames still guard the prize."
  exit 1
fi

echo "🔥 The flames subside. The treasure is yours."
EOF

chmod +x "$TREASURE_DIR/disarm_treasure.sh"
chown "$REAL_USER:$REAL_USER" "$TREASURE_DIR/disarm_treasure.sh"

# -------------------------------------------------
# 6. Final blessing
# -------------------------------------------------
echo ""
echo "🔥 The Trial of Eternal Fire is ready."
echo ""
echo "IMPORTANT:"
echo "  exec zsh"
echo ""
echo "Then begin:"
echo "  cd ~/trial_eternal_fire"
echo "  ls"
echo ""
echo "To verify completion:"
echo "  ./check_trial.sh"
echo ""
echo "🜂 May the worthy prevail."
