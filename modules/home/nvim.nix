{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    # LazyVim a besoin de ces paquets pour fonctionner (Telescope, Treesitter, Lsp)
    extraPackages = with pkgs; [
      ripgrep
      fd
      gcc           # Pour compiler Treesitter
      gnumake
      unzip
      nodejs        # Pour certains LSP
      wl-clipboard  # Pour le copier-coller (Wayland) ou xclip (X11)
      # xclip       # Décommente si tu es sous X11
    ];
  };

  # Astuce : On peut bootstraper la config LazyVim si elle n'existe pas
  # Mais pour commencer, contentons-nous d'installer les outils.
}
