# https://wizzup.github.io/posts/nix-shell-haskell-invocation/
# shell.nix for nix-shell (haskell)

{ pkgs ? import <nixpkgs> {} }:

let
  pkgs = import (builtins.fetchGit {
       # Descriptive name to make the store path easier to identify                
       name = "hakyll-4.13.3.0";                                                 
       url = "https://github.com/nixos/nixpkgs-channels/";                       
       ref = "refs/heads/nixpkgs-unstable";                     
       rev = "fa54dd346fe5e73d877f2068addf6372608c820b";                                           
  }) {};                                                                           

  myPkg = pkgs.haskellPackages.hakyll;

  ghc = pkgs.haskellPackages.ghcWithHoogle (self: with self; [
        hspec
        split
        myPkg # hakyll
        random
        neat-interpolation
      ]);
in
pkgs.mkShell {
  name = "haskell-shell";
  buildInputs = (with pkgs.haskellPackages; [ 
      ghc
      hlint

      stack
      ghcjs-dom
      cabal-install
    ]) ++ (with pkgs; [
      nano
    ]);

  shellHook = ''
    eval "$(egrep ^export "$(type -p ghc)")"
    export PS1="\[\033[1;32m\][ns-hs:\w]\n$ \[\033[0m\]"
  '';
}
