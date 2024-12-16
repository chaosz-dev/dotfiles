syntax on

" set settings
set number
set tabstop=2
set expandtab
set shiftwidth=2
set showmode
set showmatch
set hlsearch
set history=1000
set incsearch
set nowrap
set backspace=indent,eol,start
set tags+=tags,./tags;/$HOME
set cursorline
set updatetime=100
set t_Co=256

" usual highlights
highlight Todo ctermfg=red
highlight LineNr ctermfg=grey
highlight TabLine ctermbg=none ctermfg=blue
highlight TabLineFill ctermbg=none ctermfg=none cterm=none
highlight Pmenu ctermfg=brown ctermbg=none guibg=black
highlight PmenuSbar ctermbg=black
highlight PmenuThumb ctermbg=white
highlight CursorLine cterm=bold
highlight CursorLineNR cterm=bold ctermfg=white
highlight VertSplit cterm=none

" vimdiff highlights
highlight DiffAdd ctermfg=165 ctermbg=none
highlight DiffChange ctermfg=227 ctermbg=none
highlight DiffDelete ctermfg=124 ctermbg=none
highlight DiffText ctermfg=25 ctermbg=none
highlight FoldColumn ctermbg=none

" highlight for cpp stuff
highlight cCustomClass ctermfg=red

" highlight for gitgutter
highlight GitGutterAdd ctermfg=green
highlight GitGutterDelete ctermfg=red
highlight GitGutterChange ctermfg=yellow

" let
let NERDTreeShowHidden=1

" vim-cpp-enchanced-highlight settings
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1

let g:ycm_global_ymc_extra_conf = '~/.vim/plugged/youcompleteme/.ycm_extra_conf.py'
let g:ycm_clangd_binary_path = '/usr/bin/clangd'
let g:ycm_enable_inlay_hints = 1
let g:ycm_clear_inlay_hints_in_insert_mode = 0
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_echo_current_diagnostic = 1
let g:ycm_enable_diagnostic_signs = 1

let g:rainbow_active = 1
let g:rainbow_conf = { 
      \ 'ctermfgs' : ['blue', 'green', 'yellow', 'red', 'brown']
      \}
" keybinds
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>

"Paste in visual mode without copying
xnoremap p pgvy

nnoremap f :tab split \| YcmCompleter GoToReferences<CR>

nnoremap <C-Up> :call ScrollPopup(-3)<CR>
nnoremap <C-Down> :call ScrollPopup(3)<CR>

" plugins
call plug#begin()
Plug 'preservim/nerdtree'
Plug 'valloric/youcompleteme'
Plug 'Yggdroot/indentLine'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'tribela/vim-transparent'
Plug 'vim-airline/vim-airline'
Plug 'luochen1990/rainbow'
Plug 'ap/vim-css-color'
Plug 'airblade/vim-gitgutter'
Plug 'vim-autoformat/vim-autoformat'
Plug 'guns/xterm-color-table.vim'
call plug#end()

" To work nice with tmux
if &term =~ '^screen'
  " tmux will send xterm-style keys when xterm-keys is on
  execute "set <xUp>=\e[1;*A"
  execute "set <xDown>=\e[1;*B"
  execute "set <xRight>=\e[1;*C"
  execute "set <xLeft>=\e[1;*D"
endif

" Auto generate tags file on file write of *.c and *.h files
autocmd BufWritePost *.c,*.cpp,*.h silent! !ctags . &
autocmd VimEnter * if !argc() | NERDTree | endif

function FormatBuffer()
  if &modified && !empty(findfile('.clang-format', expand('%:p:h') . ';'))
    let cursor_pos = getpos('.')
    :%!clang-format --style=file
    call setpos('.', cursor_pos)
  endif
endfunction
 
autocmd BufWritePre *.h,*.hpp,*.c,*.cpp,*.vert,*.frag :call FormatBuffer()

autocmd BufWritePre *.py,*.js :Autoformat

" get what highlighting applies to element under cursor
" use: :call SynStack() in editor
function! SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! ScrollPopup(nlines)
    let winids = popup_list()
    if len(winids) == 0
        return
    endif

    " Ignore hidden popups
    let prop = popup_getpos(winids[0])
    if prop.visible != 1
        return
    endif

    let firstline = prop.firstline + a:nlines
    let buf_lastline = str2nr(trim(win_execute(winids[0], "echo line('$')")))
    if firstline < 1
        let firstline = 1
    elseif prop.lastline + a:nlines > buf_lastline
        let firstline = buf_lastline + prop.firstline - prop.lastline
    endif

    call popup_setoptions(winids[0], {'firstline': firstline})
endfunction

