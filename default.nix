let
  buildSystem = rec {
    config = "x86_64-darwin";
    system = "x86_64-darwin";
    libc = "libSystem";
    isDarwin = true;
    isWindows = false;
    isCygwin = false;
    isLinux = false;
  };

  hostSystem = rec {
    config = "x86_64-linux-gnu";
    arch = "x86_64";
    withTLS = true;
    libc = "glibc";
    platform = (with buildPkgs.lib.systems.platforms; pc64 // { kernelMajor = "2.6"; });
    openssl.system = "linux-generic64";
    isDarwin = false;
    isWindows = false;
    isCygwin = false;
    isLinux = true;
  };

  targetSystem = rec {
    config = "x86_64-linux-gnu";
    arch = "x86_64";
    withTLS = true;
    libc = "glibc";
    platform = (with buildPkgs.lib.systems.platforms; pc64 // { kernelMajor = "2.6"; });
    openssl.system = "linux-generic64";
    isDarwin = false;
    isWindows = false;
    isCygwin = false;
    isLinux = true;
  };

  buildPkgs = import ../nixpkgs {};

  targetPkgs = import ../nixpkgs {
    crossSystem = targetSystem;

    overlays = [(self: super: {
      glibc = self.callPackage ../nixpkgs/pkgs/development/libraries/glibc {
        withLinuxHeaders = false;
      };

      # glibcCross = super.callPackage ../nixpkgs/pkgs/development/libraries/glibc {
      #   withLinuxHeaders = false;
      #   installLocales = super.config.glibc.locales or false;
      #   stdenv = self.crossLibcStdenv;
      #   # stdenv = buildPkgs.crossLibcStdenv;
      #   # stdenv = self.clangStdenv;
      # };
    })];
  };

  /*
    | Package | Build         | Host          | Target       |
    | Stdenv  | x86_64-darwin | x86_64-darwin | x86_64-linux |
    | hello   | x86_64-darwin | x86_64-linux  | x86_64-linux |
  */

in
targetPkgs.hello
