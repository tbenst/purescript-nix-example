# so we can access the `pkgs` and `stdenv` variables
with import <nixpkgs> {};

let 
  spago2nix = import (pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "spago2nix";
      rev = "262020b1bae872dac6db855fafe58a9999c91a28";
      sha256 = "0l678qjb73f1kvkk3l1pby2qg272dj166yxl7b1mcb0xhnjgig7g";
    }) {};
in
stdenv.mkDerivation {
  name = "purescript-bootstrap-shell";
  buildInputs = with pkgs; [
    nodejs-12_x
    yarn
    yarn2nix
    spago2nix
  ];
}