#!/bin/bash

# ======================================
# Linux Dungeon Crawl I
# The Sunken Vault
# Intro to Navigation, Files & Processes
# ======================================

set -e

echo "🏰 Constructing the Sunken Vault... 🌊"

BASE_DIR="$HOME/dungeon_level1"
VAULT_DIR="$BASE_DIR/sunken_vault"

mkdir -p "$VAULT_DIR"

# -------------------------------------------------
# Strange Manuscript (INTRO)
# -------------------------------------------------
cat << 'EOF' > "$BASE_DIR/strange_manuscript.txt"
📜 STRANGE MANUSCRIPT 📜

Adventurer,

A forgotten vault rests beneath the waves.

To claim its treasure, you must:
- Navigate the filesystem
- Read hidden clues
- Discover concealed files
- Eliminate a lurking process
- Execute a script to disable the vault’s defenses
- Unlock an encrypted artifact

Your journey begins at:
    start_here.txt

— The Keeper of the Vault
EOF

# -------------------------------------------------
# Sneaky Ghost Pirate Process
# -------------------------------------------------
echo "#!/bin/bash" > /tmp/ghost_pirate.sh
echo "sleep 3600" >> /tmp/ghost_pirate.sh
chmod +x /tmp/ghost_pirate.sh
/tmp/ghost_pirate.sh &

# -------------------------------------------------
# Directory Structure
# -------------------------------------------------
mkdir -p "$VAULT_DIR/old_fort/shipwrecks"
mkdir -p "$VAULT_DIR/cave/deep_cave"
mkdir -p "$VAULT_DIR/palm_tree/dig_here"

# -------------------------------------------------
# Clues
# -------------------------------------------------
echo "CLUE 1: Begin in the 'old_fort'." > "$VAULT_DIR/start_here.txt"
echo "CLUE 2: Seek a captain's name." > "$VAULT_DIR/old_fort/README"
echo "CLUE 3: Hidden things are not always visible..." > "$VAULT_DIR/old_fort/captain_blackbeard.txt"
echo "Squawk... the treasure lies beneath the palm..." > "$VAULT_DIR/old_fort/.parrot_notes"
echo "The key word is: adventure" > "$VAULT_DIR/cave/deep_cave/poem.txt"
echo "CLUE 4: The treasure is locked in '.X'. Run the provided script to disarm it." > "$VAULT_DIR/palm_tree/dig_here/clue.txt"
echo "CLUE 5: A ghost pirate process guards the vault. Eliminate it." > "$VAULT_DIR/cave/deep_cave/guard_duty.txt"

# -------------------------------------------------
# Create Treasure (WITH ASCII CHEST)
# -------------------------------------------------
cat << 'EOF' > "$VAULT_DIR/palm_tree/dig_here/treasure.txt"

          |                   |                  |                     |
 _________|________________.=""_;=.______________|_____________________|_______
|                   |  ,-"_,=""     `"=.|                  |
|___________________|__"=._o`"-._        `"=.______________|___________________
          |                `"=._o`"=._      _`"=._                     |
 _________|_____________________:=._o "=._."_.-="'"=.__________________|_______
|                   |    __.--" , ; `"=._o." ,-"""-._ ".   |
|___________________|_._"  ,. .` ` `` ,  `"-._"-._   ". '__|___________________
          |           |o`"=._` , "` `; .". ,  "-._"-._; ;              |
 _________|___________| ;`-.o`"=._; ." ` '`."\` . "-._ /_______________|_______
|                   | |o;    `"-.o`"=._``  '` " ,__.--o;   |
|___________________|_| ;     (#) `-.o `"=.`_.--"_o.-; ;___|___________________
____/______/______/___|o;._    "      `".o|o_.--"    ;o;____/______/______/____
/______/______/______/_"=._o--._        ; | ;        ; ;/______/______/______/
____/______/______/______/__"=._o--._   ;o|o;     _._;o;____/______/______/____
/______/______/______/______/____"=._o._; | ;_.--"o.--"_/______/______/______/
____/______/______/______/______/_____"=.o|o_.--""___/______/______/______/____
/______/______/______/______/______/______/______/______/______/______/

💰 TREASURE RECOVERED 💰
You have conquered the Sunken Vault!

EOF

# -------------------------------------------------
# Encrypt Treasure
# -------------------------------------------------
gpg --batch --yes --passphrase "adventure" \
-c -o "$VAULT_DIR/palm_tree/dig_here/.X" \
"$VAULT_DIR/palm_tree/dig_here/treasure.txt"

chmod 000 "$VAULT_DIR/palm_tree/dig_here/.X"
rm "$VAULT_DIR/palm_tree/dig_here/treasure.txt"

# -------------------------------------------------
# Alarm Script
# -------------------------------------------------
cat << 'EOF' > "$VAULT_DIR/palm_tree/dig_here/disarm_alarm.sh"
#!/bin/bash

if pgrep -f "ghost_pirate.sh" > /dev/null; then
    echo "❌ The ghost pirate still lingers..."
    exit 1
else
    echo "✅ The vault grows silent... unlocking..."
    chmod 400 .X
fi
EOF

chmod +x "$VAULT_DIR/palm_tree/dig_here/disarm_alarm.sh"

# -------------------------------------------------
# Check Script
# -------------------------------------------------
cat << 'EOF' > "$BASE_DIR/check_sunken_vault.sh"
#!/bin/bash

echo "🔍 Checking dungeon completion..."

if pgrep -f "ghost_pirate.sh" > /dev/null; then
    echo "❌ Ghost pirate still alive."
    exit 1
fi

if [ ! -r "$HOME/dungeon_level1/sunken_vault/palm_tree/dig_here/.X" ]; then
    echo "❌ Treasure still locked."
    exit 1
fi

echo "✅ Vault cleared. Treasure recovered!"
EOF

chmod +x "$BASE_DIR/check_sunken_vault.sh"

# -------------------------------------------------
# Finish
# -------------------------------------------------
clear
echo "🏴‍☠️ The Sunken Vault awaits..."
echo "📜 Read strange_manuscript.txt to begin."

rm -- "$0"