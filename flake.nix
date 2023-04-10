{
  description = "A Nix flake for my long-running seal blog";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        ghc' = pkgs.haskellPackages.ghcWithHoogle (self: with self; [
          hakyll
          neat-interpolation
          parallel
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
            ];
        };
      });
}
