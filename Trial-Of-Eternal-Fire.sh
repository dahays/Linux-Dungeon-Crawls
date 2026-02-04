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
INFERNO_DIR="$TRIAL_DIR/inferno"
PYROMANCER_DIR="$TRIAL_DIR/pyromancer"
WRAITH_DIR="$TRIAL_DIR/wraiths"

# -------------------------------------------------
# 1. Create directory structure
# -------------------------------------------------
echo "🜂 Raising the dungeon halls..."

mkdir -p \
  "$FIREWARDEN_DIR" \
  "$INFERNO_DIR" \
  "$PYROMANCER_DIR" \
  "$WRAITH_DIR" \
  "$TREASURE_DIR"

chown -R "$REAL_USER:$REAL_USER" "$TRIAL_DIR"

# -------------------------------------------------
# 2. Firewarden command illusion
# -------------------------------------------------
echo "🜁 Binding Firewarden illusions..."

cat << 'EOF' > "$FIREWARDEN_DIR/ls"
#!/bin/bash
echo "🔥 The Eternal Flame watches your steps..."
/bin/ls "$@"
EOF

chmod +x "$FIREWARDEN_DIR/ls"
chown "$REAL_USER:$REAL_USER" "$FIREWARDEN_DIR/ls"

# -------------------------------------------------
# 3. Guaranteed env hijack (Hydra-aligned, zsh-safe)
# -------------------------------------------------
echo "🜄 Sealing the PATH distortion..."

setopt noaliases

FIRE_RC="$TRIAL_DIR/.firewarden_env"

cat << 'EOF' > "$FIRE_RC"
# 🔥 Firewarden Env Hijack (zsh-safe)

if [[ "$PWD" == "$HOME/trial_eternal_fire"* ]]; then
  # Critical: remove alias before defining function (zsh rule)
  unalias ls 2>/dev/null
  unset -f ls 2>/dev/null

  export PATH="$HOME/trial_eternal_fire/firewarden:$PATH"

  ls() {
    "$HOME/trial_eternal_fire/firewarden/ls" "$@"
  }
fi
EOF

chown "$REAL_USER:$REAL_USER" "$FIRE_RC"
chmod 644 "$FIRE_RC"

ZSHRC="$REAL_HOME/.zshrc"
touch "$ZSHRC"
chown "$REAL_USER:$REAL_USER" "$ZSHRC"

if ! grep -q ".firewarden_env" "$ZSHRC"; then
  echo "" >> "$ZSHRC"
  echo "# 🔥 Trial of Eternal Fire" >> "$ZSHRC"
  echo "source \$HOME/trial_eternal_fire/.firewarden_env" >> "$ZSHRC"
fi

# -------------------------------------------------
# 4. Inferno (noisy process)
# -------------------------------------------------
echo "🜃 Lighting the Inferno..."

cat << 'EOF' > "$INFERNO_DIR/inferno.sh"
#!/bin/bash
while true; do
  echo "🔥🔥🔥 The inferno roars..."
  sleep 5
done
EOF

chmod +x "$INFERNO_DIR/inferno.sh"
chown "$REAL_USER:$REAL_USER" "$INFERNO_DIR/inferno.sh"

# -------------------------------------------------
# 5. Pyromancer (respawner)
# -------------------------------------------------
echo "🜄 Summoning the Pyromancer..."

cat << 'EOF' > "$PYROMANCER_DIR/pyromancer.sh"
#!/bin/bash

INFERNO="$HOME/trial_eternal_fire/inferno/inferno.sh"

while true; do
  if ! pgrep -f "$INFERNO" >/dev/null; then
    nohup "$INFERNO" >/dev/null 2>&1 &
  fi
  sleep 10
done
EOF

chmod +x "$PYROMANCER_DIR/pyromancer.sh"
chown "$REAL_USER:$REAL_USER" "$PYROMANCER_DIR/pyromancer.sh"

# -------------------------------------------------
# 6. Wraiths (cron persistence)
# -------------------------------------------------
echo "👻 Binding the Wraiths..."

CRON_FILE="/tmp/fire_trial_cron.$$"

sudo -u "$REAL_USER" crontab -l 2>/dev/null > "$CRON_FILE" || true

if ! grep -q "pyromancer.sh" "$CRON_FILE"; then
  echo "* * * * * $PYROMANCER_DIR/pyromancer.sh >/dev/null 2>&1" >> "$CRON_FILE"
fi

sudo -u "$REAL_USER" crontab "$CRON_FILE"
rm -f "$CRON_FILE"

# -------------------------------------------------
# 7. Start initial processes
# -------------------------------------------------
echo "🔥 Awakening the flames..."

sudo -u "$REAL_USER" nohup "$INFERNO_DIR/inferno.sh" >/dev/null 2>&1 &
sudo -u "$REAL_USER" nohup "$PYROMANCER_DIR/pyromancer.sh" >/dev/null 2>&1 &

# -------------------------------------------------
# 8. Create the treasure
# -------------------------------------------------
echo "🜂 Forging the treasure..."

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
# 9. Disarm script
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
# 10. Final blessing
# -------------------------------------------------
echo ""
echo "🔥 The Trial of Eternal Fire is ready."
echo ""
echo "IMPORTANT (one-time):"
echo "  exec zsh"
echo ""
echo "Then begin:"
echo "  cd ~/trial_eternal_fire"
echo "  ls"
echo ""
echo "🜂 May the worthy prevail."
