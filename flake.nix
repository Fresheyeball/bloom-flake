{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    freedoom = {
      url = "https://github.com/freedoom/freedoom/releases/download/v0.12.1/freedoom-0.12.1.zip";
      flake = false;
    };
    bloom = {
      url = "https://www.moddb.com/downloads/mirror/222826/124/254b69a62b9d85f85de23bf838ef3062";
      flake = false;
    };
  };
  outputs = { self, nixpkgs, freedoom, bloom, ... }: let

    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system;};

  in {

    packages.${system}.bloom = with pkgs; runCommand "Bloom" {
      buildInputs = [ unzip ];
    } ''
      unzip ${bloom}
      mkdir $out
      cp -r Bloom_Final_Release_GzDoom/gzdoom-4-6-0-Windows-64bit/* $out
    '';

    defaultApp.${system} = with pkgs; writeShellApplication
        { name = "doom-mod.sh";
          runtimeInputs = [
            gzdoom
          ];
          text = ''
            install -d ~/.config/gzdoom
            install -D ${freedoom}/* ~/.config/gzdoom/
            gzdoom ${self.outputs.packages.${system}.bloom}/Bloom.pk3
          '';
        };
  };
}
