to install from stow 
```
stow -R -v -t ~ zsh
```

install zsh packages
```
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/joshskidmore/zsh-fzf-history-search ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-fzf-history-search
```

goto install 
```
git clone git@github.com:iridakos/goto.git
cd goto 
sudo ./install
```

packages from apt:
- pulseaudio
- autorandr
- imagemagick
- maim

brightness install 
```
sudo apt install brightnessctl
sudo udevadm control --reload-rules
sudo udevadm trigger
sudo usermod -aG video $USER

```

xkblayout:
```
sudo apt install libx11-dev
git clone git@github.com:nonpop/xkblayout-state.git
cd xkblayout-state
make
cp xkblayout-state /home/$USER/.local/bin/
```
