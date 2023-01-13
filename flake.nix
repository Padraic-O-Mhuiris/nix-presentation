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
      };
    };
}
