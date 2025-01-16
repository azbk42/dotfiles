#!/bin/bash

set -e

echo ">>> Restauration du profil GNOME Terminal"

# Vérifie si dconf est installé
if ! command -v dconf &> /dev/null
then
    echo ">>> dconf n'est pas installé. Installation en cours..."

    # Vérifie le gestionnaire de paquets disponible
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y dconf-cli
    elif command -v yum &> /dev/null; then
        sudo yum install -y dconf-cli
    elif command -v pacman &> /dev/null; then
        sudo pacman -Sy --noconfirm dconf
    else
        echo ">>> Impossible de détecter le gestionnaire de paquets. Installe dconf manuellement et relance le script."
        exit 1
    fi

    echo ">>> dconf installé avec succès."
else
    echo ">>> dconf est déjà installé."
fi

# Charge le profil depuis le fichier sauvegardé
if [ -f "terminal-setup/gnome-terminal-profiles.dconf" ]; then
    dconf load /org/gnome/terminal/ < terminal-setup/gnome-terminal-profiles.dconf
    echo ">>> Profil GNOME Terminal restauré avec succès !"
else
    echo ">>> Le fichier gnome-terminal-profiles.dconf est introuvable. Place-le dans le même dossier que ce script et réessaie."
    exit 1
fi


