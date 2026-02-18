# 👹 Ghost Watch III: The Firewarden’s Chant

## Overview

The Firewarden’s Chant is a ritual bound not to a shell, but to the cathedral of systemd itself. Slay the visible process and it rises again. Log out, and still it whispers. The flame is not wild. It is supervised.

To silence the chant, you must move beyond killing processes and confront the service manager that sustains it.

This dungeon emphasizes modern Linux persistence through **systemd user services** and the hidden power of lingering sessions.

---

## Skills Practiced

- Inspecting user-level systemd units with `systemctl --user`
- Distinguishing between active and enabled services
- Understanding `[Service]` directives such as `Restart=always`
- Investigating service behavior using `journalctl --user`
- Identifying service file locations in `~/.config/systemd/user`
- Understanding user lingering and its effect on persistence
- Safely stopping and disabling services to break automatic respawn
- Extracting and decrypting multi-layered hints from archives
- Applying structured investigation instead of brute-force process killing

---

# 🔥 Setup Instructions

Open a terminal.

Download the setup script:

```bash
wget -O setup_firewarden.sh https://raw.githubusercontent.com/dahays/Linux-Dungeon-Crawls/main/setup_firewarden.sh
```
Make it executable:

```bash
chmod +x setup_firewarden.sh
```
Run the installer script:

```bash
sudo ./setup_firewarden.sh
```
Enter the dungeon directory to begin:

```bash
cd firewarden_chant
```

🏆 Check Success
A chant properly silenced leaves no echo.

```bash
./check_firewarden.sh
```
A true victory confirms:

✔ Service stopped

✔ Startup disabled

🏆 LEVEL 6 COMPLETE

If the flame returns, something higher still commands it.
