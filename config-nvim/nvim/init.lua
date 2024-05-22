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

vim.call('plug#end')


vim.cmd('set runtimepath^=~/.vim runtimepath+=~/.vim/after')
vim.cmd('let &packpath = &runtimepath')
vim.cmd('source ~/.vimrc')

require('lualine').setup({
    options = { theme = 'dracula' },
    sections = { 
        lualine_a = { 'bo:filetype' },
    },
    tabline = {
        lualine_a = {
        {
          'buffers',
          show_filename_only = true,   -- Shows shortened relative path when set to false.
          hide_filename_extension = false,   -- Hide filename extension when set to true.
          show_modified_status = true, -- Shows indicator when the buffer is modified.

          mode = 2, -- 0: Shows buffer name
                    -- 1: Shows buffer index
                    -- 2: Shows buffer name + buffer index
                    -- 3: Shows buffer number
                    -- 4: Shows buffer name + buffer number

          max_length = vim.o.columns * 2 / 3, -- Maximum width of buffers component,
                                              -- it can also be a function that returns
                                              -- the value of `max_length` dynamically.

          use_mode_colors = true,

          buffers_color = {
            active = 'lualine_a_normal',
            inactive = 'lualine_a_inactive',
          },

          symbols = {
            modified = ' ●',      -- Text to show when the buffer is modified
            alternate_file = '#', -- Text to show to identify the alternate file
            directory =  '',     -- Text to show when the buffer is a directory
          },
        }
      }

    }
})

require("ibl").setup()
