{ config, pkgs, lib, ... }:

{
  # --- Paquets nécessaires pour l'environnement ---
  home.packages = with pkgs; [
    # Outils Système
    waybar
    
    # Rofi principal (qui intègre désormais le support natif Wayland)
    rofi 
    
    # Plugins Rofi demandés
    rofi-power-menu      # Menu d'extinction/reboot
    rofi-network-manager # Script natif Rofi pour gérer Wi-Fi ET VPN via NetworkManager

    swaynotificationcenter # Centre de notifs (mieux que Dunst)
    networkmanagerapplet   # Icône Wi-Fi (Tray)
    
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
        layout = "dwindle";
      };

      decoration = {
        rounding = 10;
        
        blur = {
            enabled = true;
            size = 5;
            passes = 3;
            new_optimizations = true;
            ignore_opacity = true;
        };
        
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
        
        # Lancement Rofi (Apps)
        "$mod, R, exec, rofi -show drun"
        
        # Rofi Power Menu
        "$mod, P, exec, rofi -show power-menu -modi power-menu:rofi-power-menu"
        
        # Rofi Network / VPN Menu avec le nouveau paquet
        "$mod, N, exec, rofi-network-manager"

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

        # --- WORKSPACES ---
        "$mod, ampersand, workspace, 1"
        "$mod SHIFT, ampersand, movetoworkspace, 1"
        "$mod, eacute, workspace, 2"
        "$mod SHIFT, eacute, movetoworkspace, 2"
        "$mod, quotedbl, workspace, 3"
        "$mod SHIFT, quotedbl, movetoworkspace, 3"
        "$mod, apostrophe, workspace, 4"
        "$mod SHIFT, apostrophe, movetoworkspace, 4"
        "$mod, parenleft, workspace, 5"
        "$mod SHIFT, parenleft, movetoworkspace, 5"
        "$mod, minus, workspace, 6"
        "$mod SHIFT, minus, movetoworkspace, 6"
        "$mod, egrave, workspace, 7"
        "$mod SHIFT, egrave, movetoworkspace, 7"
        "$mod, underscore, workspace, 8"
        "$mod SHIFT, underscore, movetoworkspace, 8"
        "$mod, ccedilla, workspace, 9"
        "$mod SHIFT, ccedilla, movetoworkspace, 9"
        "$mod, agrave, workspace, 10"
        "$mod SHIFT, agrave, movetoworkspace, 10"

        # Scroll souris sur les workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      # Binds avec 'e' (repeat) pour maintenir la touche enfoncée
      binde = [
        # Audio
        ", XF86AudioRaiseVolume, exec, pamixer -i 5"
        ", XF86AudioLowerVolume, exec, pamixer -d 5"
        ", XF86AudioMute, exec, pamixer -t"
        
        # Luminosité (Brightness)
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
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
        font-weight: bold;
        font-size: 14px;
        min-height: 0;
      }
      window#waybar { background: transparent; color: #cdd6f4; }
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
        layer = "top"; position = "top"; height = 36;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "bluetooth" "cpu" "memory" "pulseaudio" "power-profiles-daemon" "battery" "tray" ];
        
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
          on-click = "blueman-manager";
        };
        "network" = {
          format-wifi = "  {essid}";
          format-ethernet = "  {ipaddr}";
          format-disconnected = "  Disconnected";
          on-click = "rofi-network-manager"; # Mise à jour de la commande au clic
        };
        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-icons = { default = ["" "" ""]; };
          on-click = "pavucontrol";
        };
        "cpu" = { format = " {usage}%"; };
        "power-profiles-daemon" = {
          format = "{icon}";
          format-icons = { default = ""; performance = ""; balanced = ""; power-saver = ""; };
        };
        "memory" = { format = " {}%"; };
      };
    };
  };

  # --- CONFIGURATION ROFI ---
  programs.rofi = {
    enable = true;
    package = pkgs.rofi; # Utilise désormais le paquet standard mergé
    
    # On force Rofi à utiliser notre fichier de thème généré ci-dessous
    # lib.mkForce est indispensable ici pour écraser la configuration dynamique de Stylix
    theme = lib.mkForce "~/.config/rofi/theme.rasi";
    
    extraConfig = {
      modi = "drun,run,power-menu:rofi-power-menu";
      show-icons = true;
      icon-theme = "Papirus"; # Assure-toi d'avoir un icon theme installé
      drun-display-format = "{icon} {name}";
      disable-history = false;
      display-drun = "   Apps ";
      display-run = "   Run ";
      sidebar-mode = false;
    };
  };

  # --- INJECTION DES FICHIERS DE CONFIGURATION DECLARATIFS ---
  
  # Le Thème Rofi "Spotlight" (S'applique automatiquement à rofi, rofi-network-manager et rofi-power-menu)
  xdg.configFile."rofi/theme.rasi".text = ''
    * {
        bg-col:  #1e1e2e; /* Fond sombre */
        bg-alt:  #282839; /* Fond barre de recherche */
        fg-col:  #cdd6f4; /* Texte blanc clair */
        blue:    #74c7ec; /* Bleu de la capture pour la sélection */
        fg-col2: #1e1e2e; /* Texte noir sur élément sélectionné */
        border-col: #313244;
        
        background-color: transparent;
        text-color: @fg-col;
        margin: 0px;
        padding: 0px;
        spacing: 0px;
    }

    window {
        background-color: @bg-col;
        border: 2px solid;
        border-color: @border-col;
        border-radius: 12px;
        width: 600px;
        padding: 15px;
        location: center;
    }

    mainbox {
        background-color: transparent;
        children: [ inputbar, listview ];
    }

    inputbar {
        children: [ prompt, entry ];
        background-color: @bg-alt;
        border-radius: 8px;
        padding: 12px;
        margin: 0px 0px 15px 0px;
    }

    prompt {
        text-color: @fg-col;
        margin: 0px 10px 0px 5px;
    }

    entry {
        placeholder: "Search...";
        placeholder-color: #a6adc8;
        text-color: @fg-col;
        background-color: transparent;
    }

    listview {
        background-color: transparent;
        columns: 1;
        lines: 8;
        scrollbar: false;
        spacing: 5px;
    }

    element {
        padding: 10px;
        border-radius: 8px;
        background-color: transparent;
    }

    element normal.normal, element alternate.normal {
        background-color: transparent;
    }

    element selected.normal {
        background-color: @blue;
        text-color: @fg-col2;
    }

    element-text {
        vertical-align: 0.5;
        background-color: inherit;
        text-color: inherit;
    }

    element-icon {
        size: 24px;
        margin: 0px 15px 0px 0px;
        background-color: inherit;
    }
  '';
}
