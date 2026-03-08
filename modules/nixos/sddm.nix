{ pkgs, lib, ... }:

{
  # --- ECRAN DE CONNEXION (SDDM) ---
  environment.systemPackages = [
    (pkgs.catppuccin-sddm.override {
      flavor = "mocha";
      font  = "JetBrainsMono Nerd Font";
      fontSize = "9";
      loginBackground = true;
    })
  ];

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    
    # On force le thème pour éviter que Stylix ne l'écrase
    theme = lib.mkForce "catppuccin-mocha-mauve";
  };
}
