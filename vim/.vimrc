" ------------------- 
" 日本語の設定 
" ------------------- 
"set termencoding=utf-8 
"set encoding=japan 
"set fileencodings=utf-8,euc-jp,sjis,cp932,iso-2022-jp 
"set fenc=euc-jp 
"set enc=euc-jp 

" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
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
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

"set number 

set tabstop=4 

set expandtab 

"set autoindent 

set backspace=2 

set showmatch 

set laststatus=2 

set showcmd 

set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P 
hi statusline term=NONE cterm=NONE ctermfg=white ctermbg=lightblue 

" tabline 
function! MyTabLabel(n) 
" tabline にカレントウィンドウのバッファ名表示させたい 
let buflist = tabpagebuflist(a:n) 

" のでタブのなかのカレントウィンドの番号を使う 
let winnr = tabpagewinnr(a:n) 

" あとタブのなかにあるウィンドウ数表示させたい 
let buflen = tabpagewinnr(a:n, '$') 

" ファイル名を表示させたい(ながいのは困るのでファイル名のぶんだけ) 
let bufname = fnamemodify(bufname(buflist[winnr - 1]), ':t') 

" バッファ名、なければ No name に 
let label = bufname == '' ? 'No name' : bufname 

" tabline に表示させる文字列返す 
return label 
endfunction 

" あとはヘルプにあるのそのまま 
function! MyTabLine() 
let s = '' 
for i in range(tabpagenr('$')) 
if i + 1 == tabpagenr() 
let s .= '%#TabLineSel#' 
else 
let s .= '%#TabLine#' 
endif 
let s .= '%' . (i + 1) . 'T' 
let s .= ' %{MyTabLabel(' . (i + 1) . ')} ' 
endfor 
let s .= '%#TabLineFill#%T' 
if tabpagenr('$') > 1 
let s .= '%=%#TabLine#%999Xx' 
endif 
return s 
endfunction 
set tabline=%!MyTabLine() 
set showtabline=1 
hi TabLine term=NONE cterm=NONE ctermfg=yellow ctermbg=black 
hi TabLineFill term=NONE cterm=NONE ctermfg=yellow ctermbg=black 
hi TabLineSel term=NONE cterm=NONE ctermfg=black ctermbg=yellow 

" Syntax on/off 
syntax on

" 検索結果をハイライト
set hlsearch
