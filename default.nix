with import <nixpkgs> {};

let 
  spagoPkgs = import ./spago-packages.nix { inherit pkgs; };
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
    cp -r $src/assets ./
    '';

  postFixup = ''
    ${spago}/bin/spago bundle-app --no-install \
      --no-build --main Example.Main --to dist/app.js
    mkdir -p $out/dist
    cp -r dist $out/
    ln -s $out/libexec/${name}/node_modules .
    ${nodejs-12_x}/bin/node node_modules/.bin/parcel \
      build assets/*.html --out-dir $out/dist/
  '';


  meta = with stdenv.lib; {
    description = "Example for building Purescript Halogen app with Nix.";
    homepage = "https://github.com/tbenst/purescript-nix-example";
    maintainers = with maintainers; [ tbenst ];
  };
}