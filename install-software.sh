#!/bin/bash

# This script installs a list of software packages for setting up my computer.

echo "=== MavenCore Installer v1.0 ==="
echo "Starting installation of software packages..."
# install yay
echo "Checking for yay..."
if ! command -v yay &>/dev/null; then
  echo "yay could not be found, installing..."
  git clone https://aur.archlinux.org/yay.git /tmp/yay
  cd /tmp/yay
  makepkg -si
  cd ..
  rm -rf yay
else
  echo "yay is already installed"
fi

# List of packages to install
packages=(
  "hyprland"
  "hyprshot"
  "hyprpaper"
  "hypridle"
  "hyprlock"
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
  "brave-bin"
)

# Installing the Rust toolchain
if ! command -v rustc &>/dev/null; then
  echo "Rust could not be found, installing..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  echo "Rust is already installed"
fi

# Using yay to install both AUR and official repo packages
for package in "${packages[@]}"; do
  if ! yay -Qi "$package" &>/dev/null; then
    echo "Installing $package..."
    yay -S --noconfirm "$package"
  else
    echo "$package is already installed"
  fi
done
echo "All (yay) packages installed."

rust_packages=(
  "bottom"
  "proj-cmd"
  "zoxide"
  "zellij"
  "eza"
  "musicman"
  "macchina"
  "bat"
)

# Installing Rust packages using cargo
for package in "${rust_packages[@]}"; do
  if ! command -v "$package" &>/dev/null; then
    echo "Installing $package via cargo..."
    cargo install "$package"
  else
    echo "$package is already installed"
  fi
done
echo "All (cargo) packages installed."

# Create Links
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

for app in "${flatpak_apps[@]}"; do
  if ! flatpak list | grep -q "$app"; then
    echo "Installing $app via flatpak..."
    flatpak install flathub "$app" -y
  else
    echo "$app is already installed"
  fi
done

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

cd $HOME

for item in "${removeonly[@]}"; do
  if [ -e "$item" ] || [ -L "$item" ]; then
    echo "$item exists removing..."
    rm -rf "$item"
  fi
done

for link in "${links[@]}"; do
  if [ -e "$link" ] || [ -L "$link" ]; then
    echo "$link exists removing..."
    rm -rf "$link"
  fi
  echo "Creating link for $link..."
  ln -s "/mnt/DATA/$link" "$link"
done

echo "All links created."
