local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

--- Files navigation
Plug('mhinz/vim-startify')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim', { ['tag'] = '0.1.6' })
Plug('scrooloose/nerdtree', { ['on'] =  'NERDTreeToggle' })

--- Code navigation
Plug('easymotion/vim-easymotion')

-- Code manipulation
Plug('preservim/nerdcommenter')
Plug 'windwp/nvim-autopairs'

-- Code complete and explore
Plug('neoclide/coc.nvim', {['branch'] = 'release'})
Plug('liuchengxu/vista.vim')

-- Code appearance
Plug 'nvim-tree/nvim-web-devicons'

Plug('catppuccin/nvim', { ['as'] = 'catppuccin'  })

Plug 'nvim-lualine/lualine.nvim'
Plug "lukas-reineke/indent-blankline.nvim"

Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate'})

vim.call('plug#end')


vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.cmd('let &packpath = &runtimepath')
vim.cmd('source ~/.vimrc')

require('settings.plugins')
