{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "sudo" ];
      theme = "gentoo"; # Ou "agnoster", "powerlevel10k"...
    };
  };

  home.packages = with pkgs; [
    eza      # Remplaçant moderne de 'ls' (couleurs, icônes, arborescence)
    bat      # Remplaçant de 'cat' (syntax highlighting, paging)
    ripgrep  # Remplaçant ultra-rapide de 'grep'
    fd       # Remplaçant user-friendly de 'find'
    tldr     # Des man pages simplifiées (très utile pour apprendre)
    dust  # Remplaçant de 'du' pour visualiser l'espace disque
    bottom   # Remplaçant de 'top/htop' (visualisation graphique)
  ];

  # 2. La liste des alias
  home.shellAliases = {
    # --- NixOS & Home Manager (Les indispensables) ---
    # Rebuild du système (ajuste si tu utilises des Flakes)
    nrs = "sudo nixos-rebuild switch"; 
    # Appliquer la conf Home Manager
    hms = "home-manager switch";
    # Nettoyage du store (garbage collector)
    cleanup = "nix-collect-garbage -d";
    # Recherche rapide d'un paquet
    nixs = "nix search nixpkgs";

    # --- Navigation & Fichiers (Modernisés) ---
    # 'ls' devient 'eza'. L'option --icons nécessite une police NerdFont
    ls = "eza --icons --group-directories-first";
    ll = "eza -l --icons --group-directories-first --git";
    la = "eza -la --icons --group-directories-first --git";
    lt = "eza --tree --level=2 --icons"; # Vue arborescente (génial pour explorer des projets)

    # 'cat' devient 'bat'
    cat = "bat";
    
    # Navigation rapide dans les dossiers parents
    ".." = "cd ..";
    "..." = "cd ../..";
    "...." = "cd ../../..";

    # Espace disque (remplace 'du -h')
    du = "dust";
    
    # Process monitoring (remplace 'top')
    top = "btm"; # Lance 'bottom'

    # --- Utilitaires Système / Sécu "Blue Team" ---
    # Connaitre mon IP publique rapidement
    myip = "curl ifconfig.me";
    
    # Voir les ports en écoute (netstat/ss modernisé)
    ports = "sudo ss -tulpn";
    
    # Grep récursif amélioré (ripgrep)
    grep = "rg";

    # Sécurité basique : demander confirmation avant d'écraser/supprimer
    cp = "cp -i";
    mv = "mv -i";
    rm = "rm -i";

    # --- Git (Workflow rapide) ---
    gs = "git status";
    ga = "git add .";
    gc = "git commit -m";
    gp = "git push";
    gl = "git log --oneline --graph --decorate";
  };
  
  # Petit bonus : activation de 'zoxide' (un 'cd' intelligent)
  # Ce n'est pas un alias, mais ça change la vie pour la navigation
  programs.zoxide = {
    enable = true;
    #enableBashIntegration = true; # ou Zsh/Fish selon ton shell
    enableZshIntegration = true;
  };

}
