# nix-overlays
Personal nixpkgs overlays, that add the following packages:
 - [boomer](https://github.com/tsoding/boomer)
 - [zimply](https://github.com/kimbauters/ZIMply)


## Usage

At user level, you can use this overlay with nix by cloning this repo in `~/.config/nixpkgs/overlays`:

```sh
mkdir -p ~/.config/nixpkgs
git clone https://github.com/debling/nix-overlays.git ~/.config/nixpkgs/overlays

```
After cloning, you can install any package from the overlay with `nix-env -iA nixos.packageFromOverlay`.

If the goal is using inside at system level, inside your configuration.nix:
```nix
{ config, pkgs, ... }:

let
  customPkgs = import <nixpkgs> {
    overlays = [
      (import (builtins.fetchTarball "https://github.com/debling/nix-overlays/archive/master.tar.gz"))
    ];
  };
in {
  environment.systemPackages = with pkgs; [ customPkgs.packageFromOverlay ];
}
```
