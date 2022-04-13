![Logo Image](https://github.com/guldkage/Pterodactyl-Installer/blob/main/configs/installer.png?raw=true)


# Pterodactyl Installer

With this script you can easily install, update and delete Pterodactyl Panel. Everything is gathered in one script.
Use this script if you want to install, update or delete your services quickly. The things that are being done are already listed on [Pterodactyl](https://pterodactyl.io/), but this clearly makes it faster since it is automatic.

Please note that this script is made to work on a fresh installation. There is a good chance that it will fail if it is not a fresh installation.
The script must be run as root.

If you find any errors, things you would like changed or queries for things in the future for this script, please write an "Issue".
Read about [Pterodactyl](https://pterodactyl.io/) here. This script is not associated with the official Pterodactyl Project.

## Features
- Install Panel
- Install Wings
- Install PHPMyAdmin
- Switch Pterodactyl Domains
- Update Panel
- Update Wings
- Uninstall Panel
- Uninstall Wings

## Supported webservers & OS
- Debian based systems
- (You can may use the script with other systems, it is only half supported right now.)
- Nginx webserver

## Support
No support is offered for this script.
The script has been tested many times without any bug fixes, however they can still occur.
If you find errors, feel free to open an "Issue" on GitHub.

# Run the script
Nearly all systems supports this
```bash
bash <(curl -s https://raw.githubusercontent.com/guldkage/Pterodactyl-Installer/main/installer.sh)
```

### Raspbian
Only for raspbian users. They might need a extra < in the beginning.
```bash
bash < <(curl -s https://raw.githubusercontent.com/guldkage/Pterodactyl-Installer/main/installer.sh)
```
