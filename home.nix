{
  config,
  pkgs,
  lib,
  inputs,
  nixGL,
  hyprland-plugins,
  ...
}:

# A helper function to wrap packages using the configured nixGL defaultWrapper
let
  wrapGL = pkg: config.lib.nixGL.wrap pkg;
in
{
  # --- nixGL Configuration ---
  # Enables the wrappers provided by nixGL
  nixGL = {
    packages = nixGL.packages; # Must be set to the nixGL package set
    # If you have an NVIDIA GPU, you might use "nvidia" or "nvidiaPrime"
  };

  # --- Home Manager User Configuration ---
  home = {
    username = "power";
    homeDirectory = "/home/power";
    stateVersion = "25.05"; # Your Home Manager release version

  

    packages = with pkgs; [
      # Terminal, wrapped with nixGL for GPU acceleration
      (wrapGL alacritty)

      # Hyprland Essentials (wrapped as they are graphical applications)
      (wrapGL hyprpaper) # Wallpaper utility
      (wrapGL waybar)    # Status bar
      (wrapGL wofi)      # Application launcher
      (wrapGL swaylock)  # Screen locker
      (wrapGL wlogout)   # Logout menu for waybar
      (wrapGL grim)      # Screenshot tool
      (wrapGL slurp)     # Region selection tool for screenshots
      (wrapGL swaynotificationcenter) # Notification daemon

      # General System Utilities
      clipman        # Clipboard manager (command-line utility)
      wl-clipboard   # Wayland clipboard utilities (wl-copy, wl-paste)
      pavucontrol    # GTK volume mixer
      brightnessctl  # Utility to control screen brightness
      networkmanager # Network management client
      networkmanagerapplet # NetworkManager GUI (tray icon)
      solaar         # Logitech device manager
      htop           # Interactive process viewer
      btop           # Modern resource monitor (alternative to htop)
      lm_sensors     # Hardware temperature sensors

      # Fonts for waybar icons
      font-awesome   # Font Awesome icons
      nerd-fonts.fira-code
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
      noto-fonts
      noto-fonts-emoji

      # Screen Sharing & Portals
      pipewire                     # Audio/Video routing for screen sharing
      wireplumber                  # PipeWire session manager

      # Common Applications (wrapped for compatibility)
      (wrapGL firefox)
      (wrapGL discord)
      (wrapGL vscode)
      (wrapGL claude-code)

      # --- Development Tools ---
      # PHP & Laravel Development
      php83                    # PHP 8.3
      php83Packages.composer   # Composer dependency manager

      # Node.js & JavaScript Development
      nodejs_22                # Node.js LTS

      # Database Tools
      mysql80                  # MySQL server and client
      postgresql_16            # PostgreSQL server and client
      redis                    # Redis server and client
      sqlite                   # SQLite database

      # Version Control
      git                      # Git VCS
      gh                       # GitHub CLI
      lazygit                  # Terminal UI for git

      # Shell & Terminal Utilities
      zsh                      # Zsh shell
      starship                 # Cross-shell prompt
      tmux                     # Terminal multiplexer
      eza                      # Modern ls replacement
      bat                      # Modern cat with syntax highlighting
      fzf                      # Fuzzy finder
      ripgrep                  # Fast grep alternative
      fd                       # Fast find alternative
      zoxide                   # Smart cd command
      tldr                     # Simplified man pages

      # Development Utilities
      httpie                   # HTTP client
      jq                       # JSON processor
      yq                       # YAML processor
      curl                     # URL transfer tool
      wget                     # File downloader
      tree                     # Directory tree viewer
      unzip                    # ZIP extraction
      zip                      # ZIP compression

      # Laravel-specific Tools
      nodePackages."@volar/vue-language-server"  # Vue Language Server (Volar)

      # Font utilities
      fontconfig

      # Image processing tools
      imagemagick

      # Display Manager (optional - can be used instead of system DM)
      # sddm

      # Code Quality Tools
      php83Packages.phpstan    # PHP Static Analysis
      php83Packages.php-cs-fixer # PHP Code Style Fixer
      nodePackages.eslint      # JavaScript linter
    ];
  };

  # --- Home Manager Services ---
  programs.home-manager.enable = true;

  # --- Firefox Configuration for Screen Sharing ---
  programs.firefox = {
    enable = true;
    package = wrapGL pkgs.firefox;
    profiles.default = {
      id = 0;
      isDefault = true;
      settings = {
        # Enable Wayland
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "widget.use-xdg-desktop-portal.location" = 1;
        "widget.use-xdg-desktop-portal.open-uri" = 1;
        "widget.use-xdg-desktop-portal.settings" = 1;

        # Enable WebRTC PipeWire
        "media.navigator.mediadatadecoder_vpx_enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-vpx.enabled" = true;

        # Screen sharing permissions
        "media.getusermedia.screensharing.enabled" = true;
        "media.getusermedia.browser.enabled" = true;
        "media.navigator.video.enabled" = true;
        "media.navigator.video.default_width" = 1920;
        "media.navigator.video.default_height" = 1080;
      };
    };
  };

  # --- Git Configuration ---
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Anuragh K P";
        email = "kpanuragh@gmail.com"; # Updated email
      };
      init.defaultBranch = "main";
      pull.rebase = false;
      core.editor = "nvim";
      diff.tool = "nvimdiff";
      merge.tool = "nvimdiff";
      alias = {
        st = "status";
        co = "checkout";
        br = "branch";
        ci = "commit";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      };
    };
  };

  # --- Zsh Configuration ---
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Laravel Artisan shortcuts
      art = "php artisan";
      artisan = "php artisan";
      mfs = "php artisan migrate:fresh --seed";
      migrate = "php artisan migrate";
      seed = "php artisan seed";
      tinker = "php artisan tinker";
      serve = "php artisan serve";

      # Composer shortcuts
      ci = "composer install";
      cu = "composer update";
      cda = "composer dump-autoload";

      # NPM shortcuts
      ni = "npm install";
      nid = "npm install --save-dev";
      nr = "npm run";
      nrd = "npm run dev";
      nrb = "npm run build";
      nrw = "npm run watch";

      # Modern CLI replacements
      ls = "eza --icons --group-directories-first";
      ll = "eza -l --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      lt = "eza --tree --icons --group-directories-first";
      cat = "bat";

      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gco = "git checkout";
      gcb = "git checkout -b";
      gd = "git diff";
      lg = "lazygit";

      # Directory navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";

      # Useful shortcuts
      vim = "nvim";
      vi = "nvim";
      v = "nvim";
      tree = "tree -C";
      mkdir = "mkdir -p";

      # Home Manager
      hm = "home-manager";
      hms = "home-manager switch";
      hme = "nvim ~/.config/home-manager/home.nix";
    };

    initContent = ''
      # Initialize starship prompt
      eval "$(starship init zsh)"

      # Initialize zoxide (smart cd)
      eval "$(zoxide init zsh)"

      # FZF configuration
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

      # PHP configuration
      export PATH="$HOME/.config/composer/vendor/bin:$PATH"

      # Node configuration
      export PATH="$HOME/.npm-global/bin:$PATH"

      # Custom Laravel functions
      artisan() {
        php artisan "$@"
      }

      # Quick project creator for Laravel
      laravel-new() {
        if [ -z "$1" ]; then
          echo "Usage: laravel-new <project-name>"
          return 1
        fi
        composer create-project laravel/laravel "$1"
        cd "$1" || return
      }
    '';
  };

  # --- Starship Prompt Configuration ---
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        "$directory"
        "$git_branch"
        "$git_state"
        "$git_status"
        "$php"
        "$nodejs"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
        style = "bold #448BD2";  # Sky blue from wallpaper
      };

      git_branch = {
        symbol = " ";
        style = "bold #B75DA7";  # Lavender from wallpaper
      };

      git_status = {
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?";
        stashed = "$";
        modified = "!";
        staged = "[++$count](green)";
        renamed = "»";
        deleted = "✘";
      };

      php = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
        style = "bold #AE304E";  # Rose pink from wallpaper
      };

      nodejs = {
        symbol = " ";
        format = "via [$symbol($version )]($style)";
        style = "bold #3C3DB0";  # Deep purple from wallpaper
      };

      character = {
        success_symbol = "[➜](bold #448BD2)";  # Sky blue from wallpaper
        error_symbol = "[➜](bold #AE304E)";    # Rose pink from wallpaper
      };
    };
  };

  # --- Tmux Configuration ---
  programs.tmux = {
    enable = true;
    clock24 = true;
    keyMode = "vi";
    terminal = "screen-256color";
    prefix = "C-a";
    escapeTime = 0;
    baseIndex = 1;
    extraConfig = ''
      # Enable mouse support
      set -g mouse on

      # Split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # Reload config file
      bind r source-file ~/.tmux.conf

      # Switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Status bar - Colors from wallpaper
      set -g status-style 'bg=#1A035B fg=#C7A6CF'  # Dark purple bg, light purple text
      set -g status-left '#[bg=#448BD2,fg=#1A035B,bold] #S '  # Sky blue bg, dark purple text
      set -g status-right '#[bg=#5D0C37,fg=#C7A6CF] %Y-%m-%d %H:%M '  # Deep rose bg, light purple text
    '';
  };

  # --- FZF Configuration ---
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--border"
      "--inline-info"
    ];
  };

  # --- Bat Configuration (cat replacement) ---
  programs.bat = {
    enable = true;
    config = {
      theme = "Catppuccin-mocha";
      style = "numbers,changes,header";
    };
  };

  # --- Zoxide Configuration (smart cd) ---
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  # --- Eza Configuration (ls replacement) ---
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    git = true;
    icons = "auto";
  };

  # --- Waybar Configuration ---
  programs.waybar = {
    enable = true;
    package = wrapGL pkgs.waybar;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 34;
        spacing = 4;

        modules-left = [ "hyprland/workspaces" "hyprland/window" ];
        modules-center = [ "clock" ];
        modules-right = [ "tray" "cpu" "memory" "disk" "temperature" "pulseaudio" "network" "battery" "custom/notification" "custom/power" ];

        # Hyprland Workspaces
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "10" = "10";
            urgent = "";
            active = "";
            default = "";
          };
          persistent-workspaces = {
            "*" = 5;
          };
        };

        # Active Window Title
        "hyprland/window" = {
          format = "{}";
          max-length = 50;
          separate-outputs = true;
        };

        # System Tray
        tray = {
          icon-size = 18;
          spacing = 10;
        };

        # Clock
        clock = {
          interval = 1;
          format = "{:%H:%M:%S}";
          format-alt = "{:%A, %B %d, %Y (%R)}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#f5e0dc'><b>{}</b></span>";
              days = "<span color='#cdd6f4'><b>{}</b></span>";
              weeks = "<span color='#89dceb'><b>W{}</b></span>";
              weekdays = "<span color='#f9e2af'><b>{}</b></span>";
              today = "<span color='#f38ba8'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        # CPU
        cpu = {
          interval = 2;
          format = "󰻠 {usage}%";
          tooltip = true;
          on-click = "alacritty -e htop";
        };

        # Memory
        memory = {
          interval = 2;
          format = "󰍛 {percentage}%";
          tooltip-format = "RAM: {used:0.1f}G / {total:0.1f}G ({percentage}%)\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G";
          on-click = "alacritty -e htop";
        };

        # Disk
        disk = {
          interval = 30;
          format = "󰋊 {percentage_used}%";
          path = "/";
          tooltip-format = "Used: {used} / {total} ({percentage_used}%)";
        };

        # Temperature
        temperature = {
          interval = 2;
          hwmon-path = "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          format = "{icon} {temperatureC}°C";
          format-icons = [ "󱃃" "󰔏" "󱃂" "󰸁" "󰸁" ];
          on-click = "alacritty -e watch sensors";
        };

        # Network
        network = {
          interval = 2;
          format-wifi = "󰖩 {essid}";
          format-ethernet = "󰈀 {ipaddr}";
          format-disconnected = "󰖪 Disconnected";
          tooltip-format = "{ifname}: {ipaddr}/{cidr}\nUp: {bandwidthUpBytes} Down: {bandwidthDownBytes}";
          tooltip-format-wifi = "{essid} ({signalStrength}%)\n{ipaddr}/{cidr}\nUp: {bandwidthUpBytes} Down: {bandwidthDownBytes}";
          on-click = "alacritty -e nmtui";
        };

        # Audio (PulseAudio/PipeWire)
        pulseaudio = {
          format = "{icon} {volume}%";
          format-muted = "󰸈 Muted";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󰋎";
            headset = "󰋎";
            phone = "󰏲";
            portable = "󰦧";
            car = "󰄋";
            default = [ "󰕿" "󰖀" "󰕾" ];
          };
          on-click = "pavucontrol";
          on-click-right = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          scroll-step = 5;
        };

        # Battery
        battery = {
          interval = 10;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
          format-alt = "{icon} {time}";
          format-icons = [ "󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
          tooltip-format = "{timeTo}, {capacity}%\nPower: {power}W";
        };

        # Notification Center
        "custom/notification" = {
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup>󰂚</sup></span>";
            none = "󰂚";
            dnd-notification = "<span foreground='red'><sup>󰂛</sup></span>";
            dnd-none = "󰂛";
            inhibited-notification = "<span foreground='red'><sup>󰂚</sup></span>";
            inhibited-none = "󰂚";
            dnd-inhibited-notification = "<span foreground='red'><sup>󰂛</sup></span>";
            dnd-inhibited-none = "󰂛";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        # Power Menu
        "custom/power" = {
          format = "󰐥";
          tooltip = false;
          on-click = "wlogout";
        };
      };
    };

    # Waybar Styling (Catppuccin Mocha theme)
    style = ''
      * {
        font-family: "FiraCode Nerd Font", "JetBrainsMono Nerd Font", "Symbols Nerd Font", "Font Awesome 6 Free", sans-serif;
        font-size: 13px;
        min-height: 0;
      }

      window#waybar {
        background-color: rgba(26, 3, 91, 0.95);  /* Dark purple from wallpaper */
        color: #C7A6CF;  /* Light purple from wallpaper */
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      /* Workspaces */
      #workspaces button {
        padding: 0 8px;
        background-color: transparent;
        color: #C7A6CF;  /* Light purple from wallpaper */
        border-radius: 8px;
        margin: 2px 2px;
        transition: all 0.3s ease;
      }

      #workspaces button:hover {
        background-color: rgba(68, 139, 210, 0.3);  /* Sky blue from wallpaper */
        color: #448BD2;
      }

      #workspaces button.active {
        background-color: #448BD2;  /* Sky blue from wallpaper */
        color: #1A035B;  /* Dark purple from wallpaper */
        font-weight: bold;
      }

      #workspaces button.urgent {
        background-color: #AE304E;  /* Rose pink from wallpaper */
        color: #C7A6CF;
      }

      /* Window Title */
      #window {
        padding: 0 10px;
        color: #448BD2;  /* Sky blue from wallpaper */
        font-weight: bold;
      }

      /* Clock */
      #clock {
        padding: 0 12px;
        background-color: #B75DA7;  /* Lavender from wallpaper */
        color: #1A035B;  /* Dark purple from wallpaper */
        border-radius: 8px;
        font-weight: bold;
        margin: 2px 4px;
      }

      /* All modules on the right */
      #tray,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #network,
      #pulseaudio,
      #battery,
      #custom-notification,
      #custom-power {
        padding: 0 10px;
        margin: 2px 2px;
        border-radius: 8px;
        background-color: #5D0C37;  /* Deep rose from wallpaper */
        color: #C7A6CF;  /* Light purple from wallpaper */
      }

      /* CPU */
      #cpu {
        background-color: #3C3DB0;  /* Deep purple from wallpaper */
        color: #C7A6CF;
      }

      /* Memory */
      #memory {
        background-color: #448BD2;  /* Sky blue from wallpaper */
        color: #1A035B;
      }

      /* Disk */
      #disk {
        background-color: #B75DA7;  /* Lavender from wallpaper */
        color: #1A035B;
      }

      /* Temperature */
      #temperature {
        background-color: #AE304E;  /* Rose pink from wallpaper */
        color: #C7A6CF;
      }

      #temperature.critical {
        background-color: #AE304E;  /* Rose pink from wallpaper */
        color: #C7A6CF;
        animation: blink 1s ease infinite;
      }

      /* Network */
      #network {
        background-color: #448BD2;  /* Sky blue from wallpaper */
        color: #1A035B;
      }

      #network.disconnected {
        background-color: #AE304E;  /* Rose pink from wallpaper */
        color: #C7A6CF;
      }

      /* Audio */
      #pulseaudio {
        background-color: #B75DA7;  /* Lavender from wallpaper */
        color: #1A035B;
      }

      #pulseaudio.muted {
        background-color: #5D0C37;  /* Deep rose from wallpaper */
        color: #C7A6CF;
      }

      /* Battery */
      #battery {
        background-color: #3C3DB0;  /* Deep purple from wallpaper */
        color: #C7A6CF;
      }

      #battery.charging {
        background-color: #448BD2;  /* Sky blue from wallpaper */
        color: #1A035B;
      }

      #battery.warning:not(.charging) {
        background-color: #AE304E;  /* Rose pink from wallpaper */
        color: #C7A6CF;
      }

      #battery.critical:not(.charging) {
        background-color: #AE304E;  /* Rose pink from wallpaper */
        color: #C7A6CF;
        animation: blink 1s ease infinite;
      }

      /* Notification Center */
      #custom-notification {
        background-color: #B75DA7;  /* Lavender from wallpaper */
        color: #1A035B;
        font-size: 15px;
      }

      /* Power Menu */
      #custom-power {
        background-color: #AE304E;  /* Rose pink from wallpaper */
        color: #C7A6CF;
        font-size: 15px;
        padding: 0 12px;
      }

      #custom-power:hover {
        background-color: #5D0C37;  /* Deeper rose from wallpaper */
      }

      /* Tray */
      #tray {
        background-color: #5D0C37;  /* Deep rose from wallpaper */
      }

      #tray > .passive {
        -gtk-icon-effect: dim;
      }

      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #AE304E;  /* Rose pink from wallpaper */
      }

      /* Animations */
      @keyframes blink {
        0% {
          opacity: 1;
        }
        50% {
          opacity: 0.5;
        }
        100% {
          opacity: 1;
        }
      }

      /* Tooltips */
      tooltip {
        background-color: #1A035B;  /* Dark purple from wallpaper */
        border: 2px solid #448BD2;  /* Sky blue from wallpaper */
        border-radius: 8px;
        color: #C7A6CF;  /* Light purple from wallpaper */
      }

      tooltip label {
        color: #C7A6CF;  /* Light purple from wallpaper */
      }
    '';
  };

  # --- Hyprpaper Configuration ---
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      splash = false;
      splash_offset = 2.0;

      preload = [
        "~/.config/home-manager/bg.jpg"
      ];

      wallpaper = [
        "HDMI-A-1,~/.config/home-manager/bg.jpg"
        "eDP-1,~/.config/home-manager/bg.jpg"
      ];
    };
  };

  # --- Neovim Configuration ---
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraPackages = with pkgs; [
      # LSP Servers
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted  # HTML, CSS, JSON, ESLint
      nodePackages.intelephense                   # PHP
      nodePackages."@tailwindcss/language-server" # Tailwind CSS
      lua-language-server
      nil                                         # Nix LSP

      # Formatters
      nodePackages.prettier
      php83Packages.php-cs-fixer
      stylua
      nixfmt-rfc-style

      # Linters
      nodePackages.eslint
      php83Packages.phpstan

      # Additional tools
      ripgrep
      fd
      tree-sitter
      git  # Required by lazy.nvim
    ];

    extraLuaConfig = ''
      -- Set leader key (must be before lazy.nvim)
      vim.g.mapleader = ' '
      vim.g.maplocalleader = ' '

      -- Basic settings
      vim.opt.number = true
      vim.opt.relativenumber = true
      vim.opt.mouse = 'a'
      vim.opt.ignorecase = true
      vim.opt.smartcase = true
      vim.opt.hlsearch = false
      vim.opt.wrap = false
      vim.opt.breakindent = true
      vim.opt.tabstop = 4
      vim.opt.shiftwidth = 4
      vim.opt.expandtab = true
      vim.opt.termguicolors = true
      vim.opt.signcolumn = 'yes'
      vim.opt.updatetime = 250
      vim.opt.timeoutlen = 300
      vim.opt.completeopt = 'menuone,noselect'
      vim.opt.clipboard = 'unnamedplus'

      -- Bootstrap lazy.nvim
      local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
      if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
          "git",
          "clone",
          "--filter=blob:none",
          "https://github.com/folke/lazy.nvim.git",
          "--branch=stable",
          lazypath,
        })
      end
      vim.opt.rtp:prepend(lazypath)

      -- Setup lazy.nvim with plugins
      require("lazy").setup({
        -- Color scheme based on wallpaper
        {
          "catppuccin/nvim",
          name = "catppuccin",
          priority = 1000,
          config = function()
            require("catppuccin").setup({
              flavour = "mocha",
              custom_highlights = function(colors)
                return {
                  -- Custom colors from wallpaper
                  Normal = { bg = "#1A035B", fg = "#C7A6CF" },  -- Dark purple bg, light purple text
                  NormalFloat = { bg = "#5D0C37", fg = "#C7A6CF" },  -- Deep rose bg
                  FloatBorder = { fg = "#448BD2" },  -- Sky blue border
                  CursorLine = { bg = "#3C3DB0" },  -- Deep purple highlight
                  Visual = { bg = "#AE304E" },  -- Rose pink selection
                  Search = { bg = "#B75DA7", fg = "#1A035B" },  -- Lavender search
                  IncSearch = { bg = "#448BD2", fg = "#1A035B" },  -- Sky blue incremental search
                  StatusLine = { bg = "#5D0C37", fg = "#C7A6CF" },  -- Deep rose status
                  TabLine = { bg = "#3C3DB0", fg = "#C7A6CF" },  -- Deep purple tabs
                  TabLineSel = { bg = "#448BD2", fg = "#1A035B" },  -- Sky blue active tab
                }
              end,
              integrations = {
                telescope = true,
                nvimtree = true,
                gitsigns = true,
                treesitter = true,
                cmp = true,
                which_key = true,
              }
            })
            vim.cmd.colorscheme "catppuccin"
          end,
        },

        -- Formatting plugin (manual only, no format on save)
        {
          "stevearc/conform.nvim",
          cmd = { "ConformInfo" },
          config = function()
            require("conform").setup({
              formatters_by_ft = {
                php = { "php_cs_fixer" },
                javascript = { "prettier" },
                typescript = { "prettier" },
                javascriptreact = { "prettier" },
                typescriptreact = { "prettier" },
                vue = { "prettier" },
                css = { "prettier" },
                scss = { "prettier" },
                html = { "prettier" },
                json = { "prettier" },
                yaml = { "prettier" },
                markdown = { "prettier" },
                lua = { "stylua" },
                nix = { "nixfmt" },
              },
              -- No format_on_save - manual formatting only
            })

            -- Manual format command
            vim.keymap.set({ "n", "v" }, "<leader>fm", function()
              require("conform").format({ async = false, lsp_fallback = true })
            end, { desc = "Format file or range" })
          end,
        },

        -- LSP Configuration
        {
          "neovim/nvim-lspconfig",
          dependencies = {
            "hrsh7th/cmp-nvim-lsp",
          },
          config = function()
            -- Get default capabilities from cmp-nvim-lsp
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- LSP configuration using new vim.lsp.config API
            local servers = {
              intelephense = {
                cmd = { 'intelephense', '--stdio' },
                filetypes = { 'php' },
                root_markers = { 'composer.json', '.git' },
                settings = {
                  intelephense = {
                    files = {
                      maxSize = 5000000,
                    }
                  }
                }
              },
              ts_ls = {
                cmd = { 'typescript-language-server', '--stdio' },
                filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
                root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
              },
              html = {
                cmd = { 'vscode-html-language-server', '--stdio' },
                filetypes = { 'html' },
                root_markers = { 'package.json', '.git' },
              },
              cssls = {
                cmd = { 'vscode-css-language-server', '--stdio' },
                filetypes = { 'css', 'scss', 'less' },
                root_markers = { 'package.json', '.git' },
              },
              tailwindcss = {
                cmd = { 'tailwindcss-language-server', '--stdio' },
                filetypes = { 'html', 'css', 'scss', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'php' },
                root_markers = { 'tailwind.config.js', 'tailwind.config.ts', 'tailwind.config.cjs' },
              },
              jsonls = {
                cmd = { 'vscode-json-language-server', '--stdio' },
                filetypes = { 'json', 'jsonc' },
                root_markers = { 'package.json', '.git' },
              },
              nil_ls = {
                cmd = { 'nil' },
                filetypes = { 'nix' },
                root_markers = { 'flake.nix', '.git' },
              },
            }

            -- Setup each LSP server
            for server_name, config in pairs(servers) do
              vim.lsp.config[server_name] = {
                cmd = config.cmd,
                filetypes = config.filetypes,
                root_markers = config.root_markers,
                settings = config.settings,
                capabilities = capabilities,
              }
              vim.lsp.enable(server_name)
            end

            -- LSP keybindings
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
            vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
            vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename' })
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
          end,
        },

        -- Autocompletion
        {
          "hrsh7th/nvim-cmp",
          dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "rafamadriz/friendly-snippets",
          },
          config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
              snippet = {
                expand = function(args)
                  luasnip.lsp_expand(args.body)
                end,
              },
              mapping = cmp.mapping.preset.insert({
                ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
                ['<Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                  else
                    fallback()
                  end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_prev_item()
                  elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                  else
                    fallback()
                  end
                end, { 'i', 's' }),
              }),
              sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
              },
            })
          end,
        },

        -- Treesitter
        {
          "nvim-treesitter/nvim-treesitter",
          build = ":TSUpdate",
          dependencies = {
            "nvim-treesitter/nvim-treesitter-textobjects",
          },
          config = function()
            require('nvim-treesitter.configs').setup({
              ensure_installed = { "php", "javascript", "typescript", "html", "css", "lua", "vue", "json", "yaml", "bash" },
              highlight = { enable = true },
              indent = { enable = true },
              incremental_selection = { enable = true },
            })
          end,
        },

        -- File explorer
        {
          "nvim-tree/nvim-tree.lua",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require("nvim-tree").setup({
              view = {
                width = 30,
              },
              filters = {
                dotfiles = false,
              }
            })
            vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>', { desc = 'Toggle file explorer' })
          end,
        },

        -- Fuzzy finder
        {
          "nvim-telescope/telescope.nvim",
          dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
          },
          config = function()
            local telescope = require('telescope')
            telescope.setup({
              defaults = {
                mappings = {
                  i = {
                    ['<C-u>'] = false,
                    ['<C-d>'] = false,
                  },
                },
              },
            })
            pcall(telescope.load_extension, 'fzf')

            vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find files' })
            vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = 'Live grep' })
            vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>', { desc = 'Find buffers' })
            vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>', { desc = 'Help tags' })
          end,
        },

        -- Status line
        {
          "nvim-lualine/lualine.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require('lualine').setup({
              options = {
                theme = 'catppuccin',
                component_separators = '|',
                section_separators = "",
              },
            })
          end,
        },

        -- Git integration
        { "lewis6991/gitsigns.nvim", config = true },
        { "tpope/vim-fugitive" },

        -- Auto pairs
        { "windwp/nvim-autopairs", config = true },

        -- Comments
        { "numToStr/Comment.nvim", config = true },

        -- Indent guides
        { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = true },

        -- Which-key
        { "folke/which-key.nvim", config = true },

        -- Buffer line
        {
          "akinsho/bufferline.nvim",
          dependencies = { "nvim-tree/nvim-web-devicons" },
          config = function()
            require('bufferline').setup({
              options = {
                mode = "buffers",
                separator_style = "slant",
              }
            })
            vim.keymap.set('n', '<Tab>', ':BufferLineCycleNext<CR>', { desc = 'Next buffer' })
            vim.keymap.set('n', '<S-Tab>', ':BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
            vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Delete buffer' })
          end,
        },

        -- Terminal
        {
          "akinsho/toggleterm.nvim",
          config = function()
            require('toggleterm').setup({
              size = 20,
              open_mapping = [[<c-\>]],
              direction = 'float',
            })
          end,
        },

        -- Emmet for HTML/CSS
        { "mattn/emmet-vim" },

        -- PHP support
        { "phpactor/phpactor", build = "composer install --no-dev -o" },

        -- Surround
        { "tpope/vim-surround" },

        -- Multiple cursors
        { "mg979/vim-visual-multi" },

        -- Laravel Blade syntax
        { "jwalton512/vim-blade" },
      })

      -- Laravel/Blade specific
      vim.cmd([[autocmd BufRead,BufNewFile *.blade.php set filetype=blade]])

      -- Git keybinding
      vim.keymap.set('n', '<leader>gs', ':Git<CR>', { desc = 'Git status' })
    '';
  };

  # --- Font Configuration ---
  fonts.fontconfig.enable = true;

  # --- Environment Variables ---
  # Note: `nixGL` often sets its own environment variables upon execution,
  # but these are good defaults for a Wayland environment.
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
    XDG_SESSION_DESKTOP = "Hyprland";
    GTK_USE_PORTAL = "1";
    # Ensure Nix portals are found first
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:/nix/var/nix/profiles/default/share:/usr/local/share:/usr/share";
    
    # Enhanced Wayland & GDM integration
    NIXOS_OZONE_WL = "1";  # Enable Wayland for Electron apps
    MOZ_ENABLE_WAYLAND = "1";  # Enable Wayland for Firefox
    QT_QPA_PLATFORM = "wayland;xcb";  # Qt apps prefer Wayland
    GDK_BACKEND = "wayland,x11";  # GTK apps prefer Wayland
    SDL_VIDEODRIVER = "wayland";  # SDL apps use Wayland
    CLUTTER_BACKEND = "wayland";  # Clutter apps use Wayland
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    GDK_SCALE = "1";
    GDK_DPI_SCALE = "1";
  };

  xdg.configFile."environment.d/envvars.conf".text = ''
    PATH="$HOME/.nix-profile/bin:$PATH"
    # Essential for Wayland applications
    XDG_SESSION_TYPE=wayland
    XDG_CURRENT_DESKTOP=Hyprland
  '';
xdg.portal = {
  enable = true;
  extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
  ];
  config = {
    common.default = [ "hyprland" "gtk" ];
    hyprland.default = [ "hyprland" "gtk" ];
  };
  xdgOpenUsePortal = true;
};

# Systemd services for xdg-desktop-portal
systemd.user.services.xdg-desktop-portal = {
  Unit = {
    Description = "Portal service";
    PartOf = [ "graphical-session.target" ];
    After = [ "graphical-session.target" ];
  };
  Service = {
    Type = "dbus";
    BusName = "org.freedesktop.portal.Desktop";
    ExecStart = "${pkgs.xdg-desktop-portal}/libexec/xdg-desktop-portal";
    Restart = "on-failure";
    Environment = [
      "XDG_DATA_DIRS=${config.home.homeDirectory}/.nix-profile/share:/nix/var/nix/profiles/default/share:/usr/local/share:/usr/share"
    ];
  };
  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};

systemd.user.services.xdg-desktop-portal-gtk = {
  Unit = {
    Description = "Portal service (GTK/GNOME implementation)";
    PartOf = [ "graphical-session.target" ];
    After = [ "graphical-session.target" ];
    Before = [ "xdg-desktop-portal.service" ];
  };
  Service = {
    Type = "dbus";
    BusName = "org.freedesktop.impl.portal.desktop.gtk";
    ExecStart = "${pkgs.xdg-desktop-portal-gtk}/libexec/xdg-desktop-portal-gtk";
    Restart = "on-failure";
  };
  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};

systemd.user.services.pipewire = {
  Unit = {
    Description = "PipeWire Multimedia Service";
    After = [ "graphical-session-pre.target" ];
    PartOf = [ "graphical-session.target" ];
  };
  Service = {
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    RestrictNamespaces = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = "@system-service";
    UMask = "0077";
    ExecStart = "${pkgs.pipewire}/bin/pipewire";
    Restart = "on-failure";
  };
  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};

systemd.user.services.wireplumber = {
  Unit = {
    Description = "WirePlumber Session Manager";
    After = [ "pipewire.service" ];
    Requires = [ "pipewire.service" ];
    PartOf = [ "graphical-session.target" ];
  };
  Service = {
    LockPersonality = true;
    MemoryDenyWriteExecute = true;
    NoNewPrivileges = true;
    RestrictNamespaces = true;
    SystemCallArchitectures = "native";
    SystemCallFilter = "@system-service";
    UMask = "0077";
    ExecStart = "${pkgs.wireplumber}/bin/wireplumber";
    Restart = "on-failure";
    Environment = [
      "WIREPLUMBER_CONFIG_DIR=${pkgs.wireplumber}/share/wireplumber"
      "WIREPLUMBER_DATA_DIR=${pkgs.wireplumber}/share/wireplumber"
    ];
  };
  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};

systemd.user.services.xdg-desktop-portal-hyprland = {
  Unit = {
    Description = "Portal service (Hyprland implementation)";
    PartOf = [ "graphical-session.target" ];
    After = [ "graphical-session.target" "pipewire.service" ];
    Before = [ "xdg-desktop-portal.service" ];
  };
  Service = {
    Type = "dbus";
    BusName = "org.freedesktop.impl.portal.desktop.hyprland";
    ExecStart = "${pkgs.xdg-desktop-portal-hyprland}/libexec/xdg-desktop-portal-hyprland";
    Restart = "on-failure";
  };
  Install = {
    WantedBy = [ "graphical-session.target" ];
  };
};
#   # --- Hyprland Window Manager Configuration ---
  wayland.windowManager.hyprland = {
    enable = true;
    package = wrapGL pkgs.hyprland;
    # Ensure Hyprland itself is wrapped by nixGL
    systemd.variables = ["--all"];

    # Hyprland Plugins
    plugins = [
      pkgs.hyprlandPlugins.hyprexpo
    ];

    settings = {
      # -----------------------------------------------------------------
      # 1. General Configuration
      # -----------------------------------------------------------------
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 3;
        "col.active_border" = "rgb(448BD2)";  # Sky blue from wallpaper
        "col.inactive_border" = "rgb(5D0C37)"; # Deep rose from wallpaper
        layout = "dwindle";
      };

      # -----------------------------------------------------------------
      # Plugin Configurations
      # -----------------------------------------------------------------

      plugin = {
        # hyprexpo - Workspace overview/expo
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(1A035B)";  # Dark purple from wallpaper
          workspace_method = "center current";

          enable_gesture = true;
          gesture_fingers = 3;
          gesture_distance = 300;
          gesture_positive = true;
        };
      };

      # -----------------------------------------------------------------
      # 2. Input and Display
      # -----------------------------------------------------------------
      input = {
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
        # Modify this to match your keyboard layout
        kb_layout = "us";
        kb_variant = "";
      };

      # Placeholder monitor configuration - change 'DP-1' to your actual monitor name
      monitor = [
      "HDMI-A-1,1920x1080@60,0x0,1"
      "eDP-1,1920x1080@60,1920x0,1"
      ];
      workspace = [
    # Workspaces for HDMI-A-1
    "1,monitor:HDMI-A-1,default:true"   # Workspace 1 on HDMI-A-1 (Default)
    "2,monitor:HDMI-A-1"                # Workspace 2 on HDMI-A-1

    # Workspaces for eDP-1 (The rest)
    "3,monitor:eDP-1,default:true"      # Workspace 3 on eDP-1 (Default)
    "4,monitor:eDP-1"                   # Workspace 4 on eDP-1
    "5,monitor:eDP-1"                   # Workspace 5 on eDP-1
    "6,monitor:eDP-1"                   # Workspace 6 on eDP-1
    "7,monitor:eDP-1"                   # Workspace 7 on eDP-1
    "8,monitor:eDP-1"                   # Workspace 8 on eDP-1
    "9,monitor:eDP-1"                   # Workspace 9 on eDP-1
    "10,monitor:eDP-1"                  # Workspace 10 on eDP-1
];
      
      # -----------------------------------------------------------------
      # 3. Execution on Startup
      # -----------------------------------------------------------------
      exec-once = [
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"  # Essential for portals
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"           # Import env for systemd services
        "hyprpaper"                                 # Start wallpaper utility
        "waybar"                                    # Start status bar
        "swaync"                                    # Start notification daemon
        "nm-applet --indicator"                     # NetworkManager system tray
        "swayidle -w timeout 300 'swaylock -f' before-sleep 'swaylock -f'" # Idle manager
        "wl-paste --type text --watch clipman store" # Start clipboard manager
      ];

      # -----------------------------------------------------------------
      # 4. Window Rules
      # -----------------------------------------------------------------
      #windowrulev1 = "float,title:^(Picture-in-Picture)$";
      windowrulev2 = "float,class:^(Pavucontrol)$";
      #windowrulev3 = "center,float,title:^(Calculator)$";
      
      # -----------------------------------------------------------------
      # 5. Keybindings (All consolidated into a single 'bind' list)
      # -----------------------------------------------------------------
      bind = [
        # --- Session & Utilities ---
        "SUPER, RETURN, exec, alacritty"            # Terminal
        "SUPER, D, exec, wofi --show drun"          # App Launcher
        "SUPER, L, exec, swaylock"                  # Lock screen
        "SUPER_SHIFT, E, exit,"                     # Exit Hyprland
        "SUPER, Q, killactive,"                     # Close active window
        "SUPER, SPACE, togglefloating,"             # Toggle floating state
        "SUPER_SHIFT, SPACE, layoutmsg, togglecycle" # Toggle layout split direction

        # --- Window Navigation (Vim style HJKL) ---
        "SUPER, H, movefocus, l"
        "SUPER, L, movefocus, r"
        "SUPER, K, movefocus, u"
        "SUPER, J, movefocus, d"

        # --- Move Window ---
        "SUPER_SHIFT, H, movewindow, l"
        "SUPER_SHIFT, L, movewindow, r"
        "SUPER_SHIFT, K, movewindow, u"
        "SUPER_SHIFT, J, movewindow, d"
        
        # --- Workspace Switching (1-9) ---
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"

        # --- Move Window to Workspace ---
        "SUPER_SHIFT, 1, movetoworkspace, 1"
        "SUPER_SHIFT, 2, movetoworkspace, 2"
        "SUPER_SHIFT, 3, movetoworkspace, 3"
        "SUPER_SHIFT, 4, movetoworkspace, 4"
        "SUPER_SHIFT, 5, movetoworkspace, 5"
        
        # --- Screenshot Bindings (grim + slurp) ---
        # Take full screenshot and copy to clipboard
        ", PRINT, exec, grim - | wl-copy"
        # Select region for screenshot and copy to clipboard
        "SUPER, PRINT, exec, grim -g \"$(slurp)\" - | wl-copy"
        
        # --- Media and Volume Keys (Uses PipeWire with wpctl) ---
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86MonBrightnessUp, exec, brightnessctl s 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl s 5%-"

        # --- Clipboard Manager ---
        # Show clipboard history and select item (SUPER+V)
        "SUPER, V, exec, clipman pick --tool wofi"
        # Alternative clipboard history with terminal selector (SUPER+SHIFT+V)
        "SUPER_SHIFT, V, exec, alacritty --class floating -e sh -c 'clipman pick --tool STDOUT | head -20 | fzf --reverse | wl-copy'"

        # --- Plugin Keybindings ---

        # hyprexpo - Workspace overview (SUPER+TAB to toggle) 
        "SUPER, TAB, exec, hyprctl dispatch hyprexpo:expo toggle"

        # --- Mouse Bindings (for resize/move floating windows) ---
        #"SUPER, mouse:272, movethiswindow"      # Left Click: Move window
        #"SUPER, mouse:273, resizewindow"      # Right Click: Resize window
        #", mouse_down, workspace, e+1"        # Scroll down to next workspace
        #", mouse_up, workspace, e-1"          # Scroll up to previous workspace
      ];
    };
  };
# home.file.".config/hypr/hyprland.conf".text = ''
# exec-once = dbus-update-activation-environment --systemd --all && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target
# general {
#   border_size=3
#   col.active_border=rgb(89b4fa)
#   col.inactive_border=rgb(45475a)
#   gaps_in=5  gaps_out=10
#   layout=dwindle
# }
#
# input {
#   touchpad {
#     natural_scroll=true
#   }
#   follow_mouse=1
#   kb_layout=us
#   kb_variant=
# }
# bind=SUPER, RETURN, exec, alacritty
# bind=SUPER, D, exec, wofi --show drun
# bind=SUPER, L, exec, swaylock
# bind=SUPER_SHIFT, E, exit,
# bind=SUPER, Q, killactive,
# bind=SUPER, SPACE, togglefloating,
# bind=SUPER_SHIFT, SPACE, layoutmsg, togglecycle
# bind=SUPER, H, movefocus, l
# bind=SUPER, L, movefocus, r
# bind=SUPER, K, movefocus, u
# bind=SUPER, J, movefocus, d
# bind=SUPER_SHIFT, H, movewindow, l
# bind=SUPER_SHIFT, L, movewindow, r
# bind=SUPER_SHIFT, K, movewindow, u
# bind=SUPER_SHIFT, J, movewindow, d
# bind=SUPER, 1, workspace, 1
# bind=SUPER, 2, workspace, 2
# bind=SUPER, 3, workspace, 3
# bind=SUPER, 4, workspace, 4
# bind=SUPER, 5, workspace, 5
# bind=SUPER, 6, workspace, 6
# bind=SUPER, 7, workspace, 7
# bind=SUPER, 8, workspace, 8
# bind=SUPER, 9, workspace, 9
# bind=SUPER_SHIFT, 1, movetoworkspace, 1
# bind=SUPER_SHIFT, 2, movetoworkspace, 2
# bind=SUPER_SHIFT, 3, movetoworkspace, 3
# bind=SUPER_SHIFT, 4, movetoworkspace, 4
# bind=SUPER_SHIFT, 5, movetoworkspace, 5
# bind=, PRINT, exec, grim - | wl-copy
# bind=SUPER, PRINT, exec, grim -g "$(slurp)" - | wl-copy
# bind=, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
# bind=, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
# bind=, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
# bind=, XF86MonBrightnessUp, exec, brightnessctl s 5%+
# bind=, XF86MonBrightnessDown, exec, brightnessctl s 5%-
# exec-once=hyprpaper
# exec-once=waybar
# exec-once=swayidle -w timeout 300 'swaylock -f' before-sleep 'swaylock -f'
# exec-once=wl-paste --type text --watch clipman store
# #exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
# monitor=HDMI-A-1,1920x1080@60,0x0,1
# monitor=eDP-1,1920x1080@60,1920x0,1
# windowrulev2=float,class:^(Pavucontrol)$
# workspace=1,monitor:HDMI-A-1,default:true
# workspace=2,monitor:HDMI-A-1
# workspace=3,monitor:eDP-1,default:true
# workspace=4,monitor:eDP-1
# workspace=5,monitor:eDP-1
# workspace=6,monitor:eDP-1
# workspace=7,monitor:eDP-1
# workspace=8,monitor:eDP-1
# workspace=9,monitor:eDP-1
# workspace=10,monitor:eDP-1
# '';

  # --- GDM & Display Manager Integration ---
  
  # Create system-wide session entry template for GDM
  home.file.".local/share/hyprland-session.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Hyprland (Nix)
      GenericName=Wayland Compositor
      Comment=An intelligent dynamic tiling Wayland compositor (Nix-managed)
      Exec=${config.home.homeDirectory}/.local/bin/start-hyprland
      Icon=hyprland
      Terminal=false
      Type=Application
      Categories=System;
      StartupNotify=false
      Keywords=tiling;wm;windowmanager;wayland;nix;
      DesktopNames=Hyprland
    '';
  };





  # Create a script for starting Hyprland properly from display managers
  home.file.".local/bin/start-hyprland" = {
    text = ''
      #!/bin/bash
      
      # Source Nix profile
      if [ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
        source "$HOME/.nix-profile/etc/profile.d/nix.sh"
      fi
      
      # Set up environment
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=Hyprland
      export XDG_CURRENT_DESKTOP=Hyprland
      
      # Start Hyprland
      exec "$HOME/.nix-profile/bin/Hyprland"
    '';
    executable = true;
  };
}
