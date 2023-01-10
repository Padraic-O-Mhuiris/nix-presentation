with import <nixpkgs> { };

builtins.derivation {
  name = "demo";
  system = builtins.currentSystem;
  builder = "${pkgs.bash}/bin/bash";
  args = [
    "-c"
    ''
      echo "Hello World!" > $out
    ''
  ];
}
