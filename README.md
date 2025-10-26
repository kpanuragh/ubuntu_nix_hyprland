# 🚀 Ubuntu Nix Hyprland Setup

A modern, declarative, and reproducible Hyprland desktop environment setup using Nix and Home Manager on Ubuntu.

![Hyprland](https://img.shields.io/badge/Hyprland-Dynamic%20Tiling-blue?style=flat-square&logo=wayland)
![Nix](https://img.shields.io/badge/Nix-Declarative-informational?style=flat-square&logo=nixos)
![Home Manager](https://img.shields.io/badge/Home%20Manager-Dotfiles-orange?style=flat-square)

## ✨ Features

### 🖥️ **Complete Display Manager Integration**
- **GDM Ready**: Full GNOME Display Manager integration out of the box
- **Professional Login**: Clean session selection and user switching
- **Multi-User Support**: Each user gets their own Hyprland configuration
- **Universal Compatibility**: Works with any XDG-compliant display manager

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

### Step 7: Setup GDM Session Entry

```bash
# Create system-wide session entry for GDM
sudo tee /usr/share/wayland-sessions/hyprland-nix.desktop << EOF
[Desktop Entry]
Name=Hyprland (Nix)
GenericName=Wayland Compositor
Comment=An intelligent dynamic tiling Wayland compositor (Nix-managed)
Exec=$HOME/.local/bin/start-hyprland
Icon=hyprland
Terminal=false
Type=Application
Categories=System;
StartupNotify=false
Keywords=tiling;wm;windowmanager;wayland;nix;
DesktopNames=Hyprland
EOF

# Enable GDM if not already enabled
sudo apt install -y gdm3
sudo systemctl set-default graphical.target

# Restart GDM to detect the new session
sudo systemctl restart gdm
```

### Step 8: Logout and Login to GDM

1. **Reboot your system** to start GDM
   ```bash
   sudo reboot
   ```
2. **At the GDM login screen**, click the gear icon in the bottom right
3. **Select "Hyprland (Nix)"** from the session list  
4. **Login** to your new Hyprland environment!

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

## �️ Display Manager Integration

### **GDM Integration (Default)**
This setup includes full GDM (GNOME Display Manager) support:

✅ **Automatic Session**: "Hyprland (Nix)" appears in GDM session selector  
✅ **Proper Environment**: Correctly sources Nix environment and paths  
✅ **Wayland Optimized**: Enhanced variables for modern app compatibility  
✅ **Clean Integration**: Professional login/logout experience  

### **Using the Display Manager**
1. **Login Screen**: Select "Hyprland (Nix)" from the session menu
   - **GDM**: Click gear ⚙️ icon → Select session
   - **LightDM**: Use session dropdown  
   - **SDDM**: Click session button
2. **Session Management**: Logout returns you to display manager for user switching
3. **Multi-User**: Each user gets their own Hyprland configuration automatically
4. **No Root Setup**: Desktop entries are created in user directories (`~/.local/share/`)

### **GDM Session Setup**
For GDM to detect the Hyprland session:
- **System Entry Required**: GDM needs session in `/usr/share/wayland-sessions/`
- **One-Time Setup**: Manual creation of system-wide session entry (requires sudo)
- **Custom Start Script**: Ensures proper Nix environment loading
- **Universal Access**: All users can select Hyprland session from GDM

### **Alternative Display Managers**
Other display managers may work with different approaches:
- **SDDM/LightDM**: May support user-level sessions in `~/.local/share/wayland-sessions/`
- **Manual Setup**: Copy session file to system directory manually
- **Direct Start**: Use `~/.local/bin/start-hyprland` from TTY

## �🔧 Troubleshooting

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

### Session Not Appearing in Display Manager
```bash
# Verify system session entry exists
ls -la /usr/share/wayland-sessions/ | grep hypr

# If missing, create it manually (from Step 7)
sudo tee /usr/share/wayland-sessions/hyprland-nix.desktop << EOF
[Desktop Entry]
Name=Hyprland (Nix)
Comment=An intelligent dynamic tiling Wayland compositor (Nix-managed)
Exec=$HOME/.local/bin/start-hyprland
Type=Application
DesktopNames=Hyprland
EOF

# Restart display manager to detect new sessions
sudo systemctl restart gdm

# Alternative: Start directly from TTY
~/.local/bin/start-hyprland
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

### Remove Display Manager Integration (Optional)
```bash
# Remove user-level session entry (automatically removed when home-manager config is removed)
rm -f ~/.local/share/wayland-sessions/hyprland-nix.desktop

# If you want to disable GDM and return to default display manager
sudo systemctl set-default multi-user.target  # or graphical.target with different DM
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