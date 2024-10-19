
# base utils
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
apt -y install git 
apt -y install vim 
apt -y install python3.10
apt -y install pip
apt -y install telegram-desktop
apt -y install curl 
apt -y install cmake
apt -y install clang-format
apt -y install clang-tidy
apt -y install clangd
apt -y install stow
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

stow -R -v -t ~ zsh
# git 
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

# yandex-browser
#===============================================================================
#deb_browser_name='/tmp/yandex_browser.deb'
#python3 ~/repos/dotfiles/install_yandex_browser.py $deb_browser_name

#dpkg -i $deb_broser_name 
#===============================================================================


# zsh 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd ~
apt -y install zsh
apt -y install fonts-powerline

wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
sh install.sh

# # p10k
cd repos 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git

# # fonts 
fc-cache -f -v
# 
chsh -s /bin/zsh


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#vim 
#...............................................................................
apt install -y neovim
nvm install neovim
pip install neovim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#nodejs
curl -sL install-node.vercel.app/lts | bash

#TODO: install extentions
#...............................................................................

#def->run
#DOTFILES_PATH="$HOME/repos/dotfiles"
#RUN_FILE="/usr/local/share/"
#
#cp $DOTFILES_PATH/run.sh "$RUN_FILE"
#cp $DOTFILES_PATH/rfv.sh "$RUN_FILE"
#
#if [ "$(grep -c "source $RUN_FILE" "$HOME/.zshrc")" == "0" ]; then
#  # Append source to RC file
#  echo -e "\\n\\n# Source goto\\n[[ -s \"$RUN_FILE\" ]] && source $RUN_FILE\\n" >> "$HOME/.zshrc"
#fi


#keyboard swap right ctrl and alt
#cp 70-keyboard.hwdb /etc/udev/hwdb.d/.
#sudo systemd-hwdb update && sudo udevadm trigger


#tmux + byobu
apt install -y byobu
mkdir -p $HOME/.byobu
touch $HOME/.byobu/.reuse-session

