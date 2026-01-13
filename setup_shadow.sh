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

MANUSCRIPT="$HINT_DIR/wraith_riddle.txt"
cat << 'EOF' > "$MANUSCRIPT"
What you see is not real
Trace the shadows to their source
Preload the truth from the library
Decrypted layers reveal the knowledge
EOF

# GPG encrypt
gpg --batch --yes --passphrase "WRAITH" -c "$MANUSCRIPT"

# First archive
tar -czf "$HINT_DIR/wraith_hint.tar.gz" -C "$HINT_DIR" wraith_riddle.txt.gpg

# Second archive
zip -q "$HINT_DIR/wraith_hint.zip" "$HINT_DIR/wraith_hint.tar.gz"

rm "$MANUSCRIPT" "$HINT_DIR/wraith_hint.tar.gz" "$HINT_DIR/wraith_riddle.txt.gpg"

chown "$STUDENT_USER:$STUDENT_USER" "$HINT_DIR/wraith_hint.zip"
chmod 600 "$HINT_DIR/wraith_hint.zip"

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

echo "👻 Shadow of the Wraith ready with multi-layered hint at $HINT_DIR/wraith_hint.zip"
