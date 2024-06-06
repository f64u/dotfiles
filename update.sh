#!/usr/bin/env bash

set -e

git diff
nix flake update
darwin-rebuild switch --flake . 
gen=$(darwin-rebuild --list-generations | grep current)
git commit -am "$gen"

