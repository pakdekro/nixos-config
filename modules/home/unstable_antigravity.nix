{ config, pkgs, inputs, ... }:

# =========================================================================
# antigravity (unstable)
# =========================================================================
# Ce fichier permet d'isoler l'installation du paquet antigravity pour
# s'assurer qu'il utilise la branche instable (unstable) de NixOS.
# 
# Pourquoi ? La version "stable" actuelle de NixOS (25.11) ne fournit
# pas une version d'antigravity compatible avec gemini 3.1.
# 
# Comment ça marche ?
# 1. Dans flake.nix, une source "nixpkgs-unstable" a été ajoutée.
# 2. Ici, on utilise cette source (via "inputs.nixpkgs-unstable") pour
#    créer un jeu de paquets "unstable".
# 3. On installe "unstable.antigravity-fhs" au lieu de la version normale.
# 
# Le reste du système reste sur la branche stable.
# =========================================================================

let
  # On instancie les paquets de la branche unstable pour l'architecture actuelle
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
in
{
  # On ajoute uniquement ce paquet instable à votre utilisateur
  home.packages = [
    unstable.antigravity-fhs
  ];
}
