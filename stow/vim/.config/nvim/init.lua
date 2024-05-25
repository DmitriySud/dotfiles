local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('scrooloose/nerdtree', { ['on'] =  'NERDTreeToggle' })

Plug('mhartington/oceanic-next')

Plug('jiangmiao/auto-pairs')
Plug('easymotion/vim-easymotion')
Plug('neoclide/coc.nvim', {['branch'] = 'release'})

Plug('cdelledonne/vim-cmake')
--Plug('vim-airline/vim-airline')
Plug('ctrlpvim/ctrlp.vim')
Plug('mhinz/vim-startify')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.6' })

Plug('preservim/nerdcommenter')
--Plug('Yggdroot/indentLine')
Plug('tarekbecker/vim-yaml-formatter')

Plug('liuchengxu/vista.vim')

Plug('catppuccin/nvim', { ['as'] = 'catppuccin'  })

Plug 'nvim-lualine/lualine.nvim'
--" If you want to have icons in your statusline choose one of these
Plug 'nvim-tree/nvim-web-devicons'

Plug "lukas-reineke/indent-blankline.nvim"

Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate'})

vim.call('plug#end')


vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.cmd('let &packpath = &runtimepath')
vim.cmd('source ~/.vimrc')

local settings = require('settings.plugins')

require('lualine').setup(settings.lualine)
require('nvim-treesitter.configs').setup(settings.treesitter)

require("ibl").setup()
