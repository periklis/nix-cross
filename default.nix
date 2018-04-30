let
  pkgs = import ../nixpkgs {};

  crossSystem = rec {
    config = "x86_64-linux-gnu";
    arch = "x86_64";
    withTLS = true;
    libc = "glibc";
    platform = (with pkgs.lib.systems.platforms; pc64 // { kernelMajor = "2.6"; });
    openssl.system = "linux-generic64";
  };

  crossPkgs = import ../nixpkgs {
    inherit crossSystem;

    overlays = [(self: super: {
      glibc = super.glibc.override {
        withLinuxHeaders = false;
      };

      hello = super.hello.override {
        stdenv = super.gccStdenv;
      };
    })];
  };

  /*
    | Package | Build         | Host          | Target       |
    | Stdenv  | x86_64-darwin | x86_64-darwin | x86_64-linux |
    | hello   | x86_64-darwin | x86_64-linux  | x86_64-linux |
  */

in
crossPkgs.hello
