{
  description = "A Nix flake for my long-running seal blog";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        ghc' = pkgs.haskellPackages.ghcWithHoogle (self: with self; [
          dhall
          hakyll
          neat-interpolation
          random
          split
        ]);
      in
      {
        devShells.default = pkgs.mkShell {
          name = "hakyll-shell";

          buildInputs = with pkgs.haskellPackages;
            [
              ghc'
              hlint
              haskell-language-server

              (pkgs.writeShellScriptBin "build-site" ''
                ${ghc'}/bin/ghc --make website/site -outputdir dist -static -O2
              '')
            ];
        };
      });
}
