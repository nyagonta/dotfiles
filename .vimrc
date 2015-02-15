"---------------------------------------------------------------------------
"                                _
"                               (_)
"  _ __ ___    _   _    __   __  _   _ __ ___    _ __    ___
" | '_ ` _ \  | | | |   \ \ / / | | | '_ ` _ \  | '__|  / __|
" | | | | | | | |_| |    \ V /  | | | | | | | | | |    | (__
" |_| |_| |_|  \__, |     \_/   |_| |_| |_| |_| |_|     \___|
"               __/ |
"              |___/
"
"   File: _vimrc
"   Version: 0.0
"   Maintainer: nyagonta
"   Last Change: 13-Feb-2015.
"   Note:
"       * ctags:				<http://hp.vector.co.jp/authors/VA025040/>
"       * cscope:				<http://cscope.sourceforge.net/>
"								<http://code.google.com/p/cscope-win32/> (win32 binary)
"       * MinGW:				<http://www.mingw.org/>
"       * The Silver Searcher:	<https://github.com/kjk/the_silver_searcher>
"
"---------------------------------------------------------------------------
" Initialization: {{{
" My autocmd group
augroup MyAutoCmd
	autocmd!
augroup END

" condition variables
let s:is_win   = has('win32') || has('win64')
let s:is_mac   = !s:is_win && (has('mac') || has('macunix') || has('gui_macvim') || system('uname') =~? '^darwin')
let s:is_linux = !s:is_win && !s:is_mac
"}}}

"---------------------------------------------------------------------------
" Encoding:"{{{
" https://github.com/daisuzu/dotvim/blob/master/.vimrc
"
" based on encode.vim
" https://sites.google.com/site/fudist/Home/vim-nihongo-ban/vim-utf8
if !has('gui_macvim')
	if !has('gui_running') && s:is_win
		set termencoding=cp932
		set encoding=cp932
	elseif s:is_win
		set termencoding=cp932
		set encoding=utf-8
	else
		set encoding=utf-8
	endif

	"set default fileencodings
	if &encoding == 'utf-8'
		set fileencodings=ucs-bom,utf-8,default,latin1
	elseif &encoding == 'cp932'
		set fileencodings=ucs-bom
	endif

	" set fileencodings for character code automatic recognition
	if &encoding !=# 'utf-8'
		set encoding=japan
		set fileencoding=japan
	endif
	if has('iconv')
		let s:enc_euc = 'euc-jp'
		let s:enc_jis = 'iso-2022-jp'
		" check whether iconv supports eucJP-ms.
		if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
			let s:enc_euc = 'eucjp-ms'
			let s:enc_jis = 'iso-2022-jp-3'
			" check whether iconv supports JISX0213.
		elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
			let s:enc_euc = 'euc-jisx0213'
			let s:enc_jis = 'iso-2022-jp-3'
		endif
		" build fileencodings
		if &encoding ==# 'utf-8'
			let s:fileencodings_default = &fileencodings
			let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
			let &fileencodings = &fileencodings .','. s:fileencodings_default
			unlet s:fileencodings_default
		else
			let &fileencodings = &fileencodings .','. s:enc_jis
			set fileencodings+=utf-8,ucs-2le,ucs-2
			if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
				set fileencodings+=cp932
				set fileencodings-=euc-jp
				set fileencodings-=euc-jisx0213
				set fileencodings-=eucjp-ms
				let &encoding = s:enc_euc
				let &fileencoding = s:enc_euc
			else
				let &fileencodings = &fileencodings .','. s:enc_euc
			endif
		endif
		" give priority to utf-8
		if &encoding == 'utf-8'
			set fileencodings-=utf-8
			let &fileencodings = substitute(&fileencodings, s:enc_jis, s:enc_jis.',utf-8','')
		endif

		" clean up constant
		unlet s:enc_euc
		unlet s:enc_jis
	endif

	" set fileformats automatic recognition
	if s:is_win
		set fileformats=dos,unix,mac
	else
		set fileformats=unix,mac,dos
	endif

	" to use the encoding to fileencoding when not included the Japanese
	if has('autocmd')
		function! AU_ReCheck_FENC()
			if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
				let &fileencoding = &encoding
				if s:is_win
					let &fileencoding = 'cp932'
				endif
			endif
		endfunction
		autocmd MyAutoCmd BufReadPost * call AU_ReCheck_FENC()
	endif

	" When internal encoding is not cp932 in Windows,
	" and environment variable contains multi-byte character
	command! -nargs=+ Let call Let__EnvVar__(<q-args>)
	function! Let__EnvVar__(cmd)
		let cmd = 'let ' . a:cmd
		if s:is_win && has('iconv') && &enc != 'cp932'
			let cmd = iconv(cmd, &enc, 'cp932')
		endif
		exec cmd
	endfunction
endif

" must be set with multibyte strings
" @see <http://rbtnn.hateblo.jp/entry/2014/11/30/174749>
scriptencoding utf-8    " マルチバイト文字を使う前に宣言 & set encoding より後
"}}}

"---------------------------------------------------------------------------
" NeoBundle:"{{{
" @see <https://github.com/Shougo/neobundle.vim>
" Note: Skip initialization for vim-tiny or vim-small.
if !1 | finish | endif

" NeoBundle の設定
if has('vim_starting')
	set runtimepath+=~/.vim/bundle/neobundle.vim/
endif
call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

" plugins: {{{
NeoBundle 'AndrewRadev/linediff.vim'
NeoBundle 'AndrewRadev/switch.vim'
NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'Shougo/neomru.vim'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle 'Shougo/unite.vim'				" 候補を絞り込んで実行するためのインターフェース
NeoBundle 'Shougo/unite-help'
NeoBundle 'Shougo/unite-outline'
NeoBundle 'Shougo/unite-session'
NeoBundle 'Shougo/vimfiler.vim'
NeoBundle 'Shougo/vimproc.vim', {
    \ 'build' : {
        \ 'windows' : 'make -f make_mingw32.mak',
        \ 'cygwin' : 'make -f make_cygwin.mak',
        \ 'mac' : 'make -f make_mac.mak',
        \ 'unix' : 'make -f make_unix.mak',
    \ },
\ }
NeoBundle 'bronson/vim-trailing-whitespace'	" 余計な空白の削除
NeoBundle 'hari-rangarajan/CCTree'
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'junegunn/vim-easy-align'
NeoBundle 'kana/vim-altr'
NeoBundle 'kana/vim-smartinput'				" 閉じカッコの自動挿入
NeoBundle 'kien/ctrlp.vim'
NeoBundle 'mattn/calendar-vim'
NeoBundle 'mhinz/vim-startify'
NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundle "osyo-manga/shabadou.vim"
NeoBundle 'osyo-manga/vim-anzu'
NeoBundle "osyo-manga/vim-watchdogs"
NeoBundle 'roblillack/vim-bufferlist'
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'scrooloose/syntastic'
NeoBundle "thinca/vim-quickrun"
NeoBundle "thinca/vim-unite-history"
NeoBundle 'tmhedberg/matchit'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'ujihisa/unite-font'
NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'vim-scripts/cscope-quickfix'
"}}}

" colorscheme {{{
" :Unite colorscheme -auto-preview
NeoBundle '29decibel/codeschool-vim-theme'
NeoBundle 'altercation/vim-colors-solarized'
NeoBundle 'croaker/mustang-vim'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'tomasr/molokai'
NeoBundle 'vim-scripts/github-theme'
"}}}

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
"}}}

"---------------------------------------------------------------------------
" Options: {{{
" Searching " {{{
"
set ignorecase      " 検索時に大文字・小文字を区別しない
set smartcase       " 検索時に大文字・小文字が混在していたら区別する
set wrapscan        " 検索文字列入力時に順次対象文字列にヒットさせない
set noincsearch     " 検索時にファイルの最後まで行ったら最初に戻らない (wrapscan:戻る)
set nowrapscan      " 検索文字列入力時に順次対象文字列にヒットさせない
set noincsearch     " カーソルを行頭、行末で止まらないようようにする
set nostartofline   " ジャンプした時、現在のカーソル位置をキープする
set whichwrap=b,s,<,>,[,]   " 特定のキーに行頭および行末の回りこみ移動を許可する
							" b : <BS>      ノーマルとビジュアル
							" s : <Space>   ノーマルとビジュアル
							" < : <Left>    ノーマルとビジュアル
							" > : <Right>   ノーマルとビジュアル
							" [ : <Left>    挿入と置換
							" ] : <Right>   挿入と置換
"}}}

" Editing {{{
"
" 挿入モードでバックスペースでインデントや改行を削除できるようにする
"  indent  行頭の空白の削除を許す
"  eol     改行の削除を許す
"  start  挿入モードの開始位置での削除を許す
set backspace=indent,eol,start

set showmatch                   " 閉じ括弧の入力時に対応する括弧に一時的に移動する
set cpoptions-=m                " Highlight when CursorMoved.
set matchtime=3
set matchpairs+=<:>             " Highlight <>.
set wildmenu                    " コマンドラインを補完する
set wildmode=list:full
set nolinebreak                 " ホワイトスペースで折り返さない
set formatoptions+=mM           " テキスト挿入中の自動折り返しを日本語に対応させる
set undolevels=2000             " undoの回数 (default:1000回)
set tw=0                        " 自動改行をさせない
set clipboard=unnamed           " クリップボードをWindowsと連携
set nrformats=alpha,octal,hex   " <C-a> <C-x> で英字も増減させる
set virtualedit=block           " 矩形ビジュアルモードで仮想編集を有効にする
set pumheight=10                " 補完メニューの高さ

" http://www.geocities.co.jp/SiliconValley-SantaClara/1183/computer/gvim.html
set iminsert=0 " インサートモードで日本語入力を ON にしない
set imsearch=0 " 検索モードで日本語入力を ON にしない
"}}}

" Indents and tabs options {{{
set noexpandtab     " タブの代わりに空白を挿入しない
set tabstop=4       " タブの画面上での幅
set shiftwidth=4    " cindentやautoindent時に挿入されるタブの幅
set softtabstop=0   " タブ入力時の空白変換を無効にする
set autoindent      " 新しい行のインデントを現在行と同じにする
set cindent         " コードを自動的にインデントする (C言語のコーディングに便利)
set smartindent     " 新しい行を作ったときに高度な自動インデントを行う
set smarttab        " 行頭の余白内でTabを打ち込むと、'shiftwidth'の数だけインデントする
set copyindent      " 既存の行のインデント構造をコピーする
set preserveindent  " カレント行のインデント変更時に可能な限りインデント構造を維持する
"}}}

" File options {{{
"
set nobackup                    " バックアップファイルを作成しない
"set backupdir=$HOME/vimbackup  " バックアップファイルを作るディレクトリ
set browsedir=buffer            " ファイル保存ダイアログの初期ディレクトリをバッファファイル位置に設定
"set directory=$HOME/vimbackup  " スワップファイル用のディレクトリ
set nohidden                    " ファイルを変更中のまま他のファイルを表示しない
"}}}

" VIM user interface {{{
" @note GUI固有ではない画面表示の設定
"
set number      " 行番号を表示
set noruler     " ルーラーを非表示

if has("gui_running")
	set list      " タブや改行を表示
else
	set nolist    " タブや改行を非表示
endif
" どの文字でタブや改行を表示するかを設定
if s:is_win
"	set listchars=tab:^\ ,trail:-,extends:<,precedes:<,nbsp:%
	set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
else
"    set listchars=tab:▸\ ,trail:-,extends:»,,precedes:«,,nbsp:%,eol:↲
endif

set nowrap      " 長い行を折り返さないで表示
set cmdheight=1 " コマンドラインの高さを1行に設定
set showmode    " 今使っているモードを表示する
set showcmd     " コマンドをステータス行に表示
set title       " タイトルを表示
set noea        " ウィンドー開閉時のサイズ変更OFF

set laststatus=2    " ステータスラインを常に表示
" ステータスラインに表示する項目を指定する
set statusline=Buffer%n:\ %<%t\ %m%r%h%w[%{&fileformat}][%{has('multi_byte')&&\ &fenc!=''?&fenc:&enc}]\ \ \ \ \ ASCII:\0x%B\ \ \ SUM:\%o\byte\%=%l\/%L,%c\ \ %P

if !has("gui_running")
set cursorline      " highlight current line
endif

"set report=0        " report back on all changes

set completeopt=menuone " チラツキ防止

" 起動時のメッセージの消去
set shortmess+=I
"}}}

" Folding "{{{
set foldenable                                          " Enable folding.
set foldmethod=marker
set foldopen=block,hor,mark,percent,quickfix,search,tag " what movements open folds
"}}}

" Mouse "{{{
" Enable mouse support.
set mouse=a
"}}}

" Misc "{{{
" Turn off annoying error bells:
set noerrorbells
set novisualbell
set t_vb=
set helplang=ja,en
set history=30                  " store lots of :cmdline history
"}}}
" }}}

"---------------------------------------------------------------------------
" Colors: "{{{
syntax on               " 色づけをオン
"colorscheme ir_black
colorscheme jellybeans
"}}}

"---------------------------------------------------------------------------
" Mappings: "{{{
"
" @see <https://gist.github.com/mopp/9115488#file-vac_82-vim>
" ※map系:再帰的処理あり, noremap系:再帰的処理なし
"
"-----------------------------------------------------------------------------------"
" コマンド        | ノーマル | 挿入 | コマンドライン | ビジュアル | 選択 | 演算待ち |
" map  / noremap  |    @     |  -   |       -        |     @      |  @   |    @     |
" nmap / nnoremap |    @     |  -   |       -        |     -      |  -   |    -     |
" vmap / vnoremap |    -     |  -   |       -        |     @      |  @   |    -     |
" omap / onoremap |    -     |  -   |       -        |     -      |  -   |    @     |
" xmap / xnoremap |    -     |  -   |       -        |     @      |  -   |    -     |
" smap / snoremap |    -     |  -   |       -        |     -      |  @   |    -     |
" map! / noremap! |    -     |  @   |       @        |     -      |  -   |    -     |
" imap / inoremap |    -     |  @   |       -        |     -      |  -   |    -     |
" cmap / cnoremap |    -     |  -   |       @        |     -      |  -   |    -     |
"-----------------------------------------------------------------------------------"
"
" .vimrcや.gvimrcの編集
" @see <http://vim-users.jp/2009/09/hack74/>
nnoremap <silent> <Space>ev  :<C-u>edit $MYVIMRC<CR>
nnoremap <silent> <Space>eg  :<C-u>edit $MYGVIMRC<CR>

" コマンドライン行での移動を制御
cnoremap <C-X> <C-r>=expand('%:p:h')<CR>/

" コマンドラインでのキーバインドを Emacs スタイルにする
" Ctrl+Aで行頭へ移動
"cnoremap <C-A>     <Home>
" Ctrl+Bで一文字戻る
cnoremap <C-B>      <Left>
" Ctrl+Dでカーソルの下の文字を削除
cnoremap <C-D>      <Del>
" Ctrl+Eで行末へ移動
cnoremap <C-E>      <End>
" Ctrl+Fで一文字進む:
cnoremap <C-F>      <Right>
" Ctrl+Nでコマンドライン履歴を一つ進む
cnoremap <C-N>      <Down>
" Ctrl+Pでコマンドライン履歴を一つ戻る
cnoremap <C-P>      <Up>
" Alt+Ctrl+Bで前の単語へ移動
cnoremap <Esc><C-B> <S-Left>
" Alt+Ctrl+Fで次の単語へ移動
cnoremap <Esc><C-F> <S-Right>

" cscopeデータベースの自動生成＆更新
" ※VIM起動時に cscope.out への接続を開始している必要がある
map <F2> :cs kill -1<CR>:!C:\msys\1.0\bin\find . -iname \*.c -o -iname *.cpp -o -iname \*.h -o -iname \*.s -o -iname \*.inc -o -iname \*.cfg > cscope.files<CR>:!cscope -b -i cscope.files -f cscope.out<CR>:cs reset<CR>:cs add cscope.out<CR>

" クリップボードへ１語コピーし、Grep検索
:set grepprg=internal       " Vim7 内蔵の grep
map <F3> :grep /<C-R><C-W>/j **/
map <S-F3> :grep
"   最初にマッチしたファイルを開かないようにするには j フラグを使う。
"   再帰的に検索するには **(starstar) を使う。
"   このコマンドを実行すると検索対象のファイルが全てMRUに反映されてしまう点に注意!!

" タグ生成
map <F4> :!ctags -R .<CR>:UpdateTypesFile<CR>

" 最近使ったファイル一覧 (mru.vim)
nnoremap <silent> <F5> :MRU<CR>

" BufferListの表示 (bufferlist.vim)
nnoremap <silent> <F7> :call BufferList()<CR>
"map <silent> <F7> :VSBufExplorer<CR>

" クリップボードへ１語コピーし、置換
map <F8> :%s/<C-R><C-W>/
"map <F8> #"*yw:%s/<C-V>/

" キーワードのハイライト表示
"nnoremap <silent> <F9> :SearchBuffers <C-R><C-W><CR>
"nnoremap <silent> <F9> :Search <C-R><C-W><CR>
nmap <F9> <Plug>(quickhl-toggle)

" キーワードのハイライト表示初期化
nmap <S-F9> <Plug>(quickhl-reset)

" 古い quickfix を参照する
" @see <http://vim-users.jp/2011/10/hack237/>
map <F10> :colder<CR>
map <S-F10> :cnewer<CR>

" ツリー型エクスプローラ表示・非表示の切り替え
map <F11> :NERDTreeToggle<CR>

" ウインド幅を１小さくする
map <F12> <C-W><
" ウインド幅を１大きくする
map <S-F12> <C-W>>
" ウインド幅を最大にする＆スクロールバーOFFにする
map <C-F12> :source $HOME/_vimrc<CR>:source $HOME/_gvimrc<CR>:simalt ~x<CR>:set guioptions-=r<CR>

" 前後のバッファへの移動
map <S-LEFT>  <ESC>:bp<CR>
map <S-RIGHT> <ESC>:bn<CR>
map <S-UP>    <ESC>:ls<CR>
map <LEFT>    <LEFT>
map <RIGHT>   <RIGHT>
map <UP>      <UP>

" Scratchの起動
"map <silent> <S-I> :Scratch<CR>  "よく押し間違えてしまうので変更するよ
map <silent> <M-i> :Scratch<CR>

" 検索語が画面の真ん中に来るようにし、折畳みを開く
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" Search selected area.
vnoremap <silent> z/ <ESC>/\v%V
vnoremap <silent> z? <ESC>?\v%V

" ESC代用
map! <M-q> <ESC>
inoremap jj <ESC>

" 行末までヤンク (dに対するD、ccに対するCと同様の対応をとる)
" @see http://itchyny.hatenablog.com/entry/2014/12/25/090000
nnoremap Y y$

" 数字のインクリメント、デクリメント
" @see http://itchyny.hatenablog.com/entry/2014/12/25/090000
nnoremap + <C-a>
nnoremap - <C-x>

" 時間表示
if s:is_win
	nnoremap tt :!echo Now...  \%date\% \%time\% <CR>
endif

" folding
" @see http://vim-jp.org/reading-vimrc/archive/040.html
" 作成

noremap <Space>fm zf
" 削除
noremap <Space>fd zd
" 全て開く
noremap <Space>fo zR
" 全て閉じる
noremap <Space>fc zM
" トグル
noremap <Space>ff za
" 移動
noremap <Space>fj zj
noremap <Space>fk zk
noremap <Space>fn ]z
noremap <Space>fp [z
noremap <Space>fi zMzv

nnoremap <leader>e :VimFilerExplore -split -winwidth=30 -find -no-quit<Cr>

" .vimrc .gvimrc に関する設定
if has("gui_running")
	nnoremap <silent> <Leader>so :<C-u>source $MYVIMRC<CR>:source $MYGVIMRC<CR>
else
	nnoremap <silent> <Leader>so :<C-u>source $MYVIMRC<CR>
endif
"}}}

"---------------------------------------------------------------------------
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

" .vimrcや.gvimrcを変更すると、自動的に変更が反映されるようにする
" @see <http://vim-users.jp/2009/09/hack74/>
if !has('gui_running') && !(has('win32') || has('win64'))
	" .vimrcの再読込時にも色が変化するようにする
	autocmd MyAutoCmd BufWritePost $MYVIMRC nested source $MYVIMRC
else
	" .vimrcの再読込時にも色が変化するようにする
	autocmd MyAutoCmd BufWritePost $MYVIMRC source $MYVIMRC |
				\if has('gui_running') | source $MYGVIMRC
	autocmd MyAutoCmd BufWritePost $MYGVIMRC if has('gui_running') | source $MYGVIMRC
endif

" デフォルトvimrc_exampleのtextwidth設定上書き
" @see <http://d.hatena.ne.jp/WK6/20120606/1338993826>
autocmd MyAutoCmd FileType text setlocal textwidth=0

" スワップがあるときは常にRead-Onlyで開く設定
" @see http://itchyny.hatenablog.com/entry/2014/12/25/090000
augroup swapchoice-readonly
	autocmd!
	autocmd SwapExists * let v:swapchoice = 'o'
augroup END

" デフォルトvimrc_exampleのtextwidth設定上書き
autocmd MyAutoCmd FileType text setlocal textwidth=0
"}}}

"---------------------------------------------------------------------------
" Plugin Settings: "{{{

" nathanaelkane/vim-indent-guides:インデントレベルを表示する {{{
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = ['help', 'nerdtree', 'tagbar', 'unite']
"}}}

" explorer: {{{
let g:explVertical=1        " Split vertically
let g:explStartRight=0      " Put new explorer window to the right(1)/left(0) of the
" current window
let g:explUseSeparators=1   " Use separator lines
let g:explWinSize=30
"}}}

" TagExplorer: {{{
let TE_Include_File_Pattern = '.*\.c$\|.*\.h$\|makefile'
let TE_Exclude_File_Pattern = '.*\.o$\|.*\.obj$\|.*\.bak$\|.*\.swp$\|core\|tags'
"}}}

" MultipleSearch: {{{
let g:MultipleSearchMaxColors=16    " Maximum number of different colors
let g:MultipleSearchColorSequence='red,green,yellow,blue,magenta,cyan,lightred,lightgreen,lightyellow,lightblue,lightmagenta,lightcyan,darkgreen,darkblue,darkmagenta,lightgray'
let g:MultipleSearchTextColorSequence='black,black,black,white,black,black,black,black,black,black,black,black,white,white,white,black'
"}}}

" taglist: {{{
" 概要：Exuberant Ctagsで生成したタグファイルにより、
"       別ウィンドウに変数、メソッド一覧を表示するスクリプト
" 注意：事前にExuberant Ctagsをインストールする必要あり!
"     <http://hp.vector.co.jp/authors/VA025040/ctags/>
let Tlist_Ctags_Cmd='C:/Vim/ctags/ctags'
let Tlist_Inc_Winwidth=0
set tags=tags;
"}}}

" mru: {{{
" 概要  ：vimエディタで最近開いたファイルを記録し、その一覧を表示する。
" 改良版：<https://sites.google.com/site/fudist/Home/modify>
" 記録ファイル数の上限設定
let MRU_Max_Entries = 1000
" 記録対象外ファイルの拡張子設定
"let MRU_Exclude_Files = '^/tmp|.*\|.*.log'
" 記録対象ファイルの拡張子設定
let MRU_Include_Files = '\.bat$\|\.inc$\|\.cpp$\|\.c$\|\.h$\|\.s$|\.txt$\|\.vim$'
" ウィンドウ高さ
let MRU_Window_Height = 20
" ウィンドウ表示設定(0: 新規ウィンドウ、1:カレントウィンドウ)
let MRU_Use_Current_Windo = 1
" ウィンドウ操作設定(0: ファイル選択時閉じない、1: 閉じる)
let MRU_Auto_Close = 1
" メニューバー設定(0: 追加無し、1:追加)
let MRU_Add_Menu = 0
"--- 改良版の追加オプション --------------------------
"ファイル名表示の色設定
let MRU_hi_Fname     = 'ctermfg=green ctermbg=none guifg=green guibg=bg'
let MRU_hi_FnamePath = 'ctermfg=cyan  ctermbg=none guifg=cyan  guibg=bg'
"カーソルラインを使用する
let MRU_Use_CursorLine = 1
"数字指定した場合は対応行のファイルを開く
let MRU_Use_Alt_useopen = 0
"編集されたバッファのウィンドウも使用する
let MRU_Use_Modified_Window = 0
"-----------------------------------------------------
"}}}

" cd.vim: {{{
"source $VIMRUNTIME/macros/cd.vim
" ↑タグジャンプができなくなるので、使うの止める
"}}}

" bufferlist: {{{
"map <silent> <F7> :call BufferList()<CR>   " ↑のMap設定に移動しました
let g:BufferListWidth = 10
let g:BufferListMaxWidth = 30
" 下の2行はcolorschemeを設定している_gvimrcに移動します
"hi BufferSelected guifg=green
"hi BufferNormal term=NONE ctermfg=black ctermbg=darkcyan cterm=NONE
"}}}

" bufexplorer: {{{
let g:bufExplorerDetailedHelp=1      " Show detailed help.
let g:bufExplorerFindActive=0        " Do not go to active window.
let g:bufExplorerShowDirectories=0   " Don't show directories.
let g:bufExplorerShowTabBuffer=1     " Yes.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
"let g:bufExplorerSortBy='fullpath'   " Sort by full file path name.
let g:bufExplorerSplitRight=0        " Split left.
"}}}

" mark: {{{
" 先頭記号の設定変更（デフォルト\）
"let mapleader = ","
"}}}

" matchit.vim: {{{
source $HOME/.vim/bundle/matchit/plugin/matchit.vim
"}}}

" cscope_quickfix: {{{
let Cscope_ToolMenu = 0      " メニュー非表示
"}}}

" cctree: {{{
" Cscope database file
let CCTreeCscopeDb = "cscope.out"
" Maximum call levels
let CCTreeRecursiveDepth = 3
" Maximum visible(unfolded) level
let CCTreeMinVisibleDepth = 3
" Orientation of window (standard vim options for split: [right|left][above|below])
let CCTreeOrientation = "leftabove"
"}}}

" ChangeLog: {{{
let g:changelog_timeformat = "%Y-%m-%d"
let g:changelog_username = "nyagonta <nyagonta@gmail.com>"
"}}}

" Vimwiki: {{{
let g:vimwiki_list_ignore_newline = 0
let g:vimwiki_list = [{'path': '~/vimwiki/',
      \ 'path_html': '~/vimwiki/html',
      \ 'html_header': '~/vimwiki/template/header.tpl',
      \ 'html_footer': '~/vimwiki/template/footer.tpl',
      \ 'css_name':'css/style.css'},
      \ {'path': '~/syswiki/',
      \ 'path_html': '~/syswiki/html',
      \ 'html_header': '~/syswiki/template/header.tpl',
      \ 'html_footer': '~/syswiki/template/footer.tpl',
      \ 'css_name':'css/style.css'}]
"}}}

" DoxygenToolkit: {{{
let g:DoxygenToolkit_startCommentBlock = "/*"
let g:DoxygenToolkit_interCommentTag = "*	"
let g:DoxygenToolkit_blockHeader="******************************************************************************"
let g:DoxygenToolkit_blockFooter="******************************************************************************"
let g:DoxygenToolkit_compactDoc="yes"
"}}}

" NERDTree: {{{
" 無視するファイルを設定する
let NERDTreeIgnore=['\.swp$', '\.keep$', '\.files$', '\.out$', '\.tags$', '\.taghl$', '\~$']
"}}}

" osyo-manga/vim-anz : 現在の検索位置を表示する {{{
" 移動後にステータス情報をコマンドラインへと出力を行います。
nmap n <Plug>(anzu-n-with-echo)
nmap N <Plug>(anzu-N-with-echo)
nmap * <Plug>(anzu-star-with-echo)
nmap # <Plug>(anzu-sharp-with-echo)
"}}}

" kana/vim-alt : 関連するファイルに切り替える {{{
command! A  call altr#forward()

" @seet <http://d.hatena.ne.jp/joker1007/20111107/1320671775>
" For ruby tdd
call altr#define('%.rb', 'spec/%_spec.rb')
" For rails tdd
call altr#define('app/models/%.rb', 'spec/models/%_spec.rb', 'spec/factories/%s.rb')
call altr#define('app/controllers/%.rb', 'spec/controllers/%_spec.rb')
call altr#define('app/helpers/%.rb', 'spec/helpers/%_spec.rb')
"}}}

" Ctrl-P {{{
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_custom_ignore = {
    \ 'file': '\v\.(exe|so|dll|keep|bak)$',
    \ }
if executable('pt')
	let g:ctrlp_user_command = 'pt %s -l'
endif
"}}}

" unite {{{
" The prefix key.
nnoremap    [unite]   <Nop>
nmap    <Space>u [unite]

nnoremap <silent> [unite]u  :<C-u>Unite<Space>file<CR>
nnoremap <silent> [unite]f  :<C-u>Unite<Space>buffer<CR>
nnoremap <silent> [unite]b  :<C-u>Unite<Space>bookmark<CR>
nnoremap <silent> [unite]m  :<C-u>Unite<Space>file_mru<CR>
nnoremap <silent> [unite]uu :<C-u>Unite<Space>file_mru file<CR>
nnoremap <silent> [unite]r  :<C-u>UniteWithBufferDir file<CR>
nnoremap <silent> [unite]o  :<C-u>Unite<Space>outline<CR>
let g:unite_source_history_yank_enable = 1
nnoremap <silent> [unite]h  :<C-u>Unite<Space>history/yank<CR>
nnoremap <silent> [unite]:  :<C-u>Unite history/command<CR>
nnoremap <silent> [unite]/  :<C-u>Unite history/search<CR>

" grep検索
nnoremap <silent> [unite]g :<C-u>Unite grep:. -buffer-name=search-buffer<CR>

" ディレクトリを指定してgrep検索
nnoremap <silent> [unite]dg :<C-u>Unite grep -buffer-name=search-buffer<CR>

" カーソル位置の単語をgrep検索
nnoremap <silent> [unite]cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>

" grep検索結果の再呼出
nnoremap <silent> [unite]r  :<C-u>UniteResume search-buffer<CR>

" unite grep に pt (The Platinum Searcher) を使う
if executable('ag')
	let g:unite_source_grep_command = 'ag'
	let g:unite_source_grep_default_opts = '--nogroup --nocolor'
	let g:unite_source_grep_recursive_opt = ''
endif
"}}}

" open-browser {{{
" <http://vim-users.jp/2011/08/hack225/>
"   let $URL = 'https://www.google.co.jp/'
"   call system('cmd.exe /c start firefox %^URL%')
let g:netrw_nogx = 1 " disable netrw's gx mapping.
let g:openbrowser_open_rules = {'cmd.exe': 'cmd /c start firefox {openbrowser#shellescape(uri)}'}
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
"}}}

" vim-quickhl {{{
"　　
" <http://vim-users.jp/2011/08/hack226/>
nmap <Space>m <Plug>(quickhl-toggle)
xmap <Space>m <Plug>(quickhl-toggle)
nmap <Space>M <Plug>(quickhl-reset)
xmap <Space>M <Plug>(quickhl-reset)
nmap <Space>j <Plug>(quickhl-match)
let g:quickhl_keywords = [
    \ ",",
    \ ":",
    \ ]
let g:quickhl_colors = [
    \ "gui=bold ctermfg=16 ctermbg=153 guifg=#ffffff guibg=#0a7383",
    \ "gui=bold ctermfg=7 ctermbg=1 guibg=#a07040 guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=2 guibg=#4070a0 guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=3 guibg=#40a070 guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=4 guibg=#70a040 guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=5 guibg=#0070e0 guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=6 guibg=#007020 guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=21 guibg=#d4a00d guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=22 guibg=#06287e guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=45 guibg=#5b3674 guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=16 guibg=#4c8f2f guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=50 guibg=#1060a0 guifg=#ffffff",
    \ "gui=bold ctermfg=7 ctermbg=56 guibg=#a0b0c0 guifg=black",
    \ ]
"}}}

" lightline {{{
" powerline フォントパッチ
"   http://qiita.com/s_of_p/items/b7ab2e4a9e484ceb9ee7
let g:lightline = {
      \ 'colorscheme': 'jellybeans',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ], [ 'fugitive', 'filename' ], ['ctrlpmark'] ],
      \   'right': [ [ 'syntastic', 'lineinfo' ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'modified': 'MyModified',
      \   'readonly': 'MyReadonly',
      \   'fugitive': 'MyFugitive',
      \   'filename': 'MyFilename',
      \   'fileformat': 'MyFileformat',
      \   'filetype': 'MyFiletype',
      \   'fileencoding': 'MyFileencoding',
      \   'mode': 'MyMode',
      \   'ctrlpmark': 'CtrlPMark',
      \ },
      \ 'component_expand': {
      \   'syntastic': 'SyntasticStatuslineFlag',
      \ },
      \ 'component_type': {
      \   'syntastic': 'error',
      \ },
      \ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
      \ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" }
      \ }


function! MyModified()
  return &ft =~ 'help' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! MyReadonly()
  return &ft !~? 'help' && &readonly ? 'RO' : ''
endfunction

function! MyFilename()
  let fname = expand('%:t')
  return fname == 'ControlP' ? g:lightline.ctrlp_item :
        \ fname == '__Tagbar__' ? g:lightline.fname :
        \ fname =~ '__Gundo\|NERD_tree' ? '' :
        \ &ft == 'vimfiler' ? vimfiler#get_status_string() :
        \ &ft == 'unite' ? unite#get_status_string() :
        \ &ft == 'vimshell' ? vimshell#get_status_string() :
        \ ('' != MyReadonly() ? MyReadonly() . ' ' : '') .
        \ ('' != fname ? fname : '[No Name]') .
        \ ('' != MyModified() ? ' ' . MyModified() : '')
endfunction

function! MyFugitive()
  try
    if expand('%:t') !~? 'Tagbar\|Gundo\|NERD' && &ft !~? 'vimfiler' && exists('*fugitive#head')
      let mark = ''  " edit here for cool mark
      let _ = fugitive#head()
      return strlen(_) ? mark._ : ''
    endif
  catch
  endtry
  return ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? &fileformat : ''
endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : 'no ft') : ''
endfunction

function! MyFileencoding()
  return winwidth(0) > 70 ? (strlen(&fenc) ? &fenc : &enc) : ''
endfunction

function! MyMode()
  let fname = expand('%:t')
  return fname == '__Tagbar__' ? 'Tagbar' :
        \ fname == 'ControlP' ? 'CtrlP' :
        \ fname == '__Gundo__' ? 'Gundo' :
        \ fname == '__Gundo_Preview__' ? 'Gundo Preview' :
        \ fname =~ 'NERD_tree' ? 'NERDTree' :
        \ &ft == 'unite' ? 'Unite' :
        \ &ft == 'vimfiler' ? 'VimFiler' :
        \ &ft == 'vimshell' ? 'VimShell' :
        \ winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! CtrlPMark()
  if expand('%:t') =~ 'ControlP'
    call lightline#link('iR'[g:lightline.ctrlp_regex])
    return lightline#concatenate([g:lightline.ctrlp_prev, g:lightline.ctrlp_item
          \ , g:lightline.ctrlp_next], 0)
  else
    return ''
  endif
endfunction

let g:ctrlp_status_func = {
  \ 'main': 'CtrlPStatusFunc_1',
  \ 'prog': 'CtrlPStatusFunc_2',
  \ }

function! CtrlPStatusFunc_1(focus, byfname, regex, prev, item, next, marked)
  let g:lightline.ctrlp_regex = a:regex
  let g:lightline.ctrlp_prev = a:prev
  let g:lightline.ctrlp_item = a:item
  let g:lightline.ctrlp_next = a:next
  return lightline#statusline(0)
endfunction

function! CtrlPStatusFunc_2(str)
  return lightline#statusline(0)
endfunction

let g:tagbar_status_func = 'TagbarStatusFunc'

function! TagbarStatusFunc(current, sort, fname, ...) abort
    let g:lightline.fname = a:fname
  return lightline#statusline(0)
endfunction

augroup AutoSyntastic
  autocmd!
  autocmd BufWritePost *.c,*.cpp call s:syntastic()
augroup END
function! s:syntastic()
  SyntasticCheck
  call lightline#update()
endfunction

let g:unite_force_overwrite_statusline = 0
let g:vimfiler_force_overwrite_statusline = 0
let g:vimshell_force_overwrite_statusline = 0
"}}}

" neosnippet {{{
"   * C-k to select-and-expand a snippet from the Neocomplcache popup
"      (Use C-n and C-p to select it).
"      C-k can also be used to jump to the next field in the snippet.
"   * Tab to select the next field to fill in the snippet.
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" Enable snipMate compatibility feature.
let g:neosnippet#enable_snipmate_compatibility = 1

" Tell Neosnippet about the other snippets
let g:neosnippet#snippets_directory='~/.vim/bundle/vim-snippets/snippets'
"}}}
"}}}

set secure  " must be written at the last.  see :help 'secure'.

" vim: set ts=4 sts=4 sw=4 tw=0
