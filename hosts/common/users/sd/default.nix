{
  pkgs,
  config,
  lib,
  ...
}: let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  users.mutableUsers = false;
  users.users.sd = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = ifTheyExist [
      "audio"
      "deluge"
      "docker"
      "git"
      "i2c"
      "libvirtd"
      "lxd"
      "minecraft"
      "mysql"
      "network"
      "plugdev"
      "podman"
      "video"
      "wheel"
      "wireshark"
    ];

#    openssh.authorizedKeys.keys = lib.splitString "\n" (builtins.readFile ../../../../home/sd/ssh.pub);
#    hashedPasswordFile = config.sops.secrets.sd-password.path;
    packages = [pkgs.home-manager];
  };

  sops.secrets.sd-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  home-manager.users.sd = import ../../../../home/sd/${config.networking.hostName}.nix;

  security.pam.services = {
    swaylock = {};
  };
}
