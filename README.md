# 🚀 Ubuntu Nix Hyprland Setup

A modern, declarative, and reproducible Hyprland desktop environment setup using Nix and Home Manager on Ubuntu.

![Hyprland](https://img.shields.io/badge/Hyprland-Dynamic%20Tiling-blue?style=flat-square&logo=wayland)
![Nix](https://img.shields.io/badge/Nix-Declarative-informational?style=flat-square&logo=nixos)
![Home Manager](https://img.shields.io/badge/Home%20Manager-Dotfiles-orange?style=flat-square)

## ✨ Features

### 🎨 **Beautiful Desktop Environment**
- **Hyprland**: Dynamic tiling Wayland compositor with animations
- **Custom Theme**: Automatically generated from wallpaper colors (purple/pink/blue palette)
- **Waybar**: Highly customized status bar with system monitoring
- **Wofi**: Application launcher matching the theme
- **Hyprpaper**: Wallpaper manager with multi-monitor support

### 🛠️ **Development Environment**
- **Neovim**: Fully configured with LSP, Treesitter, and custom theme
- **PHP Development**: Laravel-ready with Artisan shortcuts and PHP 8.3
- **Node.js**: Latest LTS with npm shortcuts
- **Database Support**: MySQL, PostgreSQL, Redis, SQLite
- **Git Integration**: Configured with aliases and LazyGit
- **Terminal**: Alacritty with Zsh, Starship prompt, and modern CLI tools

### 📋 **Productivity Tools**
- **Clipboard Manager**: Clipman with `Super+V` history access
- **Screenshots**: Grim + Slurp with keybindings
- **Notifications**: SwayNotificationCenter
- **Screen Lock**: Swaylock with idle management
- **File Manager**: Integrated file explorer
- **Fuzzy Finding**: FZF integration throughout

### 🔧 **System Utilities**
- **Audio**: PipeWire with volume controls
- **Brightness**: Brightnessctl integration  
- **Network**: NetworkManager with tray applet
- **System Monitoring**: htop, btop, sensors
- **Font Management**: Nerd Fonts with proper fallbacks

## 🚀 Installation Guide

### Prerequisites
- Ubuntu 20.04+ (tested on Ubuntu 22.04/24.04)
- Internet connection
- Basic terminal knowledge

### Step 1: Install Nix Package Manager

```bash
# Install curl if not already installed
sudo apt-get update && sudo apt-get install -y curl

# Install Nix using the Determinate Systems installer (recommended)
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

### Step 2: Verify Nix Configuration

```bash
# Check Nix configuration
cat /etc/nix/nix.conf
```

Expected output should include:
```
build-users-group = nixbld
extra-experimental-features = nix-command flakes
```

### Step 3: Restart Your Shell

```bash
# Source Nix or restart terminal
source ~/.bashrc
# OR restart your terminal/session
```

### Step 4: Install Home Manager

```bash
# Enter a temporary shell with Home Manager
nix shell github:nix-community/home-manager

# Clone this configuration
git clone git@github.com:kpanuragh/ubuntu_nix_hyprland.git ~/.config/home-manager
cd ~/.config/home-manager
```

### Step 5: Add Your Wallpaper

```bash
# Add your wallpaper as bg.jpg (or update the path in home.nix)
cp /path/to/your/wallpaper.jpg ~/.config/home-manager/bg.jpg
```

### Step 6: Apply Configuration

```bash
# Apply the Home Manager configuration
home-manager switch --flake ~/.config/home-manager
```

### Step 7: Setup Hyprland Desktop Entry

Create the desktop entry for your display manager:

```bash
# Create desktop entry (adjust path if needed)
sudo tee /usr/share/wayland-sessions/hyprland.desktop << EOF
[Desktop Entry]
Name=Hyprland
Comment=An intelligent dynamic tiling Wayland compositor
Exec=$HOME/.nix-profile/bin/Hyprland
Type=Application
EOF
```

### Step 8: Logout and Login

1. Logout of your current session
2. Select "Hyprland" from your display manager
3. Login to your new Hyprland environment!

## 🔄 Updates and Maintenance

### Update Everything

```bash
# Update Nix package manager
sudo -i nix upgrade-nix

# Update flake inputs (Home Manager, Hyprland, etc.)
nix flake update --flake ~/.config/home-manager

# Apply updated configuration
home-manager switch --flake ~/.config/home-manager
```

### Update Individual Components

```bash
# Update just the lock file
nix flake update ~/.config/home-manager

# Rebuild without updating
home-manager switch --flake ~/.config/home-manager
```

## ⌨️ Key Bindings

### Window Management
- `Super + Return` - Open terminal (Alacritty)
- `Super + D` - Application launcher (Wofi)
- `Super + Q` - Close window
- `Super + L` - Lock screen
- `Super + Shift + E` - Exit Hyprland

### Navigation
- `Super + H/J/K/L` - Move focus (Vim-style)
- `Super + Shift + H/J/K/L` - Move window
- `Super + 1-9` - Switch workspace
- `Super + Shift + 1-9` - Move window to workspace
- `Super + Tab` - Workspace overview (hyprexpo)

### Utilities
- `Super + V` - Clipboard history
- `Super + Shift + V` - Clipboard history (terminal)
- `Print Screen` - Full screenshot
- `Super + Print Screen` - Area screenshot
- Volume/brightness keys work as expected

## 🎨 Customization

### Theme Colors
The theme automatically extracts colors from your wallpaper (`bg.jpg`). To use a different wallpaper:

1. Replace `~/.config/home-manager/bg.jpg` with your image
2. Run `home-manager switch --flake ~/.config/home-manager`

### Manual Color Customization
Edit the color variables in `home.nix`:
- Hyprland borders: Search for `col.active_border`
- Waybar colors: Look for the waybar `style` section
- Terminal colors: Starship configuration section

### Adding Applications
Add packages to the `home.packages` list in `home.nix`:

```nix
home.packages = with pkgs; [
  # Add your packages here
  firefox
  discord
  # etc...
];
```

## 🗂️ File Structure

```
~/.config/home-manager/
├── flake.nix          # Nix flake configuration
├── home.nix           # Main Home Manager configuration
├── bg.jpg             # Your wallpaper
└── README.md          # This file
```

## 🛠️ Development Tools Included

### Languages & Frameworks
- **PHP 8.3** with Composer
- **Node.js 22** with npm
- **Nix** with language server

### Databases
- MySQL 8.0
- PostgreSQL 16
- Redis
- SQLite

### Editors & IDEs
- **Neovim** (fully configured)
- **VS Code** (wrapped with nixGL)
- **Claude Code** (if available)

### Laravel Development
Pre-configured aliases and tools:
- `art` - php artisan
- `serve` - php artisan serve
- `mfs` - migrate:fresh --seed
- `tinker` - php artisan tinker

## 🔧 Troubleshooting

### Icons Not Showing in Waybar
```bash
# Rebuild font cache
fc-cache -fv
# Restart waybar
pkill waybar && waybar &
```

### Clipboard Not Working
```bash
# Check if clipman is running
ps aux | grep clipman
# Restart clipboard manager if needed
pkill clipman
wl-paste --type text --watch clipman store &
```

### Audio Issues
```bash
# Restart PipeWire services
systemctl --user restart pipewire wireplumber
```

### Display Issues
```bash
# Check if nixGL is working
glxinfo | grep "OpenGL renderer"
# Update monitor configuration in home.nix
```

## 🗑️ Uninstallation

To completely remove the setup:

### Remove Home Manager Configuration
```bash
# Remove the configuration
rm -rf ~/.config/home-manager

# Reset Home Manager (optional)
home-manager expire-generations 0
```

### Uninstall Nix (Complete removal)
```bash
# Using the uninstaller
/nix/nix-installer uninstall

# Manual removal (if uninstaller not available)
sudo rm -rf /nix
sudo userdel -r nixbld{1..32} 2>/dev/null || true
sudo groupdel nixbld 2>/dev/null || true
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📝 License

This configuration is open source and available under the [MIT License](LICENSE).

## 🙏 Acknowledgments

- [Hyprland](https://hyprland.org/) - Amazing Wayland compositor
- [Nix](https://nixos.org/) - Declarative package management
- [Home Manager](https://github.com/nix-community/home-manager) - User environment management
- [Catppuccin](https://catppuccin.com/) - Beautiful color schemes
- Community configurations and dotfiles for inspiration

---

**Enjoy your new Hyprland setup! 🎉**

For issues or questions, please open an issue on the [GitHub repository](https://github.com/kpanuragh/ubuntu_nix_hyprland).