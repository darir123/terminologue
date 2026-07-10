# Terminologue VM

Run Terminologue TMS + Personal Website inside a portable Virtual Machine.

## Requirements

| Software | Download | Size |
|----------|----------|------|
| **VirtualBox** | https://www.virtualbox.org/wiki/Downloads | ~100 MB |
| **Vagrant** | https://developer.hashicorp.com/vagrant/downloads | ~200 MB |

## Quick Start

1. Install VirtualBox (Windows version)
2. Install Vagrant (Windows AMD64)
3. Double-click `start-vm.bat`
4. Wait 5-10 minutes (first boot only)
5. Access your services:
   - **Terminologue**: http://localhost:3000/
   - **Website**: http://localhost:8080/

## What's Inside the VM

- Ubuntu 22.04 LTS (lightweight server)
- Node.js 22 LTS
- Terminologue TMS (auto-starts on boot)
- Personal Website (auto-starts on boot)
- All data persists across reboots

## Login Credentials

| Service | Email | Password |
|---------|-------|----------|
| Terminologue | h.darir@uca.ac.ma | admin |

## VM Commands

| Command | Description |
|---------|-------------|
| `start-vm.bat` | Start the VM |
| `stop-vm.bat` | Stop the VM |
| `vagrant ssh` | SSH into the VM |
| `vagrant halt` | Stop VM |
| `vagrant up` | Start VM |
| `vagrant reload` | Restart VM |
| `vagrant destroy -f` | Delete VM (data lost!) |

## Port Mapping

| Host (Your PC) | Guest (VM) | Service |
|----------------|------------|---------|
| localhost:3000 | :3000 | Terminologue TMS |
| localhost:8080 | :8080 | Personal Website |

## Data Persistence

All data is stored in the VM. To backup:
```bash
vagrant ssh -c "cp -r /data ~/terminologue-data-backup"
```

## Troubleshooting

### VM won't start
- Ensure VirtualBox and Vagrant are installed
- Ensure virtualization is enabled in BIOS (Intel VT-x / AMD-V)

### Port already in use
- Check if local Terminologue is running: `taskkill /F /IM node.exe`
- Or change ports in Vagrantfile

### Slow first boot
- Normal: Ubuntu image (~500 MB) downloads on first run
- Subsequent starts take ~30 seconds
