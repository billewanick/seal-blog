# https://wizzup.github.io/posts/nix-shell-haskell-invocation/
# shell.nix for nix-shell (haskell)

{ pkgs ? import <nixpkgs> {} }:

let
  ghc = pkgs.haskellPackages.ghcWithHoogle (self: with self; [
          hspec
          split
          hakyll
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
