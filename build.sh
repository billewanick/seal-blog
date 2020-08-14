nix-shell --pure -p \
  "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ hakyll ])" \
  --command 'ghc --make site'