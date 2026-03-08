{ config, pkgs, ... }:

{

  # --- Environnement de bureau (KDE Plasma 6) ---
  services.desktopManager.plasma6.enable = true;

  # --- Nettoyage du système ---
  # Exclusion des applications KDE par défaut qui font doublon
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    plasma-browser-integration
    konsole      # Remplacé par Kitty
    oxygen       # Thèmes obsolètes
    kate         # Remplacé par Neovim/VSCode
    elisa        # Lecteur musical non requis
  ];

  # --- Intégration & Services ---
  # KDE Connect (Attention: ouvre les ports TCP/UDP 1714 à 1764)
  programs.kdeconnect.enable = true;

  # --- Sécurité (PAM) ---
  # Déverrouillage automatique du portefeuille KDE (KWallet) au login
  security.pam.services.sddm.enableKwallet = true;
}
