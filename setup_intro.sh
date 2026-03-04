#!/bin/bash
# ======================================
# Linux Dungeon Crawl I
# The First Door
# Intro to Navigation & File Manipulation
# ======================================

set -e

echo "🏰 Preparing the Dungeon Entrance..."

BASE_DIR="$HOME/dungeon_intro"
DOOR_DIR="$BASE_DIR/closed_door"

mkdir -p "$DOOR_DIR"

# -------------------------------------------------
# Create the Manuscript
# -------------------------------------------------
cat << 'EOF' > "$BASE_DIR/strange_manuscript"

🜂 The First Door 🜂

Adventurer,

Before you lies a sealed chamber. The path forward is not barred by force,
but by understanding.

You stand in a place called dungeon_intro.

Within it rests a door that is closed.

Your journey begins when the door opens.

Rename the chamber called closed_door so that it reflects its new state.

When the door stands opened, construct three additional rooms:

• armory
• treasury
• laboratory

The laboratory is a place of transformation.

Inside opened_door, forge a new scroll named:
apprentice_notes.txt

Write these exact words within the scroll:

"I have opened the door."

Do not abandon the original.
Make a copy of apprentice_notes.txt and place the copy inside the laboratory.

Then, take the original scroll,
rename it to alchemical_draft.txt,
and move it into the laboratory as well.

Enter the laboratory.

Inside alchemical_draft.txt,
add the following line beneath what already exists:

"The experiment begins."

When your mixing is complete:

Send apprentice_notes.txt to the treasury.
Send alchemical_draft.txt to the armory.

When the laboratory is empty of artifacts,
destroy it completely.
Leave no trace.

If done correctly:

• The laboratory will no longer exist.
• The treasury will contain apprentice_notes.txt
• The armory will contain alchemical_draft.txt

This is your first lesson:

Doors may be opened.
Rooms may be built.
Knowledge may be copied.
Work may be moved.
And empty chambers may be removed.

Master these, and deeper dungeons will yield.

🜂 The Crawl Has Begun 🜂

EOF

# -------------------------------------------------
# Create Verification Script
# -------------------------------------------------
cat << 'EOF' > "$BASE_DIR/check_intro.sh"
#!/bin/bash

BASE_DIR="$HOME/dungeon_intro"

PASS=true

echo "🔎 Inspecting the Dungeon..."

# 1. Door renamed
if [ -d "$BASE_DIR/opened_door" ] && [ ! -d "$BASE_DIR/closed_door" ]; then
    echo "✔ Door has been opened."
else
    echo "✘ The door remains improperly named."
    PASS=false
fi

# 2. Required rooms exist
for ROOM in armory treasury; do
    if [ -d "$BASE_DIR/$ROOM" ]; then
        echo "✔ $ROOM exists."
    else
        echo "✘ $ROOM is missing."
        PASS=false
    fi
done

# 3. Laboratory destroyed
if [ ! -d "$BASE_DIR/laboratory" ]; then
    echo "✔ Laboratory has been destroyed."
else
    echo "✘ Laboratory still stands."
    PASS=false
fi

# 4. Files in correct locations
if [ -f "$BASE_DIR/treasury/apprentice_notes.txt" ]; then
    echo "✔ apprentice_notes.txt rests in the treasury."
else
    echo "✘ apprentice_notes.txt not found in treasury."
    PASS=false
fi

if [ -f "$BASE_DIR/armory/alchemical_draft.txt" ]; then
    echo "✔ alchemical_draft.txt rests in the armory."
else
    echo "✘ alchemical_draft.txt not found in armory."
    PASS=false
fi

# 5. Content verification
if grep -q "I have opened the door." "$BASE_DIR/armory/alchemical_draft.txt" 2>/dev/null &&
   grep -q "The experiment begins." "$BASE_DIR/armory/alchemical_draft.txt" 2>/dev/null; then
    echo "✔ Alchemical draft contains proper inscription."
else
    echo "✘ Alchemical draft content incorrect."
    PASS=false
fi

if $PASS; then
    echo ""
    echo "🏆 LEVEL 1 COMPLETE"
else
    echo ""
    echo "⚠ The dungeon remains unconquered."
fi
EOF

chmod +x "$BASE_DIR/check_intro.sh"

echo "🗝 The dungeon has been prepared."
echo "📜 Read strange_manuscript inside ~/dungeon_intro to begin."
echo "🔎 When finished, run: ./check_intro.sh"