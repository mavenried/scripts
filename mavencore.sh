#!/bin/bash

# This script installs a list of software packages for setting up my computer.
# List of packages to install
packages=(
  "hyprland"
  "hyprshot"
  "hyprpaper"
  "hypridle"
  "hyprlock"
  "trash"
  "swayosd"
  "swww"
  "niri"
  "waybar"
  "rofi-wayland"
  "ghostty"
  "grim"
  "perl"
  "gcc"
  "clang"
  "cmake"
  "git"
  "neovim"
  "kitty"
  "cloudflared"
  "github-cli"
  "fzf"
  "brave-bin"
  "zsh"
  "zsh-completions"
  "zsh-syntax-highlighting"
  "zsh-autosuggestions"
  "zip"
  "unzip"
  "wl-clipboard"
  "pavucontrol"
  "pamixer"
  "blueman"
  "network-manager-applet"
  "mako"
  "nodejs"
  "npm"
  "qbittorrent"
  "jdk-openjdk"
)

rust_packages=(
  "proj-cmd"
  "zoxide"
  "zellij"
  "eza"
  "musicman"
  "macchina"
  "starship"
  "bat"
)

flatpak_apps=(
  "com.discordapp.Discord"
  "com.spotify.Client"
  "com.github.johnfactotum.Foliate"
  "io.github.realmazharhussain.GdmSettings"
  "io.github.vikdevelop.SaveDesktop"
  "info.febvre.Komikku"
  "com.heroicgameslauncher.hgl"
  "com.mattjakeman.ExtensionManager"
)

links=(
  ".config"
  "Anime"
  "Documents"
  "Pictures"
  "Music"
  "Games"
  "Books"
  "Projects"
  "College"
  "DVault"
  ".zshrc"
)

removeonly=(
  "Templates"
  "Videos"
  "Public"
)
echo " __  __                        ____               "
echo "|  \\/  | __ ___   _____ _ __  / ___|___  _ __ ___ "
echo "| |\\/| |/ _\` \\ \\ / / _ \\ '_ \\| |   / _ \\| '__/ _ \\"
echo "| |  | | (_| |\\ V /  __/ | | | |__| (_) | | |  __/"
echo "|_|  |_|\\__,_| \\_/ \\___|_| |_|\\____\\___/|_|  \\___|"
echo "                                                  "
echo "=== MavenCore Installer v1.0 ==="
echo "Starting installation of software packages..."
# install yay
if ! command -v yay &>/dev/null; then
  echo "=> yay could not be found, installing..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  echo done
  cd /tmp/yay
  makepkg -si
else
  echo "=> yay is already installed"
fi

# Installing the Rust toolchain
if ! command -v rustc &>/dev/null; then
  echo "=> Rust could not be found, installing..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  echo "=> Rust is already installed"
fi

# Using yay to install both AUR and official repo packages
for package in "${packages[@]}"; do
  if ! yay -Qi "$package" &>/dev/null; then
    echo " -> installing arch::$package..."
    yay -S --noconfirm "$package"
  else
    echo " -> arch::$package is already installed"
  fi
done
echo "=> All arch packages installed."

# Installing Rust packages using cargo
for package in "${rust_packages[@]}"; do
  if ! command -v "$package" &>/dev/null; then
    echo " -> installing cargo::$package..."
    cargo install "$package"
  else
    echo " -> cargo::$package is already installed"
  fi
done
echo "=> All cargo packages installed."

for app in "${flatpak_apps[@]}"; do
  if ! flatpak list | grep -q "$app"; then
    echo " -> installing flatpak::$app..."
    flatpak install flathub "$app" -y
  else
    echo " -> flatpak::$app is already installed"
  fi
done

# Create Links
echo "=> Creating symbolic links..."

for item in "${removeonly[@]}"; do
  echo "debug:: checking $item"
  if [ -e "$HOME/$item" ] || [ -L "$HOME/$item" ]; then
    echo " -> $item exists removing..."
    rm -ri "${HOME:?}/$item" || printf "\x1b[31mCould not remove %s, exiting\n\x1b[0m" "$item"
  fi
done

for link in "${links[@]}"; do
  echo " -> checking $link"
  if [ -e "$HOME/$link" ] || [ -L "$HOME/$link" ]; then
    echo " -> $link exists removing..."
    rm -ri "${HOME:?}/$link" || printf "\x1b[31mCould not remove %s, exiting\n\x1b[0m" "$link"
  fi
  echo " -> Creating link for $link..."
  ln -s "/mnt/DATA/$link" "$HOME/$link"
done

echo "=> All links created."
chsh -s /bin/zsh
echo "=== Completed ==="
