{ config, pkgs, inputs, ... }:

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
    ./modules/home/unstable_antigravity.nix
  ];

  # ==========================================
  # PAQUETS UTILISATEUR
  # ==========================================
  home.packages = with pkgs; [
    # --- COMMUNICATION & SOCIAL ---
    discord
    publii
    
    # --- MUSIQUE & MEDIA ---
    deezer-enhanced
    pavucontrol # Contrôle du volume
    vlc
    catt
    
    # --- PRODUCTIVITÉ & NOTES ---
    obsidian
    onlyoffice-desktopeditors

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
    python314

    # --- RESEAU & VPN ---
    blueman # Gestion Bluetooth GUI
    protonvpn-gui
    wg-netmanager
    networkmanager-openvpn
    kdePackages.ktorrent
    
    # --- SYSTEME & VIRTUALISATION ---
    virt-viewer
    kdePackages.dolphin
    kdePackages.kio-extras # Support pour les partages réseau (smb://, sftp://) dans Dolphin
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
