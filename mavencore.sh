#!/bin/bash

# List of packages to install
packages=(
  "bat"
  "blueman"
  "clang"
  "cloudflared"
  "cmake"
  "dysk"
  "eza"
  "fzf"
  "fprintd"
  "gcc"
  "getnf"
  "ghostty"
  "git"
  "github-cli"
  "grim"
  "gum"
  "helix"
  "hypridle"
  "hyprland"
  "hyprlock"
  "hyprpaper"
  "hyprshot"
  "jdk-openjdk"
  "kitty"
  "libfprint"
  "libfprint-2-tod1-goodix"
  "macchina"
  "mpvpaper"
  "nautilus"
  "neovim"
  "network-manager-applet"
  "niri"
  "nodejs"
  "npm"
  "pamixer"
  "pavucontrol"
  "perl"
  "python-psutil"
  "polkit-gnome"
  "qbittorrent"
  "quickshell"
  "rofi-wayland"
  "rsync"
  "sshpass"
  "starship"
  "swayosd"
  "swww"
  "trash-cli"
  "unzip"
  "waybar"
  "wine"
  "wl-clipboard"
  "xwayland-satellite"
  "zed"
  "zellij"
  "zen-browser"
  "zip"
  "zoxide"
  "zsh"
  "zsh-autosuggestions"
  "zsh-completions"
  "zsh-syntax-highlighting"

  # Lsp
  "bash-language-server"
  "hyprls-git"
  "vscode-json-languageserver"
  "taplo"
  "ty"
)

rust_packages=(
  "colorctl"
  "dvault"
  'lsr-nf'
  "musicman"
  "proj-cmd"
  'slint-lsp'
  "kdlfmt"
)

flatpak_apps=(
  "com.discordapp.Discord"
  "com.github.johnfactotum.Foliate"
  "com.heroicgameslauncher.hgl"
  "com.mattjakeman.ExtensionManager"
  "com.spotify.Client"
  "info.febvre.Komikku"
  "io.github.realmazharhussain.GdmSettings"
  "io.github.vikdevelop.SaveDesktop"
  "org.gnome.Papers"
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
  if [ -e "$HOME/$item" ]; then
    if gum confirm " -> $item exists remove?"; then
      rm -r "${HOME:?}/$item" || printf "\x1b[31mCould not remove %s, exiting\n\x1b[0m" "$item"
    fi
  fi
done

for link in "${links[@]}"; do
  echo " -> checking $link"
  if [ -e "$HOME/$link" ] || [ -L "$HOME/$link" ]; then
    echo " -> $link exists, backing up..."
    mv "${HOME:?}/$link"{,.bak} || printf "\x1b[31mCould not backup %s, exiting\n\x1b[0m" "$link"
  fi
  echo " -> Creating link for $link..."
  ln -s "/mnt/DATA/$link" "$HOME/$link"
done

echo "=> All links created."

echo "=> Downloading Nerd Fonts..."
getnf -i "JetBrainsMono"
echo "=> Fonts Downloaded."

echo "=> Changing default shell to zsh..."
sudo chsh -s /bin/zsh
echo "=> Shell Change done. "

echo "=== Completed ==="
