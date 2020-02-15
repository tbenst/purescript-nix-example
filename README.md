# Purescript-nix-example
This repo builds the [basic example](https://github.com/slamdata/purescript-halogen/tree/master/examples/basic) from [Halogen](https://github.com/slamdata/purescript-halogen), a type-safe UI library for Purescript, using [Nix](https://nixos.org/nix/), the purely functional package manager.

This repository follows best-practices for Purescript as discussed by the community in this [discourse thread](https://discourse.purescript.org/t/recommended-tooling-for-purescript-applications-in-2019/948): we use [Yarn](https://yarnpkg.com/lang/en/) for Javascript packages, [Spago](https://github.com/spacchetti/spago) for Purescript packages, and [Parcel](https://parceljs.org/) for bundling.

 Two helper tools are used: [yarn2nix](https://github.com/moretea/yarn2nix) and [spago2nix](https://github.com/justinwoo/spago2nix). Instructions have been tested on NixOS and Ubuntu.

## Building this repo with Nix
```
> git clone https://github.com/tbenst/purescript-nix-example
> cd purescript-nix-example
> nix-build
```
Thanks to the declarative nature of nix, it's easy to build this using the same exact version of dependencies that were tested. Simply add the flag `-I nixpkgs=https://github.com/NixOS/nixpkgs/archive/d3f928282c0989232e425d26f0302120a8c7218b.tar.gz` to `nix-build` and `nix-shell`. This package should build as long as the dependencies are hosted online.

## Serving http
```
> nix-shell shell.nix
$ yarn install
$ yarn http-server result/dist/
```
Now open a browser, and you should see a single button that toggles on or off.
To serve a version built in `nix-shell`, replace the second line with `http-server dist` as result is a symlink to nix-store created by `nix-build`.

## Hot reloading
Run the following commands in separate terminals using `nix-shell shell.nix`.
Make sure you `yarn install` first.
```
yarn watch
yarn dev
```

## Bootstrapping
If you're curious, here's how to generate `yarn.lock` and `yarn.nix`:
```
> nix-shell shell.nix
$ yarn full-clean
$ yarn bootstrap-nix
```

## Creating your own package

### Simple version
Fork this repo and update name & version in `package.json`, as well as adding
packages to the `bootstrap-nix` script as desired. Then simply follow
bootstrapping instructions above.

### From scratch
Alternatively, if you'd prefer to start
from a clean git history, all you need is `shell.nix` and `default.nix` to get started:
```
> nix-shell shell.nix
$ yarn add --dev parcel-bundler
```
Now add a "name" and "version" field to `package.json` or else later steps will fail.

```
> nix-shell shell.nix
$ yarn add http-server
$ spago init
$ spago install halogen
$ yarn2nix > yarn.nix
$ spago2nix generate
```

These are the same commands used by `yarn bootstrap-nix`, which is defined in `packages.json`.

## Thanks for reading!
Let me know if you have any questions / issues, or more importantly, ideas to
make this better! Pull requests welcome.
