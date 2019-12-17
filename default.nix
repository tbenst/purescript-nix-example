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

  nativeBuildInputs = [ purescript nodejs-12_x ];

  postBuild = ''
    ${purescript}/bin/purs compile "$src/**/*.purs" ${builtins.toString
      (builtins.map
        (x: ''"${x.outPath}/src/**/*.purs"'')
        (builtins.attrValues spagoPkgs.inputs))}
    mkdir -p $out
    cp -r output $out/output
    '';

  postFixup = ''
    mkdir -p $out/dist
    echo ${spago}/bin/spago bundle-app --no-install \
      --no-build --main Example.Main --to $out/dist/app.js
    ${spago}/bin/spago bundle-app --no-install \
      --no-build --main Example.Main --to $out/dist/app.js
    ${nodejs-12_x}/bin/node node_modules/.bin/parcel build assets/*.html --out-dir $out/dist/
  '';


  meta = with stdenv.lib; {
    description = "Example for building Purescript Halogen app with Nix.";
    homepage = "https://github.com/tbenst/purescript-nix-example";
    maintainers = with maintainers; [ tbenst ];
  };
}