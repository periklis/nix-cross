let
  pkgs = import ../../ptsirakidis/nix-config/nixpkgs {};

  crossSystem = rec {
    config = "x86_64-linux-gnu";
    arch = "x86_64";
    # withTLS = true;
    # libc = "glibc";
    platform = (with pkgs.lib.systems.platforms; pc64 // { kernelMajor = "2.6"; });
  #   openssl.system = "linux-generic64";
  };

  crossPkgs = import ../../ptsirakidis/nix-config/nixpkgs {
    inherit crossSystem;
  };
in
pkgs.dockerTools.buildImage{
 name = "nixos-cross-hello";
 tag  = "latest";

 contents = crossPkgs.hello;

 config = {
 Cmd = [ "./bin/hello" ];
 };
}
