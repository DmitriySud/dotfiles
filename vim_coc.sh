apt install vim
apt install clangd
cp .vimrc ${HOME}/

apt install nodejs
apt install npm

node -v
npm -v

curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
	    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

vim -c "autocmd! CursorHold * PlugInstall qall!""
sleep 5

cp coc-settings.json ~/.vim/

vim -c "autocmd! CursorHold * CocInstall coc-clangd coc-json coc-python coc-cmake coc-diagnostic coc-snippets | qall!"
