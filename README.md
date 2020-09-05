# Cute Seal Fanpage

> An experiment using [Nix](https://nixos.org/), [Hakyll](https://jaspervdj.be/hakyll/), [Haskell](https://www.haskell.org/), and [shell scripts](https://en.wikipedia.org/wiki/Bourne_shell) to automate a simple website deployment pipeline.

## Why Seals?

It's an in-joke.

## What's all this code?

seal-blog/
- devops/
  - build.sh
    - Uses a [nix-shell](https://nixos.wiki/wiki/Development_environment_with_nix-shell) expression to build the Hakyll executable

  - configuration.nix
    - The [configuration file for the NixOS](https://nixos.org/manual/nixos/stable/index.html#ch-configuration) production server. This takes care of installing all the necessary software, setup [Nginx](https://www.nginx.com/), and get [ACME certs](https://en.wikipedia.org/wiki/Automated_Certificate_Management_Environment) for verification.

  - default.nix
    - An broken experiment to package this repo as a Nix expression.

  - deploy.sh
    - A simple rsync command to copy this repo to the server.

  - newSealPost.sh
    - Script to be called daily by a cron job on the server. Generates the post for the day, builds and commits.


- dist/
  - Nothing checked in goes here. If you have to go in here you're probably doing something wrong.

- generate/
  - generateSealPosts.hs
    - A Haskell script that checks the website/posts folder and creates a blog post for every day from 1998 until the current date. There you will find the adjective lists if you think of more words to describe seals.

- website/
  - A basic Hakyll site, slightly modified to serve seals. Most of the site is generated from the `site.hs` file. Check the [Hakyll](https://jaspervdj.be/hakyll/) documentation for more info.

## These seals need more adjectives!

In [generate/generateSealPosts.hs](https://gitlab.com/billewanick/seal-blog/-/blob/master/generate/generateSealPosts.hs#L117-221) you'll find two lists of adjectives. Submit a pull request to add more. Or email me at admin AT cutesealfanpage.love