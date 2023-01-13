{
  description = "Nix Presentation";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11"; };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system}.default = pkgs.mkYarnPackage rec {
        name = "nix-presentation";
        version = (pkgs.lib.importJSON (src + "/package.json")).version;
        src = ./.;
        buildPhase = "yarn build";
        installPhase = ''
          mkdir -p $out/public/assets;
          mv deps/${name}/dist/* $out/public/
        '';
        distPhase = "true";
      };

      apps.${system}.default = {
        type = "app";
        program = "${pkgs.python3}/bin/python -m http-server -d ${
            self.packages.${system}.default
          }/public";
      };
    };

}
