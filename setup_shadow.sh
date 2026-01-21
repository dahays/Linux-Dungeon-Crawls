#!/bin/bash
# ======================================
# Ghost Watch III: Shadow of the Wraith
# Level 8 - LD_PRELOAD persistence
# ======================================

set -e
set -o pipefail

echo "👻 Conjuring Shadow of the Wraith..."

STUDENT_USER="$SUDO_USER"
STUDENT_HOME="$(getent passwd "$STUDENT_USER" | cut -d: -f6)"

LD_DIR="$STUDENT_HOME/wraith_shadow"
mkdir -p "$LD_DIR"

# Library
cat << 'EOF' > "$LD_DIR/wraith.c"
#include <stdio.h>
#include <stdlib.h>

int puts(const char *s) {
    fprintf(stderr, "🕸️ Shadowed: %s\n", s);
    return 0;
}
EOF

cd "$LD_DIR"
gcc -fPIC -shared -o libwraith.so wraith.c
chown "$STUDENT_USER:$STUDENT_USER" libwraith.so

# Set LD_PRELOAD
RC_FILE="$STUDENT_HOME/.bashrc"
grep -q "LD_PRELOAD=wraith_shadow" "$RC_FILE" || cat << EOF >> "$RC_FILE"

# --- Shadow of the Wraith ---
export LD_PRELOAD=$LD_DIR/libwraith.so
EOF
chown "$STUDENT_USER:$STUDENT_USER" "$RC_FILE"

# -------------------------------
# Cryptic Hint
# -------------------------------
HINT_DIR="$LD_DIR/.hints"
mkdir -p "$HINT_DIR"

MANUSCRIPT="$HINT_DIR/strange_manuscript"
cat << 'EOF' > "$MANUSCRIPT"
You notice an old faded parchment tucked away in the lair. It reads:

What you see is not real
Trace the shadows to their source
Preload the truth from the library
Decrypted layers reveal the knowledge
EOF

# GPG encrypt (no extension)
gpg --batch --yes --passphrase "WRAITH" -c -o "$HINT_DIR/ember_core" "$MANUSCRIPT"

# First archive: tar (no extension)
tar -czf "$HINT_DIR/ashen_shell" -C "$HINT_DIR" ember_core

# Second archive: zip (no extension)
zip -q "$HINT_DIR/faded_relic" "$HINT_DIR/ashen_shell"

# Cleanup
rm "$MANUSCRIPT" "$HINT_DIR/ashen_shell" "$HINT_DIR/ember_core"

chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR/faded_relic"
chmod 600 "$HINT_DIR/faded_relic"

# -------------------------------
# Verification
cat << 'EOF' > "$LD_DIR/check_ldpreload.sh"
#!/bin/bash
if [[ -n "$LD_PRELOAD" ]]; then
  echo "❌ Wraith still shadows commands"
  exit 1
fi
echo "✔ Shadow removed"
echo "🏆 LEVEL 8 COMPLETE"
EOF
chmod +x "$LD_DIR/check_ldpreload.sh"
chown "$STUDENT_USER:$STUDENT_USER" "$LD_DIR/check_ldpreload.sh"

# -------------------------------
# 8. Final instructions
# -------------------------------
cat << EOF

🌑 SHADOW OF THE WRAITH READY

✔ Installed for user: $STUDENT_USER
✔ Dungeon located at: ~/shadow_wraith
✔ The system speaks with borrowed voices

To begin:
  cd ~/shadow_wraith

To verify victory:
  ./check_wraith.sh

The output lies.
The tools comply.
Truth emerges only
when the world is stripped bare.
