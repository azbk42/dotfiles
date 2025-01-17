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

# Vérifie si le fichier de configuration GNOME Terminal existe
if [ -f "terminal-setup/gnome-terminal-profiles.dconf" ]; then
    echo ">>> Chargement du profil GNOME Terminal..."
    dconf load /org/gnome/terminal/ < terminal-setup/gnome-terminal-profiles.dconf
    echo ">>> Profil GNOME Terminal restauré avec succès !"
else
    echo ">>> Le fichier gnome-terminal-profiles.dconf est introuvable. Place-le dans le même dossier que ce script et réessaie."
    exit 1
fi

# Installe un fond d'écran si ce n'est pas déjà configuré
BACKGROUND_PATH="$HOME/.local/share/backgrounds/skull.jpg"
if [ ! -f "$BACKGROUND_PATH" ]; then
    echo ">>> Installation du fond d'écran..."
    mkdir -p ~/.local/share/backgrounds
    cp "$(pwd)/skull.jpg" "$BACKGROUND_PATH"
    gsettings set org.gnome.desktop.background picture-uri "file://$BACKGROUND_PATH"
    echo ">>> Fond d'écran installé avec succès !"
else
    echo ">>> Le fond d'écran est déjà installé."
fi

# Vérifie si Oh My Zsh est installé
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo ">>> Oh My Zsh est déjà installé."
else
    echo ">>> Oh My Zsh n'est pas installé. Installation en cours..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    # Vérifie si l'installation a réussi
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo ">>> Oh My Zsh a été installé avec succès."
    else
        echo ">>> Échec de l'installation d'Oh My Zsh. Vérifiez votre connexion ou les permissions."
        exit 1
    fi
fi


rm ~/.zshrc
cp zsh/.zshrc ~/.zshrc

