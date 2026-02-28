{ config, pkgs, ... }:

{
  # ==========================================
  # CONFIGURATION UTILISATEUR HOME MANAGER
  # ==========================================

  home.username = "pak";
  home.homeDirectory = "/home/pak";

  # État de la version Home Manager (ne pas changer sauf upgrade)
  home.stateVersion = "25.11";

  # ==========================================
  # MODULES IMPORTÉS
  # ==========================================
  imports = [
    ./modules/home/zsh.nix
    ./modules/home/nvim.nix
    ./modules/home/cyber.nix
    ./modules/home/hypr.nix
    ./modules/home/kitty.nix
    ./modules/home/tmux.nix
  ];

  # ==========================================
  # PAQUETS UTILISATEUR
  # ==========================================
  home.packages = with pkgs; [
    # --- COMMUNICATION & SOCIAL ---
    discord    
    protonmail-desktop
    
    # --- MUSIQUE & MEDIA ---
    deezer-enhanced
    pavucontrol # Contrôle du volume
    
    # --- PRODUCTIVITÉ & NOTES ---
    obsidian
    
    # --- DEVELOPPEMENT & OUTILS ---
    git	
    vscode-fhs
    gemini-cli
    nemo                  # Le gestionnaire de fichiers en lui-même
    nemo-fileroller       # Le plugin Nemo pour faire le pont avec les archives
    file-roller           # Le logiciel d'archives (GUI) appelé par le plugin
    unzip
    pipx
    comma # "run without install" (ex: , python)
    psmisc
    
    # --- AI & DATA ---
    ollama

    # --- RESEAU & VPN ---
    blueman # Gestion Bluetooth GUI
    protonvpn-gui
    wg-netmanager
    networkmanager-openvpn
    
    # --- SYSTEME & VIRTUALISATION ---
    virt-viewer
    antigravity-fhs 
  ];

  # ==========================================
  # PROGRAMMES & SERVICES
  # ==========================================

  # Utilitaire pour trouver dans quel paquet se trouve une commande (nix-locate)
  programs.nix-index = {
    enable = true;
    enableZshIntegration = true; 
  };

  # Gestionnaire de fichiers de configuration
  home.file = {
    # Exemples :
    # ".screenrc".source = dotfiles/screenrc;
  };

  # Variables d'environnement de session
  home.sessionVariables = {
    # EDITOR = "nvim";
  };

  # Activation de Home Manager
  programs.home-manager.enable = true;
}
