# Cute Seal Fanpage

> An experiment using [Nix](https://nixos.org/),
> [Hakyll](https://jaspervdj.be/hakyll/),
> [Haskell](https://www.haskell.org/),
> and [shell scripts](https://en.wikipedia.org/wiki/Bourne_shell)
> to automate a simple website deployment pipeline.

## Why Seals?

It's an in-joke.

## What's all this code?

seal-blog/

- `flake.nix`
  - The specification for everything is repo can do.
  - Defines the hakyll site build instructions, as well as sets it as an app to be run with `nix run .#hakyll-site`.
  - Defines the blog generation command as an app to be run with `nix run .#generateSealPosts`.
  - Creates a shell with the same ghc installed, as well as other haskell tools.
    - For use with `nix develop .` or [direnv](https://direnv.net)
- `site.hs`
  - The hakyll blog is defined here.
  - Pulls in the rest of the files in this repo and creates a static site at `_site`.
- `config.dhall`
  - The config file for the blog generation, run with `nix run .#generateSealPosts`.
  - Uses a pseudo random number generator, change the seed to see different outputs in the `postsOutputPath` (default `./posts/`).
- The rest of the code is related to the static hakyll site itself.
  - I've tried putting it in it's own `src` or `website` folder but
    - it feels like needless refactoring
    - I can't get the flake operations to work :(
