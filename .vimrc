" vim: fdm=marker
" .vimrc file
" Recommended for vim >= 7, though works with vim 6
" By Lucas Oman
" me@lucasoman.com
" --enable-rubyinterp --prefix=/usr --enable-ruby

set nocompatible
syntax on filetype on

" fast terminal for smoother redrawing
set ttyfast

" {{{ interface
" lines, cols in status line
set ruler
set rulerformat=%=%h%m%r%w\ %(%c%V%),%l/%L\ %P

" a - terse messages (like [+] instead of [Modified]
" t - truncate file names
" I - no intro message when starting vim fileless
set shortmess=atI

" display the number of (characters|lines) in visual mode, also cur command
set showcmd

" current mode in status line
set showmode

" max items in insert menu
if version >= 700
  set pumheight=8
endif

" number column
set number
if version >= 700
  set numberwidth=3
end

" show fold column, fold by markers
set foldcolumn=2
set foldmethod=marker

" line numbering
set showbreak=>\ 

" always show tab line
if version >= 700
  set showtabline=2
endif

" highlight search matches
set hlsearch

" highlight position of cursor
set cursorline
set cursorcolumn

"set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"set laststatus=2
" }}}
" {{{ colors
" tabe line colors
highlight TabLineFill ctermfg=0
highlight TabLine ctermfg=7 ctermbg=0 cterm=none
highlight TabLineSel ctermfg=7 cterm=bold ctermbg=0

" number column colors
highlight LineNr cterm=bold ctermbg=0 cterm=none ctermfg=4

" fold colors
highlight Folded cterm=bold ctermbg=0 cterm=none ctermfg=4
highlight FoldColumn cterm=bold ctermbg=0 cterm=none ctermfg=4

" visual mode colors
highlight Visual ctermbg=7 ctermfg=4

" dictionary menu colors
highlight Pmenu ctermbg=7 ctermfg=0
highlight PmenuSel ctermbg=1 ctermfg=0

highlight CursorColumn cterm=bold ctermbg=0 cterm=none
highlight CursorLine cterm=bold ctermbg=0 cterm=none

highlight Search cterm=none ctermbg=7 ctermfg=4

" the dark colors kill my eyes
set background=light
" }}}
" {{{ behavior
set shiftwidth=2
set tabstop=2
set cindent

" turn off auto-wrap in all cases.
" let's see what happens with below formatoptions
" set tw=0

" show matching enclosing chars for .1 sec
set showmatch
set matchtime=1

set formatoptions-=t
set formatoptions+=lcro

" context while scrolling
set scrolloff=3

" arrow keys, bs, space wrap to next/prev line
set whichwrap=b,s,<,>,[,]

" backspace over anything
set backspace=indent,eol,start

" case insensitive search if all lowercase
set ignorecase smartcase

" turn off bells, change to screen flash
set visualbell

" gf should use new tab, not current buffer
if version >= 700
	map gf :tabe <cfile><CR>
else
	map gf :bad <cfile><CR>
endif

" show our whitespace
" alternate character: »
"not a big fan of this; will keep just in case
"set listchars=tab:··,trail:·
"set list

" complete to longest match, then list possibilities
set wildmode=longest,list

" }}}
" {{{ filetype dependent
" dictionary of php function names for c-x-c-k
autocmd FileType php setlocal dictionary=~/.vim/funclist.txt
" I wanted to start with all folds closed, but vim is slightly retarded:
" C-r and C-m will always add or subtract from foldlevel, even if there are no more folds to affect,
" which requires hitting C-m 98 times to close the lowest fold if there are only 2 levels of folds if foldlevelstart=99
"autocmd FileType php setlocal foldlevelstart=2

"cake's thtml files need syntax highlighting
autocmd BufNewFile,BufRead *.thtml setlocal filetype=php

" ruby commenstring
autocmd FileType ruby setlocal commentstring=#%s
"}}}
" {{{ mapped shortcuts
" quicker aliases for navigating tabs
nmap H <ESC>gT
nmap L <ESC>gt
" creates a fold from a block of code in {}s
nmap \pf <ESC>$va}zf
" php syntax check
nmap \ps <ESC>:!php -l %<CR>
nmap \ff <ESC>:call ToggleFoldFuncs()<CR>
" turns of highlighting
nmap \/ <ESC>:nohl<CR>
" keep block highlighted when indenting
vmap >> >gv
vmap << <gv
nmap \l o----------------------------------------------------<CR><ESC>
" phpdoc comments
nmap \cb o/**<CR><BS> * <CR>*<CR>* @author Lucas Oman <lucas.oman@bookit.com><CR>* @param <CR>* @return <CR>* @example <CR>*/<ESC>kkkkkk$a
nmap \cp o/**<CR><BS> * <CR>*<CR>* @author Lucas Oman <me@lucasoman.com><CR>* @param <CR>* @return <CR>* @example <CR>*/<ESC>kkkkkk$a
nmap \sc :!svnconsole.php<CR><CR>
nmap \sd :!svn diff %<CR>
" Open Current (path)
nmap \oc :tabe %:h<CR>
" fix a block of XML; inserts newlines, indents properly, folds by indent
nmap \fx <Esc>:setlocal filetype=xml<CR>:%s/></>\r</g<CR>:1,$!xmllint --format -<CR>:setlocal foldmethod=indent<CR>
nmap <F2> <ESC>:call ToggleColumns()<CR>
imap <F2> <C-o>:call ToggleColumns()<CR>
nmap <F3> <ESC>:call LoadSession()<CR>
nmap <F4> <ESC>:!updater<CR>
set pastetoggle=<F5>
nmap <F6> <ESC>:!~/lib/updatedev.php<CR>
nmap <F7> <ESC>:!~/lib/updatedev.php %:p<CR>
nmap <F8> <ESC>:call WriteTrace()<CR>
" }}}
" abbreviations {{{
ab _test print('lbotest: '.rand());//lbotest
" }}}
"{{{ ToggleColumns()
"make it easy to remove line number column etc. for cross-terminal copy/paste
function ToggleColumns()
  if &number
    set nonumber
    set foldcolumn=0
    let s:showbreaktmp = &showbreak
    set showbreak=
		"set nolist
  else
    set number
    set foldcolumn=2
    let &showbreak = s:showbreaktmp
		"set list
  end
endfunction
"}}}
"{{{ ToggleFoldFuncs()
"turns on or off folding php functions
function ToggleFoldFuncs()
	if &foldmethod == "marker"
		setlocal foldmethod=expr
		setlocal foldexpr=FoldFuncsExpr(v:lnum)
	else
		setlocal foldmethod=marker
	end
endfunction
function FoldFuncsExpr(num)
	"if match(getline(a:num),"function \w+\s?\(") > -1
	if match(getline(a:num),"function ") > -1
		return ">1"
	else
		return "="
	endif
endfunction
"}}}
"WriteTrace() {{{
function WriteTrace()
	let lineNum = line('.')
	let lineFile = bufname('%')
	let lineVal = getline(lineNum)

	let allLines = readfile($HOME."/trace.txt")
	let allLines = add(allLines,lineFile.":".lineNum)
	let allLines = add(allLines,lineVal)
	let allLines = add(allLines,"")

	call writefile(allLines,$HOME."/trace.txt")
endfunction
"}}}
"{{{ session stuff
" don't store any options in sessions
if version >= 700
  set sessionoptions=blank,buffers,curdir,tabpages,winpos,folds
endif

" automatically update session, if loaded
let s:sessionloaded = 0
function LoadSession()
  source Session.vim
  let s:sessionloaded = 1
endfunction
function SaveSession()
  if s:sessionloaded == 1
    mksession!
  end
endfunction
autocmd VimLeave * call SaveSession()
" }}}
"{{{ list stuff
if version >= 700
	"autocmd BufNewFile,BufRead *.list highlight CursorLine NONE
	autocmd BufNewFile,BufRead *.list call ListFile()
	"autocmd TabLeave *.list highlight CursorLine cterm=bold ctermbg=0 cterm=none
	autocmd TabEnter *.list call ListFile()

	" 'install' list features
	function ListFile()
		setlocal foldmethod=expr
		setlocal foldexpr=ListFoldLevel(v:lnum)
		setlocal shiftwidth=4
		setlocal tabstop=4
		setlocal foldtext=ListFoldLine(v:foldstart)
		setlocal noshowmatch
		setlocal cindent
		" add [n]ew item below current
		map <buffer> ,n o- <C-R>=ListTimestamp()<CR><ESC>^la
		" mark item as [x]
		map <buffer> ,x mz^rxf[hdf]$a<C-R>=ListTimestamp()<CR><ESC>`z
		" mark item as [-]
		map <buffer> ,- mz^r-f[hdf]$a<C-R>=ListTimestamp()<CR><ESC>`z
		" mark item as = (in [p]rogress)
		map <buffer> ,p mz^r=f[hdf]$a<C-R>=ListTimestamp()<CR><ESC>`z
		" mark item as [o]
		map <buffer> ,o mz^rof[hdf]$a<C-R>=ListTimestamp()<CR><ESC>`z
		" mark item with a rank
		map <buffer> ,1 mz^r1f[hdf]$a<C-R>=ListTimestamp()<CR><ESC>`z
		map <buffer> ,2 mz^r2f[hdf]$a<C-R>=ListTimestamp()<CR><ESC>`z
		map <buffer> ,3 mz^r3f[hdf]$a<C-R>=ListTimestamp()<CR><ESC>`z
		map <buffer> ,4 mz^r4f[hdf]$a<C-R>=ListTimestamp()<CR><ESC>`z
		map <buffer> ,5 mz^r5f[hdf]$a<C-R>=ListTimestamp()<CR><ESC>`z
		" add/update [t]imestamp
		map <buffer> ,t mz$a [<ESC>^f[hd$a<C-R>=ListTimestamp()<CR><ESC>`z
	endfunction

	" return properly formatted timestamp
	function ListTimestamp()
		return ' ['.strftime('%y-%m-%d %H:%M').']'
	endfunction

	" return fold line format
	function ListFoldLine(linenum)
		let s:count = 1
		let s:spaces = ''
		while s:count <= &shiftwidth
			let s:spaces = s:spaces.' '
			let s:count = s:count + 1
		endwhile
		return substitute(getline(a:linenum),"\t",s:spaces,'g')
	endfunction

	" foldexpr function
	function ListFoldLevel(linenum)
		let s:prefix = ''
		let s:myline = getline(a:linenum)
		let s:nextline = getline(a:linenum+1)
		let s:mynumtabs = match(s:myline,"[^\t]",0)
		let s:nextnumtabs = match(s:nextline,"[^\t]",0)
		if s:nextnumtabs > s:mynumtabs " if this item has sub-items
			let s:level = s:nextnumtabs
		else " next item is either same or higher level
			let s:level = s:mynumtabs
			if s:nextnumtabs < s:mynumtabs " if next item has higher level, close this fold
				let s:prefix = '<'
				let s:level = s:nextnumtabs+1
			end
		endif
		if a:linenum > 1
			s:pline = getline(a:linenum-1)
			s:pnumtabs = match(s:pline,"[^\t]",0)
			if s:level < s:pnumtabs
			" if this is higher level than prev, start a new fold
				let s:prefix = '>'
			endif
		endif
		return s:prefix.s:level
	endfunction
endif
"}}}
"{{{ tab line stuff
function MyTabLine()
	let s = ''
	for i in range(tabpagenr('$'))
		" select the highlighting
		if i + 1 == tabpagenr()
			let s .= '%#TabLineSel#'
		else
			let s .= '%#TabLine#'
		endif

		" set the tab page number (for mouse clicks)
		let s .= '%' . (i + 1) . 'T'.(i+1).''

		" the filename is made by MyTabLabel()
		let s .= '%{MyTabLabel(' . (i + 1) . ')}  '
	endfor

	" after the last tab fill with TabLineFill and reset tab page nr
	let s .= '%#TabLineFill#%T'

	return s
endfunction

function MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let fullname = bufname(buflist[winnr - 1])
	"let fullname = substitute(fullname,"(\w){1}\w*/","\1/","g")
	let fullname = substitute(fullname,".*/","","")
	if getbufvar(buflist[winnr - 1],"&mod")
		let modified = "+"
	else
		let modified = " "
	endif
	return modified.fullname
endfunction

if version >= 700
	" Use the above tabe naming scheme
	set tabline=%!MyTabLine()
endif
"}}}
"php syntax options {{{
let php_sql_query = 1  "for SQL syntax highlighting inside strings
let php_htmlInStrings = 1  "for HTML syntax highlighting inside strings
"php_baselib = 1  "for highlighting baselib functions
"php_asp_tags = 1  "for highlighting ASP-style short tags
"php_parent_error_close = 1  "for highlighting parent error ] or )
"php_parent_error_open = 1  "for skipping an php end tag, if there exists an open ( or [ without a closing one
"php_oldStyle = 1  "for using old colorstyle
"php_noShortTags = 1  "don't sync <? ?> as php
let php_folding = 1  "for folding classes and functions
" }}}
" rainbow parens {{{
let g:rainbow = 1
let g:rainbow_brace = 1
let g:rainbow_bracket = 1
let g:rainbow_paren = 1
autocmd BufWinEnter * source $HOME/.vim/plugin/rainbow_paren.vim
"}}}
