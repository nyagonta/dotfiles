"---------------------------------------------------------------------------
"                                        _
"                                       (_)
"  _ __ ___    _   _      __ _  __   __  _   _ __ ___    _ __    ___
" | '_ ` _ \  | | | |    / _` | \ \ / / | | | '_ ` _ \  | '__|  / __|
" | | | | | | | |_| |   | (_| |  \ V /  | | | | | | | | | |    | (__
" |_| |_| |_|  \__, |    \__, |   \_/   |_| |_| |_| |_| |_|     \___|
"               __/ |     __/ |
"              |___/     |___/
"
"   File: _gvimrc
"   Version: 0.0
"   Maintainer: nyagonta
"   Last Change: 12-Feb-2015.
"   Note:
"
"---------------------------------------------------------------------------

"---------------------------------------------------------------------------
" fonts:{{{
if has('win32')
  set guifont=Consolas:h9:cSHIFTJIS
"  set guifont=Sauce_Code_Powerline:h9
" こっちは日本語フォント
"  set guifontwide=Ricty:h10
"  set guifontwide=Osaka－等幅:h9
  set linespace=1		    " 行間隔の設定
  " 一部のUCS文字の幅を自動計測して決める
  if has('kaoriya')
    set ambiwidth=auto
  endif
elseif has('mac')
  set guifont=Osaka－等幅:h14
elseif has('xfontset')
  " UNIX用 (xfontsetを使用)
  set guifontset=a14,r14,k14
endif
" }}}

"---------------------------------------------------------------------------
" gVIM user interface {{{
"
"set columns=120  " ウインドウの幅
"set lines=60	  " ウインドウの高さ
"winpos 600 10	  " 起動時のウィンドウの位置を指定
set guioptions-=T " ツールバーを消す
"set guioptions-=m " メニューバーを消す
"set notitle " タイトルバーを消す
set guioptions-=l " 左側の縦スクロールバーを消す
set guioptions-=L
set cmdheight=1   " Kaoriya gvimrc の設定上書き用

"set background=dark
"colorscheme solarized
"colorscheme ir_black
colorscheme jellybeans

" メニューバーの文字化け対処
" http://kaworu.jpn.org/kaworu/2013-05-08-1.php
source $VIMRUNTIME/delmenu.vim
set langmenu=ja_jp.utf-8
source $VIMRUNTIME/menu.vim

" ウィンドウの位置とサイズを記憶する {{{
" @see http://vim-users.jp/2010/01/hack120/
let g:save_window_file = expand('~/.vimwinpos')
augroup SaveWindow
  autocmd!
  autocmd VimLeavePre * call s:save_window()
  function! s:save_window()
    let options = [
      \ 'set columns=' . &columns,
      \ 'set lines=' . &lines,
      \ 'winpos ' . getwinposx() . ' ' . getwinposy(),
      \ ]
    call writefile(options, g:save_window_file)
  endfunction
augroup END

if filereadable(g:save_window_file)
  execute 'source' g:save_window_file
endif
" }}}
" }}}

"---------------------------------------------------------------------------
" Cursor {{{
set guicursor=a:blinkon0  " カーソルを点滅しないようにする
" }}}

"---------------------------------------------------------------------------
" Clipboard {{{
set clipboard=unnamed	  " 選択した文字をクリップボードに入れる
" }}}

"---------------------------------------------------------------------------
" Japanese language input settig {{{
if has('multi_byte_ime') || has('xim')
  " IME ON時のカーソルの色を設定(設定例:紫)
  highlight CursorIM guibg=Purple guifg=NONE
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    " XIMの入力開始キーを設定:
    " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
    "set imactivatekey=s-space
  endif
  " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
  "inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif
" }}}

"---------------------------------------------------------------------------
" mouse {{{
" どのモードでもマウスを使えるようにする
set mouse=a
" マウスの移動でフォーカスを自動的に切替えない (mousefocus:切替る)
set nomousefocus
" 入力時にマウスポインタを隠す (nomousehide:隠さない)
set mousehide
" ビジュアル選択(D&D他)を自動的にクリップボードへ (:help guioptions_a)
"set guioptions+=a
" マウスの選択の動作を設定する
if has('win32')
  behave mswin
else
  behave xterm
endif
" }}}

"---------------------------------------------------------------------------
" Print {{{
" 印刷用フォント
if has('printer')
  if has('win32')
    set printfont=MS_Gothic:h7:cSHIFTJIS
  endif
endif
" }}}

"---------------------------------------------------------------------------
" Plugin Settings {{{
"
" MultipleSearch.vim {{{
":SearchReinit
" }}}

" bufferlist {{{
"hi BufferSelected guifg=green
"hi BufferSelected gui=NONE guifg=#0fffff guibg=#005080
hi BufferSelected gui=NONE guifg=#05ff77 guibg=#0020ff
"hi BufferNormal gui=NONE guifg=gray guibg=black
"hi BufferNormal gui=NONE guifg=gray guibg=#223388
hi BufferNormal gui=NONE guifg=gray guibg=#031210
" }}}
" }}}

