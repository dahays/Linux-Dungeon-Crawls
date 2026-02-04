#!/bin/bash
set -e
set -o pipefail

echo "🔥 Trial of Eternal Fire - build 2026-02-04-REV-4"

echo "🔥 Igniting the Trial of Eternal Fire..."

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
HINT_DIR="$TRIAL_DIR/.hints"

# -------------------------------------------------
# 1. Create directory structure
# -------------------------------------------------
echo "🜂 Raising the dungeon halls..."

mkdir -p \
  "$FIREWARDEN_DIR" \
  "$INFERNO_DIR" \
  "$PYROMANCER_DIR" \
  "$WRAITH_DIR" \
  "$TREASURE_DIR" \
  "$HINT_DIR"

chown -R "$REAL_USER:$REAL_USER" "$TRIAL_DIR"

# -------------------------------------------------
# 2. Firewarden ls wrapper
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
# 3. Hydra-consistent env hijack
# -------------------------------------------------
echo "🜄 Sealing the PATH distortion..."

ZSHRC="$REAL_HOME/.zshrc"

sed -i '/Trial of Eternal Fire/d' "$ZSHRC"
sed -i '/firewarden\/ls/d' "$ZSHRC"
sed -i '/ls()/d' "$ZSHRC"

cat << 'EOF' >> "$ZSHRC"

# --- Trial of Eternal Fire: Firewarden illusion ---
typeset -U path
path=("$HOME/trial_eternal_fire/firewarden" $path)

ls() {
  "$HOME/trial_eternal_fire/firewarden/ls" "$@"
}
# -----------------------------------------------
EOF

chown "$REAL_USER:$REAL_USER" "$ZSHRC"

# -------------------------------------------------
# 4. Inferno
# -------------------------------------------------
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
# 5. Pyromancer
# -------------------------------------------------
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
# 6. Wraiths (cron)
# -------------------------------------------------
CRON_TMP="/tmp/eternal_fire_cron"
sudo -u "$REAL_USER" crontab -l 2>/dev/null > "$CRON_TMP" || true

grep -q trial_eternal_fire "$CRON_TMP" || cat << EOF >> "$CRON_TMP"
*/1 * * * * $PYROMANCER_DIR/pyromancer.sh >/dev/null 2>&1
EOF

sudo -u "$REAL_USER" crontab "$CRON_TMP"
rm -f "$CRON_TMP"

# -------------------------------------------------
# 7. Start initial processes
# -------------------------------------------------
sudo -u "$REAL_USER" nohup "$INFERNO_DIR/inferno.sh" >/dev/null 2>&1 &
sudo -u "$REAL_USER" nohup "$PYROMANCER_DIR/pyromancer.sh" >/dev/null 2>&1 &

# -------------------------------------------------
# 8. Treasure (encrypted flag)
# -------------------------------------------------
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
# 8.5 Strange Manuscript (RESTORED, DOUBLE-ARCHIVED)
# -------------------------------------------------
echo "📜 Sealing the Strange Manuscript..."

MANUSCRIPT="$HINT_DIR/strange_manuscript.txt"

cat << 'EOF' > "$MANUSCRIPT"
You uncover a thin, brittle page sealed away from sight:

Gazing into the embers, you notice the words shift.
Lurking meaning hides where flames burn brightest.
Only those who read carefully endure the trial.
Rituals reward patience, not force.
Yield to the fire, and it will answer.

The flame leads to treasure, fortune, and GLORY!
EOF

# Encrypt manuscript
sudo -u "$REAL_USER" \
  gpg --batch --yes --passphrase "GLORY" -c "$MANUSCRIPT"

# Zip the encrypted manuscript
sudo -u "$REAL_USER" \
  zip -q "$HINT_DIR/fire_hint.zip" "$MANUSCRIPT.gpg"

# Tar.gz the zip
sudo -u "$REAL_USER" \
  tar -czf "$HINT_DIR/fire_hint.tgz" -C "$HINT_DIR" fire_hint.zip

# Cleanup intermediates
rm -f "$MANUSCRIPT" "$MANUSCRIPT.gpg" "$HINT_DIR/fire_hint.zip"

chown "$REAL_USER:$REAL_USER" "$HINT_DIR/fire_hint.tgz"
chmod 600 "$HINT_DIR/fire_hint.tgz"

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
