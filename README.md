## Building this repo with Nix
```
> git clone https://github.com/tbenst/multivac
> cd multivac
> nix-build
> nix-shell shell.nix
$ yarn http-server result/dist/
```

## Bootstrapping default.nix
```
> nix-shell shell.nix
$ yarn bootstrap-nix
```

For clarity, `yarn bootstrap-nix` is defined in `packages.json` and does the following:
```
yarn add --dev purescript spago parcel-bundler
yarn add http-server
yarn spago init
yarn spago install halogen behaviors drawing
yarn2nix > yarn.nix
mkdir -p dist
spago2nix generate
```

## Creating your own package
### Simple version
Fork this repo and update name & version in `package.json`, as well as adding
packages to the `bootstrap-nix` script as desired. Then simply execute
`yarn full-clean && yarn bootstrap-nix`.

### From scratch
Alternatively, if you'd prefer to start
from a clean git history, all you need is `shell.nix` and `default.nix` to get started:
```
> nix-shell shell.nix
$ yarn add --dev purescript spago parcel-bundler
```
Now add a "name" and "version" field to `package.json` or else later steps will fail.

```
> nix-shell shell.nix
$ yarn add http-server
$ yarn spago init
$ yarn spago install halogen
$ yarn2nix > yarn.nix
$ spago2nix generate
```


## dev mode:
run in separate terminals using `nix-shell shell.nix`
```
yarn spago build --watch
yarn parcel assets/*.html
```

## Other resources
https://discourse.purescript.org/t/recommended-tooling-for-purescript-applications-in-2019/948
