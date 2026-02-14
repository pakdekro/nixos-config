{ config, pkgs, ... }:

let
  # On déclare une variable qui va contenir notre paquet personnalisé
  sliver-server = pkgs.stdenv.mkDerivation rec {
    pname = "sliver-server";
    version = "1.7.1"; # Remplace par la dernière release GitHub de BishopFox/sliver

    # Nix va télécharger le binaire directement
    src = pkgs.fetchurl {
      url = "https://github.com/BishopFox/sliver/releases/download/v${version}/sliver-server_linux-amd64";
      
      # L'astuce ultime de Nix : Le faux Hash
      # On met un faux hash. Nix va planter au téléchargement et nous donner le vrai !
      hash = "sha256-+A1EpAwe6xS04CMrPtlwjkdw6YHAPvwV/pJlijzFFv4="; 
    };

    # C'est un binaire brut, Nix ne doit pas essayer de le décompresser (tar/zip)
    dontUnpack = true;

    # La phase d'installation : on crée le dossier bin, on copie, on rend exécutable
    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/bin/sliver
      chmod +x $out/bin/sliver
    '';
  };
in

{
  # Autoriser les paquets non-libres est souvent nécessaire en sécu 
  # (ex: Burp Suite, certains drivers WiFi)
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # ---------------------------------------------------------
    # 1. RECONNAISSANCE & RÉSEAU (Network Analysis)
    # ---------------------------------------------------------
    nmap        # Le standard pour le scan de ports
    dig         # DNS lookup (souvent dans le paquet bind)
    wireshark   # Analyse de paquets graphique (voir note importante plus bas)
    wifite2
    

    # ---------------------------------------------------------
    # 2. WEB PENTESTING
    # ---------------------------------------------------------
    burpsuite   # Proxy d'interception (Community Edition par défaut)
    ffuf        # Fuzzing web rapide (souvent préféré à gobuster pour le fuzzing pur)
    sqlmap      # Injection SQL automatisée
    wpscan      # Scanner spécifique WordPress
    feroxbuster
    nuclei 

    # ---------------------------------------------------------
    # 3. EXPLOITATION & POST-EXPLOITATION
    # ---------------------------------------------------------
    metasploit  # Framework d'exploitation (attention à la config DB)
    thc-hydra   # Brute-force de logins (SSH, FTP, HTTP, etc.)
    hashcat     # Cracking de hashs via GPU (vérifie tes drivers GPU NixOS)
    python313Packages.impacket    # Collection de scripts Python pour les protocoles réseau (SMB, etc.)
    evil-winrm  # Shell WinRM ultime pour les environnements Windows
    ligolo-ng
    bloodhound
    netexec
    sliver-server

    # ---------------------------------------------------------
    # 4. REVERSE ENGINEERING & FORENSICS (Blue Team / Malware Analysis)
    # ---------------------------------------------------------
    ghidra      # Suite de reverse engineering de la NSA
    binwalk     # Analyse et extraction de firmware/fichiers binaires
    volatility3 # Analyse de mémoire RAM (Forensics)
    hayabusa-sec
    
    # ---------------------------------------------------------
    # 5. OSINT & UTILITAIRES DIVERS
    # ---------------------------------------------------------
    theharvester # Récupération d'emails/domaines
    jq          # Processeur JSON (indispensable pour parser les retours d'API)
    seclists
    maigret
    exploitdb
  ];

home.file = {
    # Créer un lien symbolique ~/SecLists qui pointe vers le store
    "Tools/SecLists".source = "${pkgs.seclists}/share/wordlists/seclists";
  };

}
