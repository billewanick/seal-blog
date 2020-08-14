{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation rec {
  pname = "test-blog";
  version = "latest";
  src = "./${pname}";
  phases = "installPhase";
  buildInputs =
    [ "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ hakyll ])" ];
  installPhase = ''
    echo Install Phase
  '';
  buildPhase = ''
    ghc --make site
  '';
}

pkgs.run-command "my-example" {} ''
  echo My example command is running

  pwd
  cd test-blog

  ./site watch
''