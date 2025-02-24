# Configured as a workstation for @alevy, primarily for testing stuff on the
# cluster. If this comment is still here after November 2020, you can take over
# this machine with a PR.

{ config, pkgs, ... }:

let
  hostname = "sns29";
  common = (import ./common.nix) { hostname = hostname; };
  utils = import ../utils;
in {

  # Import common configurat for all machines (locale, SSHd, updates...)
  imports = [ common ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  ];

  programs.mosh.enable = true;

  users.mutableUsers = false;

  users.users.alevy = {
    isNormalUser = true;
    extraGroups = [ "wheel" "snapfaas" ];
    openssh.authorizedKeys.keys = utils.githubSSHKeys "alevy";
  };

  users.users.npopescu = {
    isNormalUser = true;
    extraGroups = [ "snapfaas" ];
    openssh.authorizedKeys.keys = utils.githubSSHKeys "nataliepopescu";
  };
  
  users.users.kw22 = {
    isNormalUser = true;
    extraGroups = [ "snapfaas" ];
    openssh.authorizedKeys.keys = utils.githubSSHKeys "kw1122";
  };
}
