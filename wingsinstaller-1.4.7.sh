#!/bin/bash
#!/usr/bin/env bash

########################################################################
#                                                                      #
#            Pterodactyl Wings Installer, Updater, Remover and More          #
#            Copyright 2022, Malthe K, <me@malthe.cc>                  #
# https://github.com/guldkage/Pterodactyl-Installer/blob/main/LICENSE  #
#                                                                      #
#  This script is not associated with the official Pterodactyl Panel.  #
#  You may not remove this line                                       #
#                                                                      #
########################################################################

### VARIABLES ###

SSL_CONFIRM=""
AGREEWINGS=""
SSLSTATUS=""
FQDN=""
AGREE=""
IP=""
DOMAIN=""
dist="$(. /etc/os-release && echo "$ID")"

### OUTPUTS ###

output(){
    echo -e '\e[36m'"$1"'\e[0m';
}

function trap_ctrlc ()
{
    output "Bye!"
    exit 2
}
trap "trap_ctrlc" 2

warning(){
    echo -e '\e[31m'"$1"'\e[0m';
}

### CHECKS ###

if [[ $EUID -ne 0 ]]; then
    output ""
    output "* ERROR *"
    output ""
    output "* Sorry, but you need to be root to run this script."
    output "* Most of the time this can be done by typing sudo su in your terminal"
    exit 1
fi

if ! [ -x "$(command -v curl)" ]; then
    output ""
    output "* ERROR *"
    output ""
    output "cURL is required to run this script."
    output "To proceed, please install cURL on your machine."
    output ""
    output "Debian based systems: apt install curl"
    output "CentOS: yum install curl"
    exit 1
fi

### Wings Install Start ###

installtwings(){
    output ""
    output "* AGREEMENT *"
    output ""
    output "The script will install Pterodactyl Wings."
    output "Do you want to continue?"
    output "(Y/N):"
    read -r AGREEWINGS

    if [[ "$AGREEWINGS" =~ [Yy] ]]; then
        AGREEWINGS=yes
        wingsdocker
    fi
}

### Docker ###

wingsdocker(){
    output ""
    output "Installing Docker..."
    if  [ "$dist" =  "ubuntu" ] || [ "$dist" =  "debian" ]; then
        curl -sSL https://get.docker.com/ | CHANNEL=stable bash
        systemctl enable --now docker
        wingsfiles
    elif  [ "$dist" =  "fedora" ] ||  [ "$dist" =  "centos" ] || [ "$dist" =  "rhel" ] || [ "$dist" =  "rocky" ] || [ "$dist" = "almalinux" ]; then
        output "OS not supported yet."
		exit 1
        fi
}

### Wings ###

wingsfiles(){
    output "Installing Wings Files..."
    if  [ "$dist" =  "ubuntu" ] || [ "$dist" =  "debian" ]; then
        mkdir -p /etc/pterodactyl || exit || output "An error occurred. Could not create directory." || exit
        apt-get -y install curl tar unzip
        curl -L -o /usr/local/bin/wings "https://github.com/pterodactyl/wings/releases/download/v1.4.7/wings_linux_amd64"
        curl -o /etc/systemd/system/wings.service https://raw.githubusercontent.com/shaikhnedab/Pterodactyl-Wings-Installer/main/configs/wings.service
        chmod u+x /usr/local/bin/wings
        clear
        output ""
        output "* WINGS SUCCESSFULLY INSTALLED *"
        output ""
        output "Thank you for using the script. Remember to give it a star."
        output "All you need is to set up Wings."
        output "To do this, create the node on your Panel, then press under Configuration,"
        output "press Generate Token, paste it on your server and then type systemctl enable wings --now"
        output ""
    elif  [ "$dist" =  "fedora" ] ||  [ "$dist" =  "centos" ] || [ "$dist" =  "rhel" ] || [ "$dist" =  "rocky" ] || [ "$dist" = "almalinux" ]; then
        output "OS not supported yet."
		exit 1
    fi
}

### Swap Space ###

enableswap(){
    output ""
    output "Enabling Swap Space..."
    if  [ "$dist" =  "ubuntu" ] || [ "$dist" =  "debian" ]; then
        sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT=""/GRUB_CMDLINE_LINUX_DEFAULT="swapaccount=1"/g' /etc/default/grub
        sudo update-grub
    warning "Please restart your system to complete the process."
    elif  [ "$dist" =  "fedora" ] ||  [ "$dist" =  "centos" ] || [ "$dist" =  "rhel" ] || [ "$dist" =  "rocky" ] || [ "$dist" = "almalinux" ]; then
        output "OS not supported yet."
		exit 1
        fi
}

### SSL ###

ssl(){
    output ""
    output "* SSL * "
    output ""
    output "Do you want to use SSL? It requires a domain."
    output "SSL encrypts all data compared to HTTP which does not. SSL is always recommended."
    output "If you do not have a domain and want to use an IP to access, please type N, as you can not have SSL on a IP this easy."
    output "(Y/N):"
    read -r SSL_CONFIRM

    if [[ "$SSL_CONFIRM" =~ [Yy] ]]; then
        SSLSTATUS=true
        emailsslyes
    fi
    if [[ "$SSL_CONFIRM" =~ [Nn] ]]; then
        emailsslno
        SSLSTATUS=false
    fi
}

### SSL select yes ##

emailsslyes(){
    output ""
    output "* EMAIL *"
    output ""
    warning "Read:"
    output "The script now asks for your email. It will be shared with Lets Encrypt to complete the SSL."
    output "If you do not agree, stop the script."
    warning ""
    output "Please enter your email"
    read -r EMAIL
    fqdn
}

### SSL select no ###

emailsslno(){
    output ""
    output "* EMAIL *"
    output ""
    warning "Read:"
    output "The script now asks for your email. It will be used to setup the Panel."
    output "If you do not agree, stop the script."
    warning ""
    output "Please enter your email"
    read -r EMAIL
    fqdn
}

### FQDN ###

fqdn(){
    output ""
    output "Enter your wings FQDN."
    output "Make sure that your FQDN is pointed to your IP with an A record. If not the script will not be able to provide the webpage."
    read -r FQDN
    [ -z "$FQDN" ] && output "FQDN can't be empty."
    IP=$(dig +short myip.opendns.com @resolver2.opendns.com -4)
    DOMAIN=$(dig +short ${FQDN})
    if [ "${IP}" != "${DOMAIN}" ]; then
        output ""
        output "Your FQDN does not resolve to the IP of current server."
        output "Please point your servers IP to your FQDN."
        continueanyway
    else
        output "Your FQDN is pointed correctly. Continuing."
        required
    fi
}

continueanyway(){
    output ""
    output "This error can sometimes be false positive."
    output "Do you want to continue anyway?"
    output "(Y/N):"
    read -r CONTINUE_ANYWAY

    if [[ "$CONTINUE_ANYWAY" =~ [Yy] ]]; then
        required
    fi
    if [[ "$CONTINUE_ANYWAY" =~ [Nn] ]]; then
        exit 1
    fi
}

required(){
    output ""
    output "* INSTALLATION * "
    output ""
    output "Installing packages..."
    output "This may take a while."
    output ""
    if  [ "$dist" =  "ubuntu" ] || [ "$dist" =  "debian" ]; then
        apt-get update
        apt -y install software-properties-common curl apt-transport-https ca-certificates gnupg nginx
        output "Installing dependencies"
        sleep 1s
        apt update
        apt-add-repository universe
        apt install certbot python3-certbot-nginx -y
        installssl
		
    elif  [ "$dist" =  "fedora" ] ||  [ "$dist" =  "centos" ] || [ "$dist" =  "rhel" ] || [ "$dist" =  "rocky" ] || [ "$dist" = "almalinux" ]; then
        output "OS not supported yet."
		exit 1
        fi
}

### SSL Certificate ###

installssl(){
    output ""
    output "Installing SSL Certificate..."
    output ""
    if  [ "$dist" =  "ubuntu" ] || [ "$dist" =  "debian" ]; then
		output ""		
        systemctl stop nginx
        certbot certonly --standalone -d $FQDN --staple-ocsp --no-eff-email -m $EMAIL --agree-tos
        systemctl start nginx
    output "Let's Encrypt certificate have been successfully installed."
#        wingsfiles
    elif  [ "$dist" =  "fedora" ] ||  [ "$dist" =  "centos" ] || [ "$dist" =  "rhel" ] || [ "$dist" =  "rocky" ] || [ "$dist" = "almalinux" ]; then
        output "OS not supported yet."
		exit 1
        fi
}

### Update Wings ###

updatewings(){
    if ! [ -x "$(command -v wings)" ]; then
        echo 'Wings is required to update.' >&2
    else
    curl -L -o /usr/local/bin/wings https://github.com/pterodactyl/wings/releases/latest/download/wings_linux_amd64
    chmod u+x /usr/local/bin/wings
    systemctl restart wings
    output ""
    output "* SUCCESSFULLY UPDATED *"
    output ""
    output "Wings has successfully updated."
    output ""
    fi
}

### Uninstall Wings ###

uninstallwings(){
    output ""
    output "Do you really want to delete Pterodactyl Wings? All game servers & configurations will be deleted. You CANNOT get your files back."
    output "(Y/N):"
    read -r UNINSTALLWINGS

    if [[ "$UNINSTALLWINGS" =~ [Yy] ]]; then
        sudo systemctl stop wings # Stops wings
        sudo rm -rf /var/lib/pterodactyl # Removes game servers and backup files
        sudo rm -rf /etc/pterodactyl  || exit || warning "Pterodactyl Wings not installed!"
        sudo rm /usr/local/bin/wings || exit || warning "Wings is not installed!" # Removes wings
        sudo rm /etc/systemd/system/wings.service # Removes wings service file
        output ""
        output "* WINGS SUCCESSFULLY UNINSTALLED *"
        output ""
        output "Wings has been removed."
        output ""
    fi
}

### Renews certificates ###

renewcertificates(){
    sudo certbot renew
    output ""
    output "* RENEW CERTIFICATES * "
    output ""
    output "All Let's Encrypt certificates that were ready to be renewed have been renewed."
    output ""
}

### Check Wings Status ###

wingsstatus(){
if ! [ -x "$(command -v wings)" ]; then
  echo 'Error: git is not installed.' >&2
else
  echo 'Error: git is installed.'
  exit 1
fi


}

### OS Check ###

oscheck(){
    output "* Checking your OS.."
    if  [ "$dist" =  "ubuntu" ] ||  [ "$dist" =  "debian" ]; then
        output "* Your OS, $dist, is fully supported. Continuing.."
        output ""
        options
    elif  [ "$dist" =  "fedora" ] ||  [ "$dist" =  "centos" ] || [ "$dist" =  "rhel" ] || [ "$dist" =  "rocky" ] || [ "$dist" = "almalinux" ]; then
        output "* Your OS, $dist, is not fully supported."
        output "* Installations may work, but there is no gurrantee."
        output "* Continuing in 5 seconds. CTRL+C to stop."
        output ""
        sleep 5s
        options
    else
        output "* Your OS, $dist, is not supported!"
        output "* Exiting..."
        exit 1
    fi
}

### Options ###

options(){
    output "Please select your installation option:"
    warning "[1] Install Wings. | Installs latest version of Pterodactyl Wings."
    warning ""
    warning "[2] Install SSL Certificate (This option will Install nginx webserver to acquire SSL Certificate)."
    warning ""
    warning "[3] Enable swap to prevent OOM errors.."
    warning ""
    warning "[4] Update Wings. | Updates your Wings to the latest version."
    warning ""
    warning "[5] Uninstall Wings. | Uninstalls your Wings. This will also remove all of your game servers (Only uninstalls wings and leaves docker untouched)."
    warning ""
    warning "[6] Renew Certificates | Renews all Lets Encrypt certificates on this machine."
    warning ""
    read -r option
    case $option in
        1 ) option=1
            installtwings
            ;;
        2 ) option=2
            ssl
            ;;
        3 ) option=3
            enableswap
            ;;
        4 ) option=4
            updatewings
            ;;
        5 ) option=5
            uninstallwings
            ;;
        6 ) option=6
            renewcertificates
            ;;
        * ) output ""
            output "Please enter a valid option from 1-4"
    esac
}

### Start ###

clear
output ""
warning "Pterodactyl Wings Installer @ v1.0"
warning "https://github.com/shaikhnedab/Pterodactyl-Wings-Installer"
warning ""
warning "This script is not responsible for any damages. The script has been tested several times without issues."
warning "Support is not given."
warning "This script will only work on a fresh installation. Proceed with caution if not having a fresh installation"
warning ""
warning "You are very welcome to report errors or bugs about this script. These can be reported on GitHub."
warning "Thanks in advance!"
warning ""
oscheck