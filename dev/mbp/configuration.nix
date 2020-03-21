# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

args@{ config, pkgs, lib, ... }:

let
  layout = pkgs.writeText "xkb-layout" ''
    remove mod4 = Super_L
    add control = Super_L
    remove control = Control_L
    add mod4 = Control_L
  '';
in
{
  imports =
    [ 
      ./hardware-configuration.nix
      (
        import ../../default.nix (
          args
          // {device = "wlp3s0";}
        )
      )
      ../../local.nix
    ];

  networking.hostName = "mbp"; # Define your hostname.
  networking.interfaces.wlp3s0.useDHCP = true;

  # Remap keyboard
  services.xserver.displayManager.sessionCommands = "${pkgs.xorg.xmodmap}/bin/xmodmap ${layout}";

  # USB subsystem wakes up MBP right after suspend unless we disable it.
  services.udev.extraRules = lib.mkDefault ''
    SUBSYSTEM=="pci", KERNEL=="0000:00:14.0", ATTR{power/wakeup}="disabled"
  '';

}