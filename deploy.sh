# Deploy script
#
# Run with
#  $ sudo ./deploy.sh
# and enter password
# Change up user and IP as appropriate
# for each site
# Add this for dry-run:
#   --dry-run \
# time added for timing at the end. Check Real time
echo "rsycing the blog to remote"
echo "please enter remote alice password:"
time rsync          \
    --recursive     \
    --update        \
    --executability \
    --times         \
    --compress      \
    --stats         \
    --rsh=ssh       \
    ../seal-blog \
    alice@172.105.4.234:/home/alice

# Move the configuration script
# scp configuration.nix alice@172.105.4.234:/etc/nixos/configuration.nix

# Restart NixOS
# ssh -t alice@172.105.4.234 sudo nixos-rebuild switch

# Kill the website
# ssh -t alice@172.105.4.234 pkill site

# Build the site
# ssh -t alice@172.105.4.234
echo -e "\n\nCopy files over finished!"
echo -e "\n\n\nAlice needs to do some steps"
echo "Enter her password so she can get to work:"
ssh -t alice@172.105.4.234 "
  alias echo='echo -e'

  echo 'Now enter her password for sudo inside the ssh'
  sudo echo 'echo ULTIMATE POWER'
  
  echo '\nMake sure we know where we are'
  ls
  pwd
  
  echo '\ncd seal-blog'
  cd seal-blog

  echo 'copy the configuration over'
  echo 'TODO: make this only if changed'
  sudo mv configuration.nix /etc/nixos/configuration.nix

  echo '\nRebuild NixOS'
  echo 'TODO: make this only if changed'
  echo sudo nixos-rebuild switch

  echo '\npkill the site'
  echo 'TODO: make this only if necessary'
  echo pkill site

  echo '\nBuild the site'
  echo 'TODO: shouldnt need to build on deploy server'
  echo ./build.sh

  echo 'Start the site in the background using nohup'
  echo 'TODO: make this only if necessary'
  echo nohup 'site watch' >>/dev/null 2>>/dev/null &
  echo site watch &
  echo disown
  echo '\n\nDeploy finished!\n\n'
"

# on alice
# ssh -t alice@172.105.4.234
# in a week (August 21st)
# need to run `sudo certbot certonly`
# get the cert for the site, and set it in nginx

# nohup
# https://superuser.com/a/38567
# https://en.wikipedia.org/wiki/Nohup