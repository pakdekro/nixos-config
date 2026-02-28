# Fichier de configuration principal du système NixOS
{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ 
      # Configuration Matérielle
      ./hardware-configuration.nix
      
      # Modules Système
      ./modules/nixos/stylix.nix
      ./modules/nixos/sddm.nix
    ];

  # ==========================================
  # SYSTEME DE FICHIERS & BOOT
  # ==========================================
  
  # Bootloader Systemd-boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Utilisation du dernier noyau Linux stable
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Activation de nix-ld pour exécuter des binaires non-Nix
  programs.nix-ld.enable = true;


  # ==========================================
  # RESEAU & CONNECTIVITE
  # ==========================================
  
  networking.hostName = "radium"; 
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  
  # Gestion de l'énergie (important pour laptop)
  services.power-profiles-daemon.enable = true;


  # ==========================================
  # VIRTUALISATION
  # ==========================================
  
  virtualisation.docker.enable = true;
  virtualisation.vmware.host.enable = true;


  # ==========================================
  # LOCALISATION & TEMPS
  # ==========================================
  
  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "fr_FR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };
  
  # Clavier console
  console.keyMap = "fr";


  # ==========================================
  # ENVIRONNEMENT GRAPHIQUE
  # ==========================================

  # Serveur X11 (nécessaire pour certains jeux/apps et login manager)
  services.xserver.enable = true;
  
  # Clavier X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  # Hyprland (Session Wayland)
  programs.hyprland.enable = true;

  # Utilisation de Ozone pour les problèmes de scaling
  environment.sessionVariables = {
    # Force les applications Electron (Discord, VSCode, etc.) à utiliser Wayland nativement
    NIXOS_OZONE_WL = "1";
  };

  # on active dconf pour les appli GTK
  programs.dconf.enable = true;

  # ==========================================
  # SON & IMPRIMANTES
  # ==========================================

  # Serveur d'impression CUPS
  services.printing.enable = true;

  # Son avec Pipewire (remplace Pulseaudio)
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  # Désactive l'ancien Pulseaudio
  services.pulseaudio.enable = false;


  # ==========================================
  # UTILISATEURS & SYSTEME
  # ==========================================

  # Définition de l'utilisateur 'pak'
  users.users.pak = {
    isNormalUser = true;
    description = "pak";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    ];
  };

  # Activation de ZSH au niveau système
  programs.zsh.enable = true;

  # Installation de Firefox
  programs.firefox.enable = true;

  # Autoriser les paquets non-libres (drivers, vscode, spotify, etc.)
  nixpkgs.config.allowUnfree = true;

  # Fonctionnalités expérimentales de Nix (Flakes)
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Version du système (NE PAS CHANGER sauf upgrade majeur)
  system.stateVersion = "25.11"; 

}
