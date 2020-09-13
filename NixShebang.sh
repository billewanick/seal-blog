#! /usr/bin/env nix-shell
#! nix-shell -p "haskellPackages.ghcWithPackages (ps: with ps; [turtle])"
#! nix-shell -i runghc

{-# LANGUAGE OverloadedStrings #-}

import Turtle

main :: IO ()
main = do
  echo "Hello, World!"