{ config, pkgs, lib, ... }:

{
  programs.kitty = {
    enable = true;
    
    settings = {
      # --- Apparence ---
      background_opacity = lib.mkForce "0.85"; # Transparence (0.85 est un bon équilibre)
      window_padding_width = 15;   # Espace entre la bordure et le texte
      
      # --- Comportement ---
      confirm_os_window_close = 0; # Ne pas demander confirmation à la fermeture
      enable_audio_bell = false;   # Pas de "bip" sonore
      copy_on_select = "yes";      # Copie automatique lors de la sélection
      
      # --- Shell ---
      shell_integration = "enabled";
    };
  };
}
