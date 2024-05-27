syntax on
" hi Normal guibg=NONE ctermbg=NONE
"color transparent

set number
set expandtab
set tabstop=4
set smarttab
set softtabstop=4
set shiftwidth=4
set colorcolumn=121
highlight ColorColumn guibg=LightYellow

let mapleader = "\<Space>"


set hlsearch
set incsearch

set autoread
au CursorHold * checktime

"mapping
map <C-n> :NERDTreeToggle<CR>
map <Leader> <Plug>(easymotion-prefix)
inoremap <C-o> <esc>o
imap <C-l> <esc>A{<CR>
imap <C-e> <esc>A;<CR>

noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
" Ctrl-j/k deletes blank line below/above, and Alt-j/k inserts.
nnoremap <silent><C-j> m`:silent +g/\m^\s*$/d<CR>``:noh<CR>
nnoremap <silent><C-k> m`:silent -g/\m^\s*$/d<CR>``:noh<CR>

nnoremap <silent><C-h> :call coc#float#close_all()<CR>

set encoding=utf-8



nnoremap <Leader>l :ls<CR>
nnoremap <TAB> :bn<CR>
nnoremap <S-TAB> :bp<CR>
nnoremap <Leader>g :e#<CR>
nnoremap <Leader>d :bp \| bd # <CR>

nnoremap <Leader>sw Pldw

let g:arc_prefix = 'https://a.yandex-team.ru/arc/'
function GetFileLink()
  let l:file_name = expand('%:p')
  let l:nodes = split(l:file_name, '/')
  if len(l:nodes) > 2 && l:nodes[0] ==# 'home' && l:nodes[1] ==# 'dyusudakov' && l:nodes[2] ==# 'arcadia'
    let l:link = g:arc_prefix . 'trunk/' . join(l:nodes[2:], '/') 
    echo l:link
  else
    echo 'cant get arc link =_('
  endif
endfunction

nnoremap <F4> :call GetFileLink()<CR>

" vim vista
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never run if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

let g:vista#renderer#enable_icon = 1

let g:vista_default_executive = 'coc'

let g:vista_fzf_preview = ['right:50%']

nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
