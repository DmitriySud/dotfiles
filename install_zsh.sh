#!/bin/bash

sudo apt update
sudo apt install zsh

cd ~
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

sed -i "s!ZSH_THEME=\"\w+\"!ZSH_THEME=\"powerlevel10k/powerlevel10k\"!"
