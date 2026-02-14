{ config, pkgs, ... }:

{
  # --- Paquets nécessaires pour l'environnement ---
  home.packages = with pkgs; [
    # Outils Système
    waybar
    rofi
    swaynotificationcenter # Centre de notifs (mieux que Dunst)
    networkmanagerapplet   # Icône Wi-Fi
    
    # Gestion Audio/Luminosité
    pamixer
    brightnessctl
    
    # Screenshot & Presse-papier
    grim
    slurp
    swappy
    wl-clipboard
    
    # Gestion Session
    wlogout
    hyprlock
  ];

  # --- CONFIGURATION HYPRLAND ---
  wayland.windowManager.hyprland = {
    enable = true;
    
    settings = {
      
      # Lanceurs au démarrage
      exec-once = [
        "waybar"
        "swaync"
        "nm-applet --indicator"
      ];

      # --- ECRANS ---
      # Laptop (eDP-1): 2880px / 1.2 = 2400px de large logiques.
      # TV (DP-2): Placée à 2400x0.
      monitor = [
        "eDP-1, 2880x1920@120, 0x0, 1.2"
        "DP-2, 3840x2160@60, 2400x0, 1"
        ", preferred, auto, 1" # Fallback
      ];

      # --- CLAVIER & SOURIS ---
      input = {
        kb_layout = "fr";
        follow_mouse = 1;
        touchpad.natural_scroll = "no";
      };

      # --- APPARENCE ---
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        # Stylix gère les couleurs des bordures (active/inactive)
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        
        # Le Flou (Blur) est essentiel pour la transparence de Kitty
        blur = {
            enabled = true;
            size = 5;
            passes = 3; # 3 passes = flou très qualitatif
            new_optimizations = true;
            ignore_opacity = true;
        };
        
        # Ombres
        shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
        };
      };

      animations = {
        enabled = "yes";
        bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
        animation = [
          "windows, 1, 7, myBezier"
          "windowsOut, 1, 7, default, popin 80%"
          "border, 1, 10, default"
          "fade, 1, 7, default"
          "workspaces, 1, 6, default"
        ];
      };

      dwindle = {
        pseudotile = "yes";
        preserve_split = "yes";
      };

      # --- RACCOURCIS (KEYBINDINGS) ---

"$mod" = "SUPER";

      bind = [
        "$mod, Q, exec, kitty"
        "$mod, E, exec, dolphin"
        "$mod, R, exec, rofi -show drun"
        "$mod, C, killactive,"
        "$mod, V, togglefloating,"
        "$mod, F, fullscreen,"
        "$mod, M, exit,"
        ", Print, exec, grim -g \"$(slurp)\" - | swappy -f -"

        # Navigation VIM
        "$mod, h, movefocus, l"
        "$mod, l, movefocus, r"
        "$mod, k, movefocus, u"
        "$mod, j, movefocus, d"

        "$mod SHIFT, h, movewindow, l"
        "$mod SHIFT, l, movewindow, r"
        "$mod SHIFT, k, movewindow, u"
        "$mod SHIFT, j, movewindow, d"

        # --- CORRECTION WORKSPACES ---
        # Méthode simple et explicite pour 1-9
        # Touche 1 (&)
        "$mod, ampersand, workspace, 1"
        "$mod SHIFT, ampersand, movetoworkspace, 1"

        # Touche 2 (é)
        "$mod, eacute, workspace, 2"
        "$mod SHIFT, eacute, movetoworkspace, 2"

        # Touche 3 (")
        "$mod, quotedbl, workspace, 3"
        "$mod SHIFT, quotedbl, movetoworkspace, 3"

        # Touche 4 (')
        "$mod, apostrophe, workspace, 4"
        "$mod SHIFT, apostrophe, movetoworkspace, 4"

        # Touche 5 (()
        "$mod, parenleft, workspace, 5"
        "$mod SHIFT, parenleft, movetoworkspace, 5"

        # Touche 6 (-)
        "$mod, minus, workspace, 6"
        "$mod SHIFT, minus, movetoworkspace, 6"

        # Touche 7 (è)
        "$mod, egrave, workspace, 7"
        "$mod SHIFT, egrave, movetoworkspace, 7"

        # Touche 8 (_)
        "$mod, underscore, workspace, 8"
        "$mod SHIFT, underscore, movetoworkspace, 8"

        # Touche 9 (ç)
        "$mod, ccedilla, workspace, 9"
        "$mod SHIFT, ccedilla, movetoworkspace, 9"

        # Touche 0 (à)
        "$mod, agrave, workspace, 10"
        "$mod SHIFT, agrave, movetoworkspace, 10"

        # Scroll souris sur les workspaces (très pratique)
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];
    };
  };

  # --- CONFIGURATION WAYBAR (Island Style) ---
  programs.waybar = {
    enable = true;
    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-weight: bold;
        font-size: 14px;
        min-height: 0;
      }
      window#waybar {
        background: transparent;
        color: #cdd6f4;
      }
      .modules-left, .modules-center, .modules-right {
        background: #1e1e2e;
        border-radius: 20px;
        padding: 5px 15px;
        margin-top: 5px;
        border: 2px solid #313244;
      }
      .modules-left { margin-left: 10px; }
      .modules-right { margin-right: 10px; }
      
      #workspaces button { padding: 0 5px; color: #bac2de; }
      #workspaces button.active { color: #a6e3a1; }
      
      #clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray { padding: 0 10px; }
      #network { color: #f9e2af; }
    '';

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 36;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "bluetooth" "cpu" "memory" "pulseaudio" "power-profiles-daemon""battery" "tray" ];
        
        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "一"; "2" = "二"; "3" = "三"; "4" = "四"; "5" = "五";
            "urgent" = ""; "active" = ""; "default" = "";
          };
        };
        "clock" = { format = "{:%H:%M  📅 %d/%m}"; };
        "bluetooth" = {
          format = " {status}";
          format-connected = " {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
          # Lance le gestionnaire Bluetooth au clic
          on-click = "blueman-manager";
        };
	"network" = {
          format-wifi = "  {essid}";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "  Disconnected";
          tooltip-format = "{ifname} via {gwaddr}";
          # Lance l'éditeur de connexion au clic
          on-click = "nm-connection-editor";
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-icons = { default = ["" "" ""]; };
          on-click = "pavucontrol"; # Lance le mixeur audio
        };
        "cpu" = { format = " {usage}%"; };
	"power-profiles-daemon" = {
          format = "{icon}";
          tooltip-format = "Power profile: {profile}\nDriver: {driver}";
          tooltip = true;
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };
        "memory" = { format = " {}%"; };
      };
    };
  };

  # --- CONFIGURATION ROFI (Spotlight Style) ---
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    extraConfig = {
      modi = "drun,run";
      show-icons = true;
      drun-display-format = "{icon} {name}";
      disable-history = false;
      display-drun = "   Apps ";
      display-run = "   Run ";
      sidebar-mode = true;
    };
  };
}
