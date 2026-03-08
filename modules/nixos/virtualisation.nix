{ config, pkgs, ... }:

{
  # ==========================================
  # VIRTUALISATION
  # ==========================================
  
  virtualisation.docker.enable = true;
  virtualisation.vmware.host.enable = true;
}
