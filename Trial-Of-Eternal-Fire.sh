#!/bin/bash
set -e
set -o pipefail

echo "🔥 Embarking on The Trial of Eternal Fire..."

# -------------------------------
# 0. Require sudo, capture student
# -------------------------------
if [[ "$EUID" -ne 0 ]]; then
  echo "🚫 This installer must be run with sudo."
  exit 1
fi

if [[ -z "$SUDO_USER" || "$SUDO_USER" == "root" ]]; then
  echo "🚫 Cannot determine invoking user."
  exit 1
fi

STUDENT_USER="$SUDO_USER"
STUDENT_HOME="$(getent passwd "$STUDENT_USER" | cut -d: -f6)"

echo "🎯 Deploying trial for: $STUDENT_USER"
echo "🏠 Home directory: $STUDENT_HOME"

# -------------------------------
# 1. Create dungeon directories
# -------------------------------
DUNGEON_DIR="$STUDENT_HOME/trial_eternal_fire"
mkdir -p "$DUNGEON_DIR"/{firewarden,wraiths,pyromancer,inferno,treasure}
chown -R "$STUDENT_USER:$STUDENT_USER" "$DUNGEON_DIR"

# -------------------------------
# 2. Fire Warden mini challenge (environment)
# -------------------------------
FIRE_BIN="$DUNGEON_DIR/firewarden/ls"
cat << 'EOF' > "$FIRE_BIN"
#!/bin/bash
if [[ "$FIRE_TRIAL" == "eternal_flame" ]]; then
  RED="\033[0;31m"
  RESET="\033[0m"
  echo -e "${RED}🔥 The Eternal Flame watches your steps...${RESET}"
fi
/bin/ls "$@"
EOF
chmod +x "$FIRE_BIN"
chown "$STUDENT_USER:$STUDENT_USER" "$FIRE_BIN"

# Add environment hook
ZSHRC="$STUDENT_HOME/.zshrc"
touch "$ZSHRC"
chown "$STUDENT_USER:$STUDENT_USER" "$ZSHRC"
grep -q "trial_eternal_fire" "$ZSHRC" || cat << EOF >> "$ZSHRC"

# --- Fire Warden environment ---
export FIRE_TRIAL=eternal_flame
typeset -U path
path=("$DUNGEON_DIR/firewarden" \$path)
ls() {
  "$DUNGEON_DIR/firewarden/ls" "\$@"
}
EOF

# -------------------------------
# 3. Wraiths challenge (child processes)
# -------------------------------
WRAITH_DIR="$DUNGEON_DIR/wraiths"
cat << 'EOF' > "$WRAITH_DIR/wraith_core.sh"
#!/bin/bash
sleep 3600
EOF
chmod +x "$WRAITH_DIR/wraith_core.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$WRAITH_DIR/wraith_core.sh"

# Launch wraiths
for i in 1 2; do
  sudo -u "$STUDENT_USER" nohup bash -c "exec -a wandering_wraith$i $WRAITH_DIR/wraith_core.sh" >/dev/null 2>&1 &
done

# -------------------------------
# 4. Pyromancer challenge (parent respawn)
# -------------------------------
PYRO="$DUNGEON_DIR/pyromancer/pyromancer.sh"
cat << 'EOF' > "$PYRO"
#!/bin/bash
# Pyromancer resurrects wraiths endlessly
while true; do
  for i in 1 2; do
    if ! pgrep -f "wandering_wraith$i" >/dev/null; then
      "$HOME/trial_eternal_fire/wraiths/wraith_core.sh" &
    fi
  done
  sleep 3
done
EOF
chmod +x "$PYRO"
chown "$STUDENT_USER:$STUDENT_USER" "$PYRO"

# Launch Pyromancer
sudo -u "$STUDENT_USER" nohup "$PYRO" >/dev/null 2>&1 &

# -------------------------------
# 5. Inferno challenge (cron persistence)
# -------------------------------
INFERNO_DIR="$DUNGEON_DIR/inferno"
mkdir -p "$INFERNO_DIR"
cat << 'EOF' > "$INFERNO_DIR/inferno_cron.sh"
#!/bin/bash
echo "🔥 Inferno roars at $(date)" >> "$HOME/trial_eternal_fire/inferno/inferno.log"
EOF
chmod +x "$INFERNO_DIR/inferno_cron.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$INFERNO_DIR/inferno_cron.sh"

# Install cron job
sudo -u "$STUDENT_USER" crontab -l 2>/dev/null | grep -v inferno_cron.sh | sudo -u "$STUDENT_USER" crontab -
sudo -u "$STUDENT_USER" bash -c "(crontab -l 2>/dev/null; echo '* * * * * \$HOME/trial_eternal_fire/inferno/inferno_cron.sh') | crontab -"

# -------------------------------
# 6. Flamebound Treasure (encrypted file)
# -------------------------------
TREASURE_DIR="$DUNGEON_DIR/treasure"
TREASURE_PLAINTEXT="$TREASURE_DIR/treasure.txt"
TREASURE_GPG="$TREASURE_DIR/.treasure.gpg"

cat << 'EOF' > "$TREASURE_PLAINTEXT"
🏆 CONGRATULATIONS, HERO OF FIRE!
You have mastered the Trial of Eternal Fire.
Your courage, insight, and Linux prowess are unmatched.
EOF

gpg --batch --yes --passphrase "GLORY" -c -o "$TREASURE_GPG" "$TREASURE_PLAINTEXT"
chmod 000 "$TREASURE_GPG"
rm "$TREASURE_PLAINTEXT"

# Create disarm script
cat << 'EOF' > "$TREASURE_DIR/disarm_treasure.sh"
#!/bin/bash
if pgrep -f "wraith_core.sh\|pyromancer.sh" >/dev/null; then
  echo "💀 Some wraiths still linger. Defeat them first!"
  exit 1
fi
if crontab -l 2>/dev/null | grep -q inferno_cron.sh; then
  echo "🔥 The Inferno still burns. Remove the cron job first!"
  exit 1
fi
echo "🗝️ The path is clear! Unlocking Flamebound Treasure..."
chmod 400 .treasure.gpg
echo "✅ Treasure ready. Use gpg --batch --yes -d --passphrase GLORY .treasure.gpg to read it."
EOF
chmod +x "$TREASURE_DIR/disarm_treasure.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$TREASURE_DIR/disarm_treasure.sh"

# -------------------------------
# 7. Hidden manuscript (lyric clue)
# -------------------------------
MANUSCRIPT="$DUNGEON_DIR/.strange_manuscript"
cat << 'EOF' > "$MANUSCRIPT"
in the shadows, a Great blaze whispers,
Low flames curl around forgotten stones,
Onward you tread past glowing embers,
resolute heaRts find the key at last,
your courage lights the path to glorY.
EOF
chmod 600 "$MANUSCRIPT"
chown "$STUDENT_USER:$STUDENT_USER" "$MANUSCRIPT"

# -------------------------------
# 8. Completion scripts
# -------------------------------
# Firewarden check
FIRE_CHECK="$DUNGEON_DIR/firewarden/check_fire.sh"
cat << 'EOF' > "$FIRE_CHECK"
#!/bin/bash
if [[ "$FIRE_TRIAL" != "eternal_flame" ]]; then
  echo "❌ FIRE_TRIAL environment not set correctly"
  exit 1
fi
echo "✔ Firewarden environment active"
EOF
chmod +x "$FIRE_CHECK"
chown "$STUDENT_USER:$STUDENT_USER" "$FIRE_CHECK"

# Overall dungeon check
REVIEW_CHECK="$DUNGEON_DIR/check_trial.sh"
cat << 'EOF' > "$REVIEW_CHECK"
#!/bin/bash
echo "🔎 Verifying Trial of Eternal Fire..."
FAIL=0

# Wraiths
if pgrep -f wraith_core.sh >/dev/null; then
  echo "❌ Wraiths still alive"
  FAIL=1
fi
# Pyromancer
if pgrep -f pyromancer.sh >/dev/null; then
  echo "❌ Pyromancer still active"
  FAIL=1
fi
# Inferno
if crontab -l 2>/dev/null | grep -q inferno_cron.sh; then
  echo "❌ Inferno cron still active"
  FAIL=1
fi
# Treasure
if [[ ! -f $HOME/trial_eternal_fire/treasure/.treasure.gpg ]]; then
  echo "❌ Treasure missing"
  FAIL=1
fi

if [[ $FAIL -eq 1 ]]; then
  echo "⚠️ Trial incomplete!"
  exit 1
fi

echo "🏆 All trials cleared. You have mastered the Trial of Eternal Fire!"
EOF
chmod +x "$REVIEW_CHECK"
chown "$STUDENT_USER:$STUDENT_USER" "$REVIEW_CHECK"

# -------------------------------
# 9. Final message
# -------------------------------
clear
cat << EOF

🔥 The Trial of Eternal Fire is ready!

✔ Firewarden environment set
✔ Wraiths roaming the dungeon
✔ Pyromancer resurrecting wraiths
✔ Inferno cron ignited
✔ Flamebound Treasure hidden

📖 Proceed carefully, you must defeat your foes in the correct order to complete the Trial and find the treasure:
Firewarden → Wraiths → Pyromancer → Inferno → Treasure.

To verify:
  cd ~/trial_eternal_fire
  ./check_trial.sh

EOF
