" allow backspaceing over everything in insert mode
set bs=indent,eol,start 

" search options
set hlsearch
" increase sreach, browser the result when type the keyword
set incsearch 

set viminfo='100,<50,s10,%

set number
"set ruler

set background=light
colorscheme default

function! Get_Mode()
    let mode_opts =
        \ {
            \ 'n': 'Normal',
            \ 'no': 'Operator-pending',
            \ 'v': 'visual',
            \ 'V': 'VISUAL',
            \ 'CTRL-V': 'VB',
            \ 'i': 'Insert',
            \ 'R': 'Replace',
            \ 's': 'Select',
            \ 'S': 'Select',
            \ 'CTRL-S': 'Select'
        \ }
    let mode = mode()
    if has_key(mode_opts, mode)
        return mode_opts[mode]
    else
        echo "get mode error!!!"
    endif
endfunc

" set status line
" colorscheme will run hi clear, which clear you own color settings so need
" autocmd to keep you color settings
autocmd ColorScheme *
    \ hi User1 ctermbg=238 ctermfg=Red guibg=DarkBlue guifg=Red |
    \ hi User2 ctermbg=238 ctermfg=Yellow guibg=DarkBlue guifg=Red |
    \ hi User3 ctermbg=White ctermfg=Green guibg=White guifg=DarkBlue |
    \ hi User4 ctermbg=White ctermfg=Blue guibg=DarkBlue guifg=Red |
    \ hi User5 term=bold cterm=bold ctermfg=17 ctermbg=190 gui=bold guifg=#00005f guibg=#dfff00 |
    \ hi User6 ctermfg=36 ctermbg=238

set statusline =\ %5*%{Get_Mode()}%*
set statusline+=\ %6*[%-6.100F]%*
" set statusline+=\ [%4*%-6.100F%*]
set statusline+=\ %2*%r%*
set statusline+=%w
set statusline+=\ %1*%m%*
set statusline+=%=
set statusline+=%l,%c
set statusline+=\ %p%%
" set statusline+=\ %3*%y%*
set statusline+=\ %5*[%{&fileformat}]%*
set laststatus=2

au ColorScheme * hi! Search cterm=inverse
au ColorScheme * hi! Statusline ctermfg=238 ctermbg=Gray
au ColorScheme * hi! StatuslineNC ctermfg=238 ctermbg=Gray
" set the tab-completion motion
set wildmode=longest:list
" set wildmode=list:full
" completation appearance
set completeopt=menu,noinsert
" for input-line test

" Maintain undo history between sessions
set undofile 
set undodir=/home/songxiongwei/.vim/undodir

" let swp_path = "~/.vim/swp" . "\," . &directory
" let &directory = swp_path
"set directory=~/.vim/swp

filetype plugin on

"autocmd FileType c set 
syntax on

if filewritable(expand("%"))
    " autocmd QuitPre * :write
endif

"set the text max length per line
set textwidth=80
set formatoptions-=l
set formatoptions+=t

set showmatch
set showcmd

" enable help all doc, include from the thirdpart
silent! helptags ALL

"ctags setting
let Tlist_Ctags_Cmd ='/usr/bin/ctags'
let Tlist_Exit_OnlyWindow = 1
let Tlist_File_Fold_Auto_Close= 1
let Tlist_Inc_Winwidth = 0

"cscope setting
" set cscopequickfix=s-,c-,d-,i-,t-,e-
if has("cscope")
    set csprg=/usr/bin/cscope
    set csto=0
    set cst
    set nocsverb

    " add any database in current directory
    if filereadable("cscope.out")
        cs add cscope.out

    " else add database pointed to by environment
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set csverb
endif
let cs_auto_jump = 0
nmap <C-_>s :cs find s <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-_>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-_>c :cs find c <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-_>t :cs find t <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-_>e :cs find e <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-_>d :cs find d <C-R>=expand("<cword>")<CR><CR>:copen<CR>
nmap <C-_>f :cs find f <C-R>=expand("<cfile>")<CR><CR>:copen<CR>
nmap <C-_>i :cs find i <C-R>=expand("<cfile>")<CR><CR>:copen<CR>

"map <F1> :copen<CR>
map <F2> :ccl<CR>
map <F3> :Tlist<CR>

"copy the highlight context to clipboard
map <C-c> "+y<CR>
" remove current highlight
nmap <Leader>l :nohls<CR>

"jump to tag that is from your choice
function! GotoJump()
    jumps
    let j = input("Please select your jump: ")
    if j != ''
        let pattern = '\v\c^\+'
        if j =~ pattern
        let j = substitute(j, pattern, '', 'g')
            execute "normal " . j . "\<c-i>"
        else
            execute "normal " . j . "\<c-o>"
        endif
    endif
endfunction

nmap <Leader>jj :call GotoJump()<CR>

"grep
":nnoremap <leader>g :grep -R '<cword>' .<cr>
":nnoremap <leader>g :silent execute "grep! -R " . shellescape(expand("<cword>")) . " ."<cr>:copen<cr>

function! SaveFile()
    if filewritable(bufname("%")) && getbufvar("%","&modified")
        write
    endif
endfunction

function! SaveAllFiles()
    brewind!
    let s:count = 0
    while bufnr("%") <= bufnr("$")
        call SaveFile()
        bnext
        if s:count > bufnr("$")
            break
        endif
        let s:count += 1
    endwhile
endfunction

augroup savemyfiles
    au!
    au QuitPre *.c,*.h,*.txt,*.sh,*.py,*.vim call SaveAllFiles()
augroup END
