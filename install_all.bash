
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
#+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

# git 
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
#\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

# yandex-browser
#===============================================================================
deb_browser_name='/tmp/yandex_browser.deb'
python3 ~/repos/dotfiles/install_yandex_browser.py $deb_browser_name

dpkg -i $deb_broser_name 
#===============================================================================


# zsh 
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cd ~
apt -y install zsh
apt -y install fonts-powerline

curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
cp repos/dotfiles/.zshrc .

# # p10k
cd repos 
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git
cp dotfiles/.p10k.zsh "$HOME/." 

# # fonts 
cd $HOME
mkdir -p .fonts
cd .fonts

wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf

fc-cache -f -v

# 
chsr -s /bin/zsh


#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

#vim 
#...............................................................................
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
#nodejs
curl -sL install-node.vercel.app/lts | bash

#TODO: install extentions
#...............................................................................

#def->run
DOTFILES_PATH="$HOME/repos/dotfiles"
RUN_FILE="/usr/local/share/run.sh"

cp $DOTFILES_PATH/run.sh "$RUN_FILE"

if [ "$(grep -c "source $RUN_FILE" "$HOME/.zshrc")" == "0" ]; then
  # Append source to RC file
  echo -e "\\n\\n# Source goto\\n[[ -s \"$RUN_FILE\" ]] && source $RUN_FILE\\n" >> "$HOME/.zshrc"
fi


#keyboard swap right ctrl and alt
cp 70-keyboard.hwdb /etc/udev/hwdb.d/.
sudo systemd-hwdb update && sudo udevadm trigger

