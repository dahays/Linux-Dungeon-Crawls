#!/bin/bash
set -e
set -o pipefail

echo "🔥 Igniting the Trial of Eternal Fire (one-time setup)..."
echo

# -------------------------------
# 0. Require sudo, capture user
# -------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 This ritual must be invoked with sudo."
  exit 1
fi

REAL_USER="$SUDO_USER"
USER_HOME="$(eval echo ~$REAL_USER)"
TRIAL_DIR="$USER_HOME/trial_eternal_fire"

# -------------------------------
# 1. Create Trial Structure
# -------------------------------
echo "🔥 Forging trial chambers..."

mkdir -p \
  "$TRIAL_DIR/firewarden" \
  "$TRIAL_DIR/wraiths" \
  "$TRIAL_DIR/pyromancer" \
  "$TRIAL_DIR/inferno" \
  "$TRIAL_DIR/treasure"

chown -R "$REAL_USER:$REAL_USER" "$TRIAL_DIR"

# -------------------------------
# 2. Deploy Firewarden ls override
# -------------------------------
echo "🔥 Binding the Firewarden..."

cat << 'EOF' > "$TRIAL_DIR/firewarden/ls"
#!/bin/bash
echo "🔥 The Eternal Flame watches your steps..."
/bin/ls "$@"
EOF

chmod +x "$TRIAL_DIR/firewarden/ls"
chown "$REAL_USER:$REAL_USER" "$TRIAL_DIR/firewarden/ls"

# -------------------------------
# 3. Set Eternal Fire environment variable
# -------------------------------
echo "🔥 Kindling the Eternal Flame..."

echo "export FIRE_TRIAL=eternal_flame" >> "$USER_HOME/.bashrc"

# -------------------------------
# 4. Deploy wandering wraiths
# -------------------------------
echo "🔥 Summoning the Wraiths..."

cat << 'EOF' > "$TRIAL_DIR/wraiths/wandering_wraith.sh"
#!/bin/bash
while true; do
  sleep 30
done
EOF

chmod +x "$TRIAL_DIR/wraiths/wandering_wraith.sh"
chown "$REAL_USER:$REAL_USER" "$TRIAL_DIR/wraiths/wandering_wraith.sh"

for i in {1..3}; do
  sudo -u "$REAL_USER" nohup "$TRIAL_DIR/wraiths/wandering_wraith.sh" >/dev/null 2>&1 &
done

# -------------------------------
# 5. Deploy Pyromancer respawner
# -------------------------------
echo "🔥 Awakening the Pyromancer..."

cat << 'EOF' > "$TRIAL_DIR/pyromancer/pyromancer.sh"
#!/bin/bash
while true; do
  if ! pgrep -f wandering_wraith.sh >/dev/null; then
    nohup "$HOME/trial_eternal_fire/wraiths/wandering_wraith.sh" >/dev/null 2>&1 &
  fi
  sleep 20
done
EOF

chmod +x "$TRIAL_DIR/pyromancer/pyromancer.sh"
chown "$REAL_USER:$REAL_USER" "$TRIAL_DIR/pyromancer/pyromancer.sh"

sudo -u "$REAL_USER" nohup "$TRIAL_DIR/pyromancer/pyromancer.sh" >/dev/null 2>&1 &

# -------------------------------
# 6. Deploy Inferno cron persistence
# -------------------------------
echo "🔥 Feeding the Inferno..."

cat << 'EOF' > "$TRIAL_DIR/inferno/inferno_cron.sh"
#!/bin/bash
echo "$(date): The Inferno burns." >> "$HOME/trial_eternal_fire/inferno/inferno.log"
EOF

chmod +x "$TRIAL_DIR/inferno/inferno_cron.sh"
chown "$REAL_USER:$REAL_USER" "$TRIAL_DIR/inferno/inferno_cron.sh"

sudo -u "$REAL_USER" crontab -l 2>/dev/null | grep -v inferno_cron.sh | crontab -
sudo -u "$REAL_USER" crontab - << EOF
*/2 * * * * $TRIAL_DIR/inferno/inferno_cron.sh
EOF

# -------------------------------
# 7. Deploy Treasure & Manuscript
# -------------------------------
echo "🔥 Sealing the Flamebound Treasure..."

cat << 'EOF' > "$TRIAL_DIR/.strange_manuscript"
Glory rises in embers
Legends endure the flame
Only the worthy may claim
Righteous fire reveals truth
Yearn for the light
EOF

tar -czf "$TRIAL_DIR/.strange_manuscript.tar.gz" -C "$TRIAL_DIR" .strange_manuscript
rm "$TRIAL_DIR/.strange_manuscript"

chown "$REAL_USER:$REAL_USER" "$TRIAL_DIR/.strange_manuscript.tar.gz"

cat << 'EOF' > "$TRIAL_DIR/treasure/flamebound_treasure.txt"
🏆 Congratulations, Hero of Fire.
EOF

gpg --batch --yes -c --passphrase GLORY \
  -o "$TRIAL_DIR/treasure/.treasure.gpg" \
  "$TRIAL_DIR/treasure/flamebound_treasure.txt"

rm "$TRIAL_DIR/treasure/flamebound_treasure.txt"
chown -R "$REAL_USER:$REAL_USER" "$TRIAL_DIR/treasure"

# -------------------------------
# 8. Deploy UPDATED check_trial.sh
# -------------------------------
echo "🔥 Inscribing the Trial Verification..."

cat << 'EOF' > "$TRIAL_DIR/check_trial.sh"
#!/bin/bash
set -e

TRIAL_DIR="$HOME/trial_eternal_fire"
TREASURE_DIR="$TRIAL_DIR/treasure"
FINAL_FILE="$TREASURE_DIR/flamebound_treasure.txt"
MANUSCRIPT_ARCHIVE="$TRIAL_DIR/.strange_manuscript.tar.gz"
MANUSCRIPT_FILE="$TRIAL_DIR/.strange_manuscript"

if pgrep -f wandering_wraith >/dev/null; then exit 1; fi
if pgrep -f pyromancer >/dev/null; then exit 1; fi
if crontab -l 2>/dev/null | grep -q inferno_cron.sh; then exit 1; fi
if [[ -f "$MANUSCRIPT_ARCHIVE" ]]; then exit 1; fi
if [[ ! -f "$MANUSCRIPT_FILE" ]]; then exit 1; fi
if [[ ! -f "$FINAL_FILE" ]]; then exit 1; fi
if ! grep -q "Hero of Fire" "$FINAL_FILE"; then exit 1; fi

echo "🏆 All trials cleared. You have mastered the Trial of Eternal Fire!"
EOF

chmod +x "$TRIAL_DIR/check_trial.sh"
chown "$REAL_USER:$REAL_USER" "$TRIAL_DIR/check_trial.sh"

# -------------------------------
# 9. Deploy Extinguish Script
# -------------------------------
echo "🔥 Preparing the Extinguishing Rite..."

cp /root/extinguish_eternal_fire.sh "$TRIAL_DIR/extinguish_eternal_fire.sh"
chmod +x "$TRIAL_DIR/extinguish_eternal_fire.sh"
chown "$REAL_USER:$REAL_USER" "$TRIAL_DIR/extinguish_eternal_fire.sh"

echo
echo "🔥 The Trial of Eternal Fire is prepared."
echo "The flame awaits the worthy."
