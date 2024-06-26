let mapleader =";"

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'phaazon/hop.nvim'
Plug 'tpope/vim-surround'
Plug 'junegunn/goyo.vim'
Plug 'jreybert/vimagit'
Plug 'lukesmithxyz/vimling'
Plug 'vimwiki/vimwiki'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'tpope/vim-commentary'
Plug 'kovetskiy/sxhkd-vim'
Plug 'ap/vim-css-color'
Plug 'mcchrish/nnn.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
" colorschemes
Plug 'morhetz/gruvbox'
Plug 'sainnhe/everforest'
Plug 'rhysd/vim-color-spring-night'
Plug 'tek256/simple-dark' " good grayscale theme
"Plug 'sainnhe/vim-color-forest-night'
"Plug 'chriskempson/base16-vim'
"Plug 'sonph/onehalf', {'rtp': 'vim/'}
"Plug 'drewtempelmeyer/palenight.vim'
"Plug 'rakr/vim-one'
"Plug 'mhartington/oceanic-next'
"Plug 'joshdick/onedark.vim'
"Plug 'altercation/vim-colors-solarized'
"Plug 'lotabout/skim', { 'dir': '~/.skim', 'do': './install' }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
call plug#end()

set title
set go=a
set mouse=a
"set nohlsearch
set clipboard+=unnamedplus
"set smartcase 			" no ignorecase if Uppercase char present
set ignorecase
"set nobackup
"set nowb
"set noswapfile
set noruler
set laststatus=0
set noshowmode
set noshowcmd

" Markdown-preview
nnoremap <leader>md :MarkdownPreview<CR>

"colorscheme simple-dark-transparent
"colorscheme everforest
colorscheme spring-night
"let g:airline_theme='monochrome'
let g:airline_theme = 'spring_night'

set bg=dark


" Some basics:
	nnoremap c "_c
	filetype plugin on
	syntax on			" turn syntax highlighting on by default
	set encoding=utf-8
	set fencs=utf8,cp1251
	"set number relativenumber	" show line numbers + relative
	set number
" Enable autocompletion:
	set wildmode=longest,list,full
" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
" Perform dot commands over visual blocks:
	vnoremap . :normal .<CR>

" Goyo plugin makes text more readable when writing prose:
	map <silent> <leader>g :Goyo \| set bg=dark \| set linebreak<CR>

" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" vimling:
	nm <leader><leader>d :call ToggleDeadKeys()<CR>
	imap <leader><leader>d <esc>:call ToggleDeadKeys()<CR>a
	nm <leader><leader>i :call ToggleIPA()<CR>
	imap <leader><leader>i <esc>:call ToggleIPA()<CR>a
	nm <leader><leader>q :call ToggleProse()<CR>

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace ex mode with gq
	map Q gq

" Check file in shellcheck:
	map <leader>s :!clear && shellcheck -x %<CR>

" Open my bibliography file in split
	map <leader>b :vsp<space>$BIB<CR>
	map <leader>r :vsp<space>$REFER<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
	map <leader>c :w! \| !compiler <c-r>%<CR>

" Open corresponding .pdf/.html or preview
	map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex<CR>
	let g:vimwiki_list = [{'path': '~/.local/share/nvim/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save.
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritePre * %s/\n\+\%$//e
	autocmd BufWritePre *.[ch] %s/\%$/\r/e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost bm-files,bm-dirs !shortcuts
	autocmd BufRead,BufNewFile Xresources,Xdefaults,xresources,xdefaults set filetype=xdefaults
	autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %
" Recompile dwmblocks on config edit.
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid -f dwmblocks }

" Have dwmblocks automatically recompile and run when you edit this file in
" vim with the following line in your vimrc/init.vim:
	autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Function for toggling the bottom statusbar:
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
    endif
endfunction
nnoremap <leader>h :call ToggleHiddenAll()<CR>

map <C-x> :FZF<CR>
map <leader>x :FZF<CR>
map <leader>z :RG<CR>

function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

let g:nnn#layout = { 'window': { 'width': 0.9, 'height': 0.6, 'highlight': 'Debug' } }
" Or override
" Start nnn in the current file's directory
nnoremap <C-f> :NnnPicker %:p:h<CR>

" Insert date by F5
nnoremap <F5> "=strftime("%Y%m%d")<CR>Po
inoremap <F5> <C-R>=strftime("%Y%m%d")<CR><CR>

"TODO set cursor at middle of page
nnoremap <C-j> <PageDown>
nnoremap <C-k> <PageUp>

function! SetUsLayout()
	silent !xkblayout-state set 0 > /dev/null
endfunction

" autocmd InsertLeave * call SetUsLayout()
autocmd CmdlineEnter * call SetUsLayout()

"Ctrl+Backspace -> C-W
inoremap <C-H> <C-W>

set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯЖ;ABCDEFGHIJKLMNOPQRSTUVWXYZ:,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz

" Automatic reloading of .vimrc
""autocmd! bufwritepost .vimrc source %

" save on <c-s>
"nmap <c-s> :w<cr>
"imap <c-s> <esc>:w<cr>a
"vnoremap <c-s> <Esc>:w<CR>

" надо как-то сделать смену языка на английский при InsertLeave
"function SetUsLayout()
"  !setxkbmap us,ru
"endfunction
"autocmd InsertLeave * call SetUsLayout()
"этот метод не работает

""""""""""""""" russian layout
"set keymap=russian-jcukenwin
"set iminsert=0
"set imsearch=0
"highlight lCursor guifg=NONE guibg=Cyan

" Tab navigation like Firefox.
"nnoremap <C-S-tab> :tabprevious<CR>
"nnoremap <C-tab>   :tabnext<CR>
"nnoremap <C-t>     :tabnew<CR>
"inoremap <C-S-tab> <Esc>:tabprevious<CR>i
"inoremap <C-tab>   <Esc>:tabnext<CR>i
"inoremap <C-t>     <Esc>:tabnew<CR>
" Или так
"map  <C-l> :tabn<CR>
"map  <C-h> :tabp<CR>
"map  <C-n> :tabnew<CR>
""""""""""""
" Faster window navigation with alt
" (even in the terminal)
"nnoremap h <C-w>h
"nnoremap j <C-w>j
"nnoremap k <C-w>k
"nnoremap l <C-w>l
"nnoremap <M-h> <C-w>h
"nnoremap <M-j> <C-w>j
"nnoremap <M-k> <C-w>k
"nnoremap <M-l> <C-w>l

" To save, ctrl-s.
"nmap <c-s> :w<CR>
"imap <c-s> <Esc>:w<CR>a

command Q q!

autocmd InsertEnter * :set norelativenumber
autocmd InsertLeave * :set relativenumber

lua require('config')

"map s <cmd>HopChar1<CR>
""map s v<cmd>HopChar1<CR>
map <Leader>w <cmd>HopWordAC<CR>
map <Leader>b <cmd>HopWordBC<CR>
map <Leader>j <cmd>HopLineStartAC<CR>
map <Leader>k <cmd>HopLineStartBC<CR>
map <Leader>J <cmd>HopLineAC<CR>
map <Leader>K <cmd>HopLineBC<CR>
map <Leader>f <cmd>HopChar1AC<CR>
map <Leader>F <cmd>HopChar1BC<CR>
map <Leader>s <cmd>HopChar2AC<CR>
map <Leader>S <cmd>HopChar2BC<CR>
map <Leader>/ <cmd>HopPattern<CR>

map <silent> <leader>q :bd<CR>
map <silent> bk :bd<CR>
map <silent> bn :bnext<CR>
