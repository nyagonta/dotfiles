""---------------------------------------------------------------------------
""
""   File: _vimrc
""   Maintainer: nyagonta
""   Last Change: 21-Feb-2015.
""
""---------------------------------------------------------------------------

" Prepare .vim dir {{{
let s:vimdir = $HOME . "/.vim"
if has("vim_starting")
  if ! isdirectory(s:vimdir)
    call system("mkdir " . s:vimdir)
  endif
endif
" }}}

" dein {{{
" Set dein paths
let s:dein_dir = s:vimdir . '/dein'
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

" Check dein has been installed or not.
if !isdirectory(s:dein_repo_dir)
    echo "dein is not installed, install now "
    call system("git clone https://github.com/Shougo/dein.vim " . s:dein_repo_dir)
endif
let &runtimepath = &runtimepath . "," . s:dein_repo_dir

" Begin plugin part {{{

" Check cache
if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

	" dein
    call dein#add('Shougo/dein.vim')

    " Basic tools {{{
    " Asynchronous execution library: need for vimshell, Gmail, unite, etc...
    call dein#add('Shougo/vimproc', {'build': 'make'})
    " }}}

	" plugins
    call dein#add('kien/ctrlp.vim')
    call dein#add('mattn/calendar-vim')
    call dein#add('vim-jp/vimdoc-ja')
    call dein#add('tmhedberg/matchit')
    call dein#add('kana/vim-smartinput')
    call dein#add('tpope/vim-fugitive')
    call dein#add('airblade/vim-gitgutter')
    call dein#add('osyo-manga/vim-anzu')
    call dein#add('wesleyche/SrcExpl')
	call dein#add('roblillack/vim-bufferlist')
	call dein#add('vim-scripts/taglist.vim')
	call dein#add('scrooloose/nerdtree')
	call dein#add('jistr/vim-nerdtree-tabs')
	call dein#add('bronson/vim-trailing-whitespace')
	call dein#add('Yggdroot/indentLine')
	call dein#add('tpope/vim-endwise')
	call dein#add('tpope/vim-surround')
	call dein#add('AndrewRadev/linediff.vim')
	call dein#add('AndrewRadev/switch.vim')
	call dein#add('t9md/vim-quickhl')

    " color schemes {{{
    call dein#add('rodnaph/vim-color-schemes')
    call dein#add('29decibel/codeschool-vim-theme')
    call dein#add('altercation/vim-colors-solarized')
    call dein#add('croaker/mustang-vim')
    call dein#add('nanotech/jellybeans.vim')
    call dein#add('tomasr/molokai')
    call dein#add('vim-scripts/github-theme')
    call dein#add('sjl/badwolf')
    call dein#add('joshdick/onedark.vim')
    "}}}

    call dein#end()

    call dein#save_state()
endif
" }}}

" Installation check.
if dein#check_install()
    call dein#install()
endif
" }}} dein


" Basic settings {{{
" --- General Settings ---
filetype off          " necessary to make ftdetect work on Linux
syntax on             " syntax highlight
filetype on           " Enable filetype detection
filetype indent on    " Enable filetype-specific indenting
filetype plugin on    " Enable filetype-specific plugins Enable plugin, indent again
filetype plugin indent on

" --- Set the color scheme ---
colorscheme molokai
"colorscheme solarized
set background=dark

" --- Encoding ---
set encoding=utf-8
set fileencodings=utf-8,iso-2022-jp-3,euc-jisx0213,cp932,euc-jp,sjis,jis,latin,iso-2022-jp
" need for two-byte characters in this script, need to be after set encodeing
scriptencoding utf-8
"scriptencoding cp932
" }}} Basic settings

" Options: {{{
" --- general ---
set helplang=ja,en
set shortmess+=I	" hide the launch screen
set mouse=a			" Enable mouse support.

" --- performance / buffer ---
set hidden                  " can put buffer to the background without writing
                            "   to disk, will remember history/marks.
set lazyredraw              " don't update the display while executing macros
set ttyfast                 " Send more characters at a given time.

" --- history / file handling ---
set history=999             " Increase history (default = 20)
set undolevels=999          " Moar undo (default=100)
set autoread                " reload files if changed externally
set browsedir=buffer            " ファイル保存ダイアログの初期ディレクトリをバッファファイル位置に設定

" --- backup and swap files ---
" I save all the time, those are annoying and unnecessary...
set nobackup
set nowritebackup
set noswapfile

" --- UI ---
set cursorline				" Highlight line under cursor. It helps with navigation.
set number                  " Enable line numbers.
set report=0                " Show all changes.
set showmode    " Show mode in statusbar, not separately.
set showcmd     " show (partial) command in the last line of the screen
                "    this also shows visual selection info
set showmatch   " Cursor shows matching ) and }
set matchtime=1
set matchpairs+=<:>         " Highlight <>.
set scrolloff=5             " Start scrolling n lines before horizontal
                            "   border of window.
set sidescrolloff=7         " Start scrolling n chars before end of screen.
set sidescroll=1            " The minimal number of columns to scroll
                            "   horizontally.
set ruler     	"Always show current position
set nowrap      " 長い行を折り返さないで表示
set cmdheight=1 " Height of the command bar
set title       " タイトルを表示
set noea        " ウィンドー開閉時のサイズ変更OFF
set completeopt=menuone " チラツキ防止
set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
"set listchars=tab:^\ ,trail:-,extends:<,precedes:<,nbsp:%,eol:$
set list " Enable by default"

" --- status line ---
set laststatus=2 " always show
set statusline=%<
set statusline+=%{hostname()}:
if winwidth(0) >= 130
  set statusline+=%F                                   " Full path
else
  set statusline+=%t                                   " Only file name
endif
set statusline+=\                                      " spcae x 1
set statusline+=[%n]                                   " Buffer number
set statusline+=%m%r%h%w                               " Modified? Readonly? Help? Preview?
set statusline+=%{'['.(&fenc!=''?&fenc:&enc).':'}      " Encoding
set statusline+=%{(&bomb?'bom:':'')}                   " Encoding2
set statusline+=%{&ff.']'}\                            " FileFormat (dos/unix..)
set statusline+=[0x%02B]\                              " Character under curor - Byte number in file
set statusline+=%y                                     " FileType
set statusline+=%=                                     " Switch to the right side
set statusline+=%{fugitive#statusline()}               " Git branck name
set statusline+=\ \                                    " space x 2
set statusline+=%1l/%L,%c                              " Rownumber/total,Colnr
set statusline+=\ \                                    " space x 2
set statusline+=%P                                     " Top/bot

" --- search / regexp ---
set gdefault        " RegExp global by default
set magic			" for regular expressions turn magic on
set hlsearch		" enable search highlighting.
set incsearch		" show search matches as you type
set ignorecase		" ignore case when searching
set smartcase		" ignore case if search pattern is all lowercase,case-sensitive otherwise
set wrapscan        " searches wrap around the end of the file
set nostartofline   " make j/k respect the columns
set whichwrap=b,s,<,>,[,]   " wrap over new lines

" --- Editing ---
set backspace=indent,eol,start	" Allow backspace in insert mode.
set cpoptions-=m                " Highlight when CursorMoved.
set nolinebreak                 " Don't break words
set formatoptions+=mM           " automatic formating (this is useful for japanese text)
set undolevels=2000             " more undo
set textwidth=0                        " 自動改行をさせない
set clipboard=unnamed           " yank to the system register (*) by default
set nrformats=alpha,octal,hex   " <C-a> <C-x> で英字も増減させる
set virtualedit=block           " Allow virtual editing in block mode
set pumheight=10                " Don't show more than 10 items in the popup menu
" http://www.geocities.co.jp/SiliconValley-SantaClara/1183/computer/gvim.html
set iminsert=0 " インサートモードで日本語入力を ON にしない
set imsearch=0 " 検索モードで日本語入力を ON にしない
"}}}

" --- indents / tabs ---
" expand tabs to 4 spaces
set shiftwidth=4    " cindentやautoindent時に挿入されるタブの幅
set tabstop=4       " タブの画面上での幅
set softtabstop=0   " タブ入力時の空白変換を無効にする
set noexpandtab     " タブの代わりに空白を挿入しない
set autoindent		" autoindent when starting new line, or using `o` or `O`.
set cindent         " コードを自動的にインデントする (C言語のコーディングに便利)
set smartindent     " 新しい行を作ったときに高度な自動インデントを行う
set smarttab		" insert tabs on the start of a line according to context
set copyindent		" copy the previous indentation on autoindenting
set preserveindent  " カレント行のインデント変更時に可能な限りインデント構造を維持する
set showtabline=2	" Show Tabline

" --- command completion ---
set wildmenu                    " wild char completion menu
set wildchar=<TAB>				" start wild expansion in the command line using <TAB>
set wildmode=list:full
set wildignore+=*.pyc,*.sqlite,*.sqlite3,cscope.out
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

" --- diff ---
set diffopt=filler          " Add vertical spaces to keep right
                            "   and left aligned.
set diffopt+=iwhite         " Ignore whitespace changes.

" --- folding ---
set foldenable                                          " Enable folding.
set foldmethod=marker
set foldlevel=1
set foldcolumn=0
set foldopen=block,hor,mark,percent,quickfix,search,tag " what movements open folds

" --- misc ---
" Turn off annoying error bells:
set noerrorbells	" no error bell
set novisualbell	" no visual bell
set t_vb=
set timeoutlen=500	" timeout[ms] key sequence
" }}}

" ctags {{{
"set tags=./tags,tags;
if has("path_extra")
  set tags+=tags;
endif
"}}} tag

" cscope {{{
if has("cscope")
  set cscopetagorder=0      " order : ctags, cscope
  set cscopetag             " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
  set nocscopeverbose
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
    " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif
  set cscopeverbose         " show msg when any other cscope db added
endif
" }}} cscope

" edit .vimrc .gvimrc
" @see <http://vim-users.jp/2009/09/hack74/>
nnoremap <silent> <Space>ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <Space>eg  :<C-u>edit $MYGVIMRC<CR>

" cscope
" @see <http://cscope.sourceforge.net/cscope_maps.vim>
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

" Autocommands: "{{{

" Startup time.
" @see <http://vim-jp.org/reading-vimrc/archive/010.html>
if has('vim_starting') && has('reltime')
	let g:startuptime = reltime()
	augroup vimrc-startuptime
		autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
					\ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
	augroup END
endif

" auto reload vimrc when editing it
augroup vimrc-reload-vimrc
	autocmd!
	autocmd bufwritepost $MYVIMRC nested source $MYVIMRC
augroup END

" スワップがあるときは常にRead-Onlyで開く設定
" @see http://itchyny.hatenablog.com/entry/2014/12/25/090000
augroup vimrc-swap-readonly
	autocmd!
	autocmd SwapExists * let v:swapchoice = 'o'
augroup END

augroup vimrc-grep
	autocmd!
	autocmd QuickFixCmdPost *grep* cwindow
augroup END
"}}}

" map (for other than each plugin){{{
"remapping, tips

""" Normal + Visual modes

""" Normal mode 
nnoremap Y y$

nnoremap + <C-a>
nnoremap - <C-x>

" BufferListの表示 (bufferlist.vim)
nnoremap <silent> <F7> :call BufferList()<CR>

" クリップボードへ１語コピーし、置換
map <F8> :%s/<C-R><C-W>/

nnoremap <silent> <F11> :TlistToggle<CR>
" The switch of the Source Explorer
nnoremap <silent> <S-F11> :SrcExplToggle<CR>

" 古い quickfix を参照する
" @see <http://vim-users.jp/2011/10/hack237/>
map <F10> :colder<CR>
map <S-F10> :cnewer<CR>

" ウインド幅を１小さくする
map <F12> <C-W><
" ウインド幅を１大きくする
map <S-F12> <C-W>>

nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)

" clear status
nmap <Esc><Esc> <Plug>(anzu-clear-search-status)

" Semicolon is just colon
nnoremap ; :

""" insert mode

" jj to escape
inoremap jj <ESC>

" quickhl.vim
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)

""" visual mode

" }}} map


" Plugin Settings: "{{{
"
" Ctrl-P {{{
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
    \ 'file': '\v\.(exe|so|dll|keep|bak)$',
    \ }
"}}}

" taglist: {{{
let Tlist_Show_One_File = 1        " Show tags for the current buffer only
let Tlist_Use_Right_Window = 1     " Place the taglist window on the right side
let Tlist_Exit_OnlyWindow = 1      " Close Vim if the taglist is the only window
"}}}

" srcexpl: {{{
" // Use 'Exuberant Ctags' with '--sort=foldcase -R .' or '-L cscope.files' to 
" // create/update the tags file 
let g:SrcExpl_updateTagsCmd = "ctags --sort=foldcase -R ." 
"}}}

" NERDTree "{{{
let NERDTreeShowHidden = 1
let NERDTreeIgnore=['\.swp$', '\.keep$', '\.files$', '\.out$', '\.tags$', '\.taghl$', '\~$']
nnoremap <silent><C-e> :NERDTreeFocusToggle<CR>
" 他のバッファをすべて閉じた時にNERDTreeが開いていたらNERDTreeも一緒に閉じる。
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
" }}}"

" bufferlist: {{{
"map <silent> <F7> :call BufferList()<CR>   " ↑のMap設定に移動しました
let g:BufferListWidth = 10
let g:BufferListMaxWidth = 30
hi BufferSelected guifg=green
hi BufferNormal term=NONE ctermfg=black ctermbg=darkcyan cterm=NONE
"}}}

" indentLine "{{{

" }}}}"
"
"}}}

" vim: set ts=4 sts=4 sw=4 tw=0
