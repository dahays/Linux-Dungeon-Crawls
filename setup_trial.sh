#!/bin/bash
set -e
set -o pipefail

echo "🔥 Trial of Eternal Fire - Stable Build 2026-2-4-REV4"

# -------------------------------------------------
# 0. Require sudo, capture invoking user
# -------------------------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 This rite must be invoked with sudo."
  exit 1
fi

if [[ -z "$SUDO_USER" || "$SUDO_USER" == "root" ]]; then
  echo "🚫 Cannot determine invoking user."
  exit 1
fi

REAL_USER="$SUDO_USER"
REAL_HOME="$(getent passwd "$REAL_USER" | cut -d: -f6)"

TRIAL_DIR="$REAL_HOME/trial_eternal_fire"
FIREWARDEN_DIR="$TRIAL_DIR/firewarden"
INFERNO_DIR="$TRIAL_DIR/inferno"
PYROMANCER_DIR="$TRIAL_DIR/pyromancer"
WRAITH_DIR="$TRIAL_DIR/wraiths"
TREASURE_DIR="$TRIAL_DIR/treasure"

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
# 2. Firewarden ls wrapper (binary, not function)
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
# 3. Firewarden env file (SAFE)
# -------------------------------------------------
echo "🜄 Sealing the PATH distortion..."

FIRE_ENV="$TRIAL_DIR/.firewarden_env"

cat << 'EOF' > "$FIRE_ENV"
# 🔥 Firewarden Environment

# Clean any prior illusions
unalias ls 2>/dev/null
unset -f ls 2>/dev/null

# PATH precedence (Hydra-consistent)
typeset -U path
path=("$HOME/trial_eternal_fire/firewarden" $path)
EOF

chown "$REAL_USER:$REAL_USER" "$FIRE_ENV"
chmod 644 "$FIRE_ENV"

# -------------------------------------------------
# 4. Source env safely from .zshrc
# -------------------------------------------------
ZSHRC="$REAL_HOME/.zshrc"
touch "$ZSHRC"
chown "$REAL_USER:$REAL_USER" "$ZSHRC"

# Remove any old Firewarden references (block-based)
sed -i '/firewarden_env/d' "$ZSHRC"

cat << 'EOF' >> "$ZSHRC"

# --- Trial of Eternal Fire ---
if [[ -f "$HOME/trial_eternal_fire/.firewarden_env" ]]; then
  source "$HOME/trial_eternal_fire/.firewarden_env"
fi
# ----------------------------
EOF

# -------------------------------------------------
# 5. Inferno (noisy process)
# -------------------------------------------------
echo "🔥 Lighting the Inferno..."

cat << 'EOF' > "$INFERNO_DIR/inferno.sh"
#!/bin/bash
while true; do
  echo "🔥 The inferno roars at $(date)" >> "$HOME/trial_eternal_fire/inferno/inferno.log"
  sleep 5
done
EOF

chmod +x "$INFERNO_DIR/inferno.sh"
chown "$REAL_USER:$REAL_USER" "$INFERNO_DIR/inferno.sh"

# -------------------------------------------------
# 6. Pyromancer (respawner)
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
# 7. Wraiths (cron persistence)
# -------------------------------------------------
echo "👻 Binding the Wraiths..."

CRON_TMP="/tmp/eternal_fire_cron"

sudo -u "$REAL_USER" crontab -l 2>/dev/null > "$CRON_TMP" || true

grep -q trial_eternal_fire "$CRON_TMP" || cat << EOF >> "$CRON_TMP"
*/1 * * * * $PYROMANCER_DIR/pyromancer.sh >/dev/null 2>&1
EOF

sudo -u "$REAL_USER" crontab "$CRON_TMP"
rm -f "$CRON_TMP"

# -------------------------------------------------
# 8. Start initial processes
# -------------------------------------------------
echo "🔥 Awakening the flames..."

sudo -u "$REAL_USER" nohup "$INFERNO_DIR/inferno.sh" >/dev/null 2>&1 &
sudo -u "$REAL_USER" nohup "$PYROMANCER_DIR/pyromancer.sh" >/dev/null 2>&1 &

# -------------------------------------------------
# 9. Create the treasure
# -------------------------------------------------
echo "🜂 Forging the treasure..."

PLAINTEXT_FLAG="THE_FIRE_YIELDS_ONLY_TO_THOSE_WHO_ENDURE"
TMP_FLAG="/tmp/eternal_fire_flag.txt"

echo "$PLAINTEXT_FLAG" > "$TMP_FLAG"

sudo -u "$REAL_USER" \
  gpg --batch --yes --passphrase "GLORY" -c "$TMP_FLAG"

mv "$TMP_FLAG.gpg" "$TREASURE_DIR/.treasure.gpg"
rm -f "$TMP_FLAG"

chown "$REAL_USER:$REAL_USER" "$TREASURE_DIR/.treasure.gpg"
chmod 600 "$TREASURE_DIR/.treasure.gpg"

# -------------------------------------------------
# 10. Final blessing
# -------------------------------------------------
cat << EOF

🔥 THE TRIAL OF ETERNAL FIRE IS READY

IMPORTANT (one-time):
  exec zsh

Then begin:
  cd ~/trial_eternal_fire
  ls

Victory is not earned by force,
but by understanding what still burns
after the fire appears gone.

🜂 May the worthy prevail.

EOF
