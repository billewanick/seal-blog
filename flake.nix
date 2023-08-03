{
  description = "A Nix flake for my long-running seal blog";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";

    utils.url = "github:numtide/flake-utils";

    spg.url = "git+https://git.ewanick.com/bill/sealPostGenerator.git";
    spg.inputs.nixpkgs.follows = "nixpkgs";
    spg.inputs.utils.follows = "utils";
  };

  outputs = { self, nixpkgs, utils, ... }@inputs:
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
        apps.generateSealPosts = {
          type = "app";
          program = "${inputs.spg.packages.${system}.default}/bin/generateSealPosts";
        };

        devShells.default = pkgs.mkShell {
          name = "hakyll-shell";

          buildInputs = with pkgs.haskellPackages; [
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
