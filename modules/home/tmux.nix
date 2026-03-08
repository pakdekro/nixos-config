{ pkgs, ... }:

{
  programs.tmux = {
    # Active la gestion de tmux par Home Manager
    enable = true;

    # --- 1. Options Natives de Home Manager ---
    # Il est préférable d'utiliser ces options typées plutôt que 'extraConfig'
    # car Nix gère la syntaxe et les valeurs par défaut pour vous.

    # Remplace: unbind C-b / set-option -g prefix C-a
    shortcut = "a";

    # Remplace: set -g base-index 1
    # Note: Home Manager gère aussi automatiquement pane-base-index avec cette option
    baseIndex = 1;

    # Remplace: setw -g mode-keys vi
    keyMode = "vi";

    # Remplace: set -g mouse on
    mouse = true;

    # Remplace: set -g history-limit 10000
    historyLimit = 10000;

    # Remplace: set -g default-terminal "screen-256color"
    terminal = "screen-256color";

    # Option recommandée (non présente dans ta config initiale mais vitale)
    # Réduit le délai d'attente après la touche ESC (essentiel pour vim/neovim)
    escapeTime = 0;

    # --- 2. Configuration Brute (extraConfig) ---
    # Ici, nous mettons tout ce qui est spécifique : bindings, UI, couleurs.
    # L'utilisation de '' (multi-line string) permet de coller la config presque telle quelle.
    extraConfig = ''
      # ============= CONFIGURATION DE BASE =============
      # Rechargement de la config
      # Note sur Nix : Ce fichier est un lien symbolique vers le Nix Store (lecture seule).
      # 'source-file' rechargera le fichier généré actuel.
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config rechargée!"

      # ============= NAVIGATION AMÉLIORÉE =============
      # Navigation entre panneaux (Alt+flèches)
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Navigation entre fenêtres (Shift+flèches)
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # Diviser les panneaux (Split)
      # #{pane_current_path} est la syntaxe tmux, Nix l'ignorera (c'est ce qu'on veut)
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Redimensionner les panneaux (Vim style)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # ============= MODE COPIE VIM & PRESSE-PAPIER =============
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      # Amélioration Nix : On appelle directement le binaire xclip du store Nix
      # Cela garantit que la commande fonctionne même si xclip n'est pas dans le PATH global
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.xclip}/bin/xclip -selection clipboard"
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

      # ============= APPARENCE =============
      # Support TrueColor (Tc)
      set -ga terminal-overrides ",xterm-256color*:Tc"

      # Barre de statut
      set -g status-position bottom
      set -g status-bg colour234
      set -g status-fg colour137
      set -g status-left-length 20
      set -g status-right-length 50
      
      # Status Left
      set -g status-left '#[fg=colour233,bg=colour241,bold] #S #[fg=colour241,bg=colour235,nobold]'
      
      # Status Right (Format date/heure standard)
      set -g status-right '#[fg=colour233,bg=colour241,bold] %d/%m #[fg=colour233,bg=colour245,bold] %H:%M:%S '

      # Style des fenêtres
      setw -g window-status-current-format ' #I#[fg=colour250]:#[fg=colour255]#W#[fg=colour50]#F '
      setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '
    '';
  };

  # (Optionnel) Ajoute xclip aux paquets utilisateur si tu veux l'utiliser en dehors de tmux
  home.packages = [ pkgs.xclip ];
}
