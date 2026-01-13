# 🕯 Firewarden’s Chant
## Overview

The Firewarden’s Chant is a persistent ritual managed by a systemd user service. Killing the service process does not end the ritual; it will restart automatically. Students must investigate the service, identify how it maintains persistence, and disable it at the source.

This dungeon emphasizes understanding modern Linux service management and user-level persistence.

**Skills Practiced**

- Inspecting user-level systemd units with systemctl --user
- Understanding service configuration files and the role of [Service] directives
- Safely stopping and disabling services to break persistence
- Using forensic-style analysis to trace the source of automatic respawns
- Extracting and decrypting multi-layered hints from archives
- Developing structured problem-solving for persistent threats
