# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    inetutils
    mtr
    sysstat

    # For ACME Certificates
    certbot
  ];

  #######################################
  # Security/networking important configs
  #######################################

  # Open ports for our domain
  networking = {
    domain = "cutesealfanpage.love";
    firewall.allowedTCPPorts = [ 80 443 ];
  };

  # Add acme LetsEncrypt certs
  security.acme = {
    acceptTerms = true;
    validMinDays = 999;
    email = "admin@cutesealfanpage.love";

    # uncomment this to use the staging server
    server = "https://acme-staging-v02.api.letsencrypt.org/directory";
  };

  #######################################
  # List services that you want to enable
  #######################################
  services = {
    # Enable the OpenSSH daemon.
    openssh = {
      enable = true;
      permitRootLogin = "no";
    };

    # Enable the Longview Agent
    # https://www.linode.com/docs/tools-reference/custom-kernels-distros/install-nixos-on-linode/#enable-longview-agent-optional
    longview = {
      enable = true;
      apiKeyFile = "/var/lib/longview/apiKeyFile";
    };

    # Nginx config
    nginx = {
      enable = true;
      statusPage = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      # https://nixos.org/nixos/manual/#module-security-acme-nginx
      virtualHosts = {

        "cutesealfanpage.love" = {
          enableACME = true;
          forceSSL = true;
          locations."/" = { proxyPass = "http://127.0.0.1:8000"; };
        };
      };
    };
  };


  #######################################
  # Define a user account. Don't forget to set a password with ‘passwd’.
  #######################################
  users.users.alice = {
    isNormalUser = true;
    home = "/home/alice";
    description = "Alice Foobar";
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "networkmanager"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMeBlGnpJ7dTVcrDdYlMsXFhADIYLc4K/acgsxwbZPOA alice@foobar"
    ];
  };


  #######################################
  # NixOS / Linode special options and/or incancations
  #######################################
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?

  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # special options and/or incancations
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  networking.useDHCP = false;
  networking.interfaces.eth0.useDHCP = true;
  networking.usePredictableInterfaceNames = false;
}
