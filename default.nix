with import <nixpkgs> {};

let 
  spagoPkgs = import ./spago-packages.nix { inherit pkgs; };
  removeHashBang = drv: drv.overrideAttrs (oldAttrs: {
    buildCommand = builtins.replaceStrings ["#!/usr/bin/env"] [""] oldAttrs.buildCommand;
  });
in
mkYarnPackage rec {
  name = "purescript-nix-example";
  src = ./.;
  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;

  nativeBuildInputs = [ purescript ];

  postBuild = ''
    ${removeHashBang spagoPkgs.installSpagoStyle} # == spago2nix install
    ${removeHashBang spagoPkgs.buildSpagoStyle}   # == spago2nix build
    ${removeHashBang spagoPkgs.buildFromNixStore} # == spago2nix build

    '';
    # TODO: try to compile here? getting a ModuleNotFound Error
    # mkdir -p $out
    # ${purescript}/bin/purs compile "$src/**/*.purs"
    # mv output $out

  # fails with:
  # purs bundle: No input files.
  # [error] Bundle failed.
  postFixup = ''
    cd $src
    ${spago}/bin/spago bundle-app --no-install \
      --no-build --main Example.Main --to $out/dist/app.js
    parcel assets/*.html --out-dir $out/dist/
  '';


  meta = with stdenv.lib; {
    description = "Example for building Purescript Halogen app with Nix.";
    homepage = "https://github.com/tbenst/purescript-nix-example";
    maintainers = with maintainers; [ tbenst ];
  };
}