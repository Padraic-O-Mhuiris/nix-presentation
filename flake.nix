{
  description = "Nix Presentation";
  inputs = { nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11"; };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      packages.${system} = {

        site = pkgs.mkYarnPackage rec {
          name = "nix-presentation";
          version = (pkgs.lib.importJSON (src + "/package.json")).version;
          src = ./.;
          buildPhase = "yarn build";
          installPhase = ''
            mkdir -p $out/public;
            mv deps/${name}/dist/* $out/public/
          '';
          distPhase = "true";
        };

        server = pkgs.writeScriptBin "nix-presentation-server" ''
          ${pkgs.webfs}/bin/webfsd -p 3000 -F -j -r ${
            self.packages.${system}.site
          }/public -f index.html
        '';
      };

      apps.${system}.default = {
        type = "app";
        program =
          "${self.packages.${system}.server}/bin/nix-presentation-server";
      };

      devShell.${system} =
        pkgs.mkShell { buildInputs = with pkgs; [ nodejs yarn ]; };
    };
}
