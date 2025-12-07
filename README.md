## Installation Instructions

1. Install Linux Distro (i.e. Arch Linux, Ubuntu, Debian, Fedora)
1. Create user...
2. Restore linux_goodness (Xresources, etc.)
3. Config Display Manager
	- gdm/gnome_shell/nautilus/gnome-control-center/networkmanager?,etc... (suspend/resume works out of the box (twss, lol)?)
or 
	- lightdm/i3/i3lock/suspend/resume (PM/ACPI - upowerd)
4. Config AppArmor, SELinux or cleverly configure the Display Manager and launch applications from individual users to isolate cookies and workspace folders (only select applications can access those files)
	- cookies == edge and git
	- software_workspace == vscode, vim (xterm?)
	- hardware_workspace == kicad
5. Symlink configuration files in misc, systemd and other folders to appropriate locations.
	- Make sure permissions are set properly... i.e. system services should only be accessibile by the root user.

***** see package manifest below for list of packages to install... *****

## Installation Instructions from Backup 

1. BOOT with live CD.
2. Create partitions:
	/boot
	/
	/swap
3. Mount partitions (configure swap?)
4. Extract distro tar file.
    -- tar -xvzf <tar_file>.tar.gz -C <mounted_root_dir>
5. chroot
6. edit grub.cfg, /etc/fstab to use new drive GUIDs

## GNOME config

- Accessibility
	- Reduce animation = ON
- Privacy & Security
	- Screen Lock
		- Blank Screen Delay = 5 minutes
		- Automatic Screen Lock = ON
		- Automatic Screen Lock Delay = Screen Turns Off 
		- Lock Screen Notifications = ON

... also review all options and use common sense lol.

### Tiles supported by GNOME by default

- Half Horizontal Left
	- <Super>Left
- Half Horizontal Right
	- <Super>Right
- "Full"
	- <Super>Up
- Undo tile/Float
	- <Super>Down

### gTile extension

- Eighthsies
	- \<Control\>\<Super\>Left
		- 4x2 1:1 1:1, 1:2 1:2, 1:1 1:2, 1:1 2:1, 1:1 2:2, 2:1 2:1, 2:2 2:2, 2:1 2:2, 2:1 3:1, 2:1 3:2, 3:1 3:1, 3:2 3:2, 3:1 3:2, 3:1 4:1, 3:1 4:2, 4:1 4:1, 4:2 4:2, 4:1 4:2
- Sixthsies
	- \<Control\>\<Super\>Right
		- 3x2 1:1 1:1, 1:2 1:2, 1:1 1:2, 1:1 2:1, 1:1 2:2, 2:1 2:1, 2:2 2:2, 2:1 2:2, 2:1 3:1, 2:1 3:2, 3:1 3:1, 3:2 3:2, 3:1 3:2

## TODO

- [ ] clean this up...
- [ ] add more detail
- [ ] zsh?

## ArchLinux Package Names
```
perl
sudo
git
meld
nvidia
gdm
nautilus
gnome-control-center
apparmor
vim
qemu
```
