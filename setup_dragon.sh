#!/bin/bash

# --- Dragon Cron Persistence Setup ---

DUNGEON=dragon_cron
mkdir -p $DUNGEON/{lair,logs,clues}
cd $DUNGEON || exit 1

# Create the dragon script
cat << 'EOF' > /usr/local/bin/dragon_heartbeat.sh
#!/bin/bash
echo "$(date): The dragon stirs..." >> /tmp/dragon.log
EOF

chmod +x /usr/local/bin/dragon_heartbeat.sh

# Install cron job (every minute)
echo "* * * * * /usr/local/bin/dragon_heartbeat.sh" > /etc/cron.d/dragon

# Create clue files
echo "CLUE 1: The dragon never sleeps. Something runs every minute." > clues/start_here.txt
echo "CLUE 2: Fire leaves smoke. Smoke leaves logs." > clues/ash_and_smoke.txt
echo "CLUE 3: The beast lives in a place common tools hide." > clues/where_dragons_hide.txt

# Fake log hint
echo "$(date): CRON[9999]: (root) CMD (/usr/local/bin/dragon_heartbeat.sh)" >> /var/log/syslog

# Victory condition script
cat << 'EOF' > lair/check_dragon.sh
#!/bin/bash
if [ -f /etc/cron.d/dragon ]; then
    echo "The dragon still lives. The realm is not safe."
    exit 1
else
    echo "The dragon has been slain. The realm is at peace."
fi
EOF

chmod +x lair/check_dragon.sh

clear
echo "Dragon dungeon prepared. Enter the lair if you dare."
rm -- "$0"
