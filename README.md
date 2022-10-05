# Pterodactyl Wings Installer

With this script you can easily install, update or delete Pterodactyl Wings. Everything is gathered in one script.
Use this script if you want to install, update or delete your services quickly. The things that are being done are already listed on [Pterodactyl](https://pterodactyl.io/), but this clearly makes it faster since it is automatic.

Please note that this script is made to work on a fresh installation. There is a good chance that it will fail if it is not a fresh installation.
The script must be run as root.

If you find any errors, things you would like changed or queries for things in the future for this script, please write an "Issue".
Read about [Pterodactyl](https://pterodactyl.io/) here. This script is not associated with the official Pterodactyl Project.

## Features
This script is one of the only ones that has a well-functioning Switch Domains feature.

- Install Wings
- Update Wings
- Uninstall Wings
- Install SSL Certificate
- Enable Swap Space

## Supported webservers & OS
Supported operating systems.

- Debian based systems (Disclaimer: Please use Ubuntu system if possible. Debian may have issues with APT repositories.)
- (Other systems are not supported right now.)
- Nginx webserver, please bear with me that Apache is not supported. A decision made by me.

## Copyright
All rights of this script is [guldkage](https://github.com/guldkage/Pterodactyl-Installer) and being edited by [shaikhnedab](https://github.com/shaikhnedab)

## Support
The script has been tested many times without any bug fixes, however they can still occur.
If you find errors, feel free to open an "Issue" on GitHub.

# Run the script
Nearly all systems supports this
```bash
bash <(curl -s https://raw.githubusercontent.com/shaikhnedab/Pterodactyl-Wings-Installer/main/wingsinstaller.sh)
```
