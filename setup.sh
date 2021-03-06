#!/bin/bash
current=$(pwd)

echo "Setup-Script Started"

echo "Generating GitConfig"
sh bin/generate_gitconfig.sh

echo "Setting up: zshrc"
ln -sf $current/zshrc ~/.zshrc

echo "Setting up: gitconfig"
ln -sf $current/gitconfig ~/.gitconfig

echo "Setting up: vim"
ln -sf $current/vimrc ~/.vimrc
cp -r $current/vim ~/vim
rm -r ~/.vim
mv ~/vim ~/.vim

echo "Setting up: prelude"
mkdir ~/.emacs.d
mkdir ~/.emacs.d/personal
ln -s $current/emacs_personal ~/.emacs.d/personal

echo "Setting up: sbt plugins"
sbt_plugins_path=~/.sbt/1.0/plugins
mkdir -p $sbt_plugins_path
ln -sf $current/sbt/plugins.sbt $sbt_plugins_path/plugins.sbt

echo "Starting full system update"
sudo pacman --noconfirm -Syyu

read -r -p "Install zsh? [y/N] (recommended) " response
case "$response" in
    [yY][eE][sS]|[yY])
        sudo pacman --noconfirm -Sy zsh
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install Pikaur? (AUR Helper) [y/N] (recommended) " response
case "$response" in
    [yY][eE][sS]|[yY])
        sh install/pikaur.sh
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install Pacman Packages? [y/N] (recommended) " response
case "$response" in
    [yY][eE][sS]|[yY])
        sudo sh install/pacman.sh
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install Pacman non essential Packages? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        sudo sh install/pacman_nonessential.sh
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install AUR Packages? [y/N] (recommended) " response
case "$response" in
    [yY][eE][sS]|[yY])
        if which pikaur &> /dev/null; then
            sudo sh install/aur.sh
        else
            echo "Pikaur is not installed! Please install it first"
        fi
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install non essential AUR Packages? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if which pikaur &> /dev/null; then
            sudo sh install/aur_nonessential.sh
        else
            echo "Pikaur is not installed! Please install it first"
        fi
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install Atom Packages? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        sh install/atom.sh
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install Insync (Google Drive & OneDrive Sync Client)? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if which pikaur &> /dev/null; then
            sudo pikaur -Sy --noconfirm insync
            sudo pikaur -Sy --noconfirm insync-dolphin
        else
            echo "Pikaur is not installed! Please install it first"
        fi
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install Spotify? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if which pikaur &> /dev/null; then
            sudo pikaur -S spotify
        else
            echo "Pikaur is not installed! Please install it first"
        fi
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install CKB-Next Corsair Driver? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if which pikaur &> /dev/null; then
            sudo pikaur -Sy --noconfirm ckb-next
        else
            echo "Pikaur is not installed! Please install it first"
        fi
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Install OBS? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        if which pikaur &> /dev/null; then
            sudo sh install/obs.sh
        else
            echo "Pikaur is not installed! Please install it first"
        fi
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Set zsh default? [y/N]  (recommended) " response
case "$response" in
    [yY][eE][sS]|[yY])
        if which zsh &> /dev/null; then
            #sudo sed -i -e 's/bash$/zsh/g' /etc/passwd
            chsh -s /bin/zsh
        else
            echo "zsh is not installed! Please install it first"
        fi
        ;;
    *)
        echo "Skipping..."
        ;;
esac

read -r -p "Increase Inotify Watches Limit? [y/N]  (recommended) " response
case "$response" in
    [yY][eE][sS]|[yY])
        sudo sh bin/increase_inotify_watches.sh
        ;;
    *)
        echo "Skipping..."
        ;;
esac
