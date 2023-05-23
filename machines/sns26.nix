{ config, pkgs, lib, ... }:

let
  backupHosts = [
    # alpha machines
    # beta machines
    "sns26"
    # gamma machines
    "sns62"
  ];

in
{
  imports = [
    ../sns-cluster
  ];

  networking = {
    hostId = "90591947";
    hostName = "sns26";

    interfaces."enp1s0f0" = {
      useDHCP = true;
    };
  };

  sns-machine = {
    enable = true;

    family.beta = {
      enable = true;

      bootDiskNode = "/dev/disk/by-id/ata-WDC_WD1003FBYX-01Y7B0_WD-WCAW30746204";
      bootPartUUID = "6C32-5AFA";
      swapPartUUID = "9463b40d-f607-416c-af0c-d95c9ff1eb6f";
    };
  };

  fileSystems."/var/lib/syncoid" = {
    device = "/var/state/syncoid-home";
    fsType = "none";
    options = [ "bind" ];
  };

  services.syncoid = {
    enable = true;
    sshKey = "/var/lib/syncoid/.ssh/id_ed25519";
    commands = let
      hostCommand = hostname: {
        # Created beforehand using:
        # zfs create -o mountpoint=none -o compression=lz4 rpool/cluster-backups
        target = "rpool/cluster-backups/${hostname}";
        source = "backup-ssh@${hostname}.cs.princeton.edu:rpool/state";
        recursive = true;
        extraArgs = [ "--keep-sync-snap" ];
      };
    in
      lib.genAttrs backupHosts hostCommand;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
