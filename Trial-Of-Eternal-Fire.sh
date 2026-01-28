#!/bin/bash
set -e
set -o pipefail

echo "🔥 Igniting the Trial of Eternal Fire (one-time setup)..."

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
# 2. Firewarden (Hydra-style env hijack)
# -------------------------------
echo "🔥 Binding the Firewarden..."

FIRE_BIN="$DUNGEON_DIR/firewarden/ls"
cat << 'EOF' > "$FIRE_BIN"
#!/bin/bash

# Firewarden observes all within the Trial
if [[ "$PWD" == "$HOME/trial_eternal_fire"* ]]; then
  RED="\033[0;31m"
  RESET="\033[0m"
  echo -e "${RED}🔥 The Eternal Flame watches your steps...${RESET}"
fi

/bin/ls "$@"
EOF

chmod +x "$FIRE_BIN"
chown "$STUDENT_USER:$STUDENT_USER" "$FIRE_BIN"

# Inject Firewarden into shell (matches Hydra pattern)
ZSHRC="$STUDENT_HOME/.zshrc"
touch "$ZSHRC"
chown "$STUDENT_USER:$STUDENT_USER" "$ZSHRC"

grep -q "Firewarden Trial" "$ZSHRC" || cat << EOF >> "$ZSHRC"

# --- Firewarden Trial ---
typeset -U path
path=("\$HOME/trial_eternal_fire/firewarden" \$path)

unalias ls 2>/dev/null

ls() {
  "\$HOME/trial_eternal_fire/firewarden/ls" "\$@"
}
# -----------------------
EOF

# -------------------------------
# 3. Wraiths (child processes)
# -------------------------------
echo "👻 Summoning the Wraiths..."

WRAITH_DIR="$DUNGEON_DIR/wraiths"
cat << 'EOF' > "$WRAITH_DIR/wraith_core.sh"
#!/bin/bash
sleep 3600
EOF

chmod +x "$WRAITH_DIR/wraith_core.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$WRAITH_DIR/wraith_core.sh"

for i in 1 2; do
  sudo -u "$STUDENT_USER" nohup bash -c \
    "exec -a wandering_wraith$i $WRAITH_DIR/wraith_core.sh" \
    >/dev/null 2>&1 &
done

# -------------------------------
# 4. Pyromancer (respawn parent)
# -------------------------------
echo "🔥 Awakening the Pyromancer..."

PYRO="$DUNGEON_DIR/pyromancer/pyromancer.sh"
cat << 'EOF' > "$PYRO"
#!/bin/bash
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
sudo -u "$STUDENT_USER" nohup "$PYRO" >/dev/null 2>&1 &

# -------------------------------
# 5. Inferno (cron persistence)
# -------------------------------
echo "🔥 Feeding the Inferno..."

INFERNO_DIR="$DUNGEON_DIR/inferno"
cat << 'EOF' > "$INFERNO_DIR/inferno_cron.sh"
#!/bin/bash
echo "🔥 Inferno roars at $(date)" >> "$HOME/trial_eternal_fire/inferno/inferno.log"
EOF

chmod +x "$INFERNO_DIR/inferno_cron.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$INFERNO_DIR/inferno_cron.sh"

sudo -u "$STUDENT_USER" crontab -l 2>/dev/null | grep -v inferno_cron.sh | sudo -u "$STUDENT_USER" crontab -
sudo -u "$STUDENT_USER" bash -c \
  "(crontab -l 2>/dev/null; echo '* * * * * \$HOME/trial_eternal_fire/inferno/inferno_cron.sh') | crontab -"

# -------------------------------
# 6. Hidden manuscript (passphrase clue)
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
# 7. Treasure (verification-gated)
# -------------------------------
echo "🗝️ Sealing the Flamebound Treasure..."

TREASURE_DIR="$DUNGEON_DIR/treasure"
cat << 'EOF' > "$TREASURE_DIR/disarm_treasure.sh"
#!/bin/bash

if pgrep -f "wraith_core.sh\|pyromancer.sh" >/dev/null; then
  echo "💀 Some wraiths still linger."
  exit 1
fi

if crontab -l 2>/dev/null | grep -q inferno_cron.sh; then
  echo "🔥 The Inferno still burns."
  exit 1
fi

echo "🗝️ The flames subside. The treasure is yours."
EOF

chmod +x "$TREASURE_DIR/disarm_treasure.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$TREASURE_DIR/disarm_treasure.sh"

# -------------------------------
# 8. Completion check
# -------------------------------
CHECK="$DUNGEON_DIR/check_trial.sh"
cat << 'EOF' > "$CHECK"
#!/bin/bash
echo "🔎 Verifying Trial of Eternal Fire..."

FAIL=0

pgrep -f wraith_core.sh >/dev/null && echo "❌ Wraiths remain" && FAIL=1
pgrep -f pyromancer.sh >/dev/null && echo "❌ Pyromancer remains" && FAIL=1
crontab -l 2>/dev/null | grep -q inferno_cron.sh && echo "❌ Inferno burns" && FAIL=1

if [[ $FAIL -eq 1 ]]; then
  echo "⚠️ Trial incomplete"
  exit 1
fi

echo "🏆 All trials cleared. You have mastered the Trial of Eternal Fire!"
EOF

chmod +x "$CHECK"
chown "$STUDENT_USER:$STUDENT_USER" "$CHECK"

# -------------------------------
# 9. Final message
# -------------------------------
clear
cat << EOF

🔥 The Trial of Eternal Fire is ready.

IMPORTANT:
  exec zsh

Then begin:
  cd ~/trial_eternal_fire
  ls

To verify completion:
  ./check_trial.sh

EOF