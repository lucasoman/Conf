" vim: fdm=marker:
" Recommended for vim >= 7; no guarantee of compatibility with earlier versions
" Lucas Oman <me@lucasoman.com>
" --enable-rubyinterp --prefix=/usr --enable-ruby
" Get latest from: http://github.com/lucasoman/Conf/raw/master/.vimrc


" misc options
" {{{ interface
" lines, cols in status line
set ruler
set rulerformat=%=%h%m%r%w\ %(%c%V%),%l/%L\ %P

" a - terse messages (like [+] instead of [Modified]
" t - truncate file names
" I - no intro message when starting vim fileless
" T - truncate long messages to avoid having to hit a key
set shortmess=atTI

" display the number of (characters|lines) in visual mode, also cur command
set showcmd

" current mode in status line
set showmode

" max items in popup menu
set pumheight=8

" show number column
set number
set numberwidth=3

" show fold column, fold by markers
set foldcolumn=2
set foldmethod=marker

" indicate when a line is wrapped by prefixing wrapped line with '> '
set showbreak=>\ 

" always show tab line
set showtabline=2

" highlight search matches
set hlsearch

" highlight position of cursor
"set cursorline
"set cursorcolumn

"set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)
"set statusline=%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
"set laststatus=2
" }}}
" {{{ behavior
set nocompatible
syntax on
filetype on
"filetype plugin on

" fast terminal for smoother redrawing
set ttyfast

set omnifunc=syntaxcomplete#Complete

" indentation options
" Note: smartindent is seriously outdated. cindent, even, is unnecessary.
" Let the filetype plugins do the work.
set shiftwidth=2
set tabstop=2
"filetype indent on
set autoindent
set cindent

" show matching enclosing chars for .1 sec
set showmatch
set matchtime=1

" t: autowrap text using textwidth
" l: long lines are not broken in insert mode
" c: autowrap comments using textwidth, inserting leader
" r: insert comment leader after <CR>
" o: insert comment leader after o or O
set formatoptions-=t
set formatoptions+=lcro
set textwidth=80

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

" show our whitespace
" alternate character: Â»
"not a big fan of this; will keep just in case
"set listchars=tab:\|\ 
"set listchars=tab:\|Â,trail:Â
"set list

" complete to longest match, then list possibilities
set wildmode=longest,list

" turn off swap files
set noswapfile

" }}}
" {{{ colors
" tabe line colors
highlight TabLineFill ctermfg=DarkGray
highlight TabLine ctermfg=4 ctermbg=DarkGray cterm=bold
highlight TabLineSel ctermfg=7 cterm=none ctermbg=DarkGray

" number column colors
highlight LineNr cterm=none ctermbg=Black ctermfg=4

" fold colors
highlight Folded cterm=none ctermbg=Black ctermfg=4
highlight FoldColumn cterm=none ctermbg=Black ctermfg=4

" visual mode colors
highlight Visual ctermbg=7 ctermfg=4

" dictionary menu colors
highlight Pmenu ctermbg=7 ctermfg=0
highlight PmenuSel ctermbg=Yellow ctermfg=0

" diff colors
highlight DiffAdd cterm=none ctermbg=DarkGray
highlight DiffDelete cterm=none ctermbg=DarkGray
highlight DiffChange cterm=none ctermbg=none
highlight DiffText cterm=none ctermbg=DarkGray

" keep cursor column last so it overrides all others
highlight CursorColumn cterm=none ctermbg=Black
highlight CursorLine cterm=none ctermbg=Black

highlight Search cterm=none ctermbg=7 ctermfg=4

" make sure bold is disabled or your terminal will look like the vegas strip
set background=dark
" }}}
" {{{ filetype dependent
autocmd BufNewFile,BufRead *.html setlocal commentstring=<!--%s-->
" ruby commenstring
autocmd FileType ruby setlocal commentstring=#%s
" make help navigation easier
autocmd FileType help nnoremap <buffer> <CR> <C-]>
autocmd FileType help nnoremap <buffer> <BS> <C-T>
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
"netrw options {{{
let g:netrw_sort_sequence = '[\/]$,\.php,\.phtml,*,\.info$,\.swp$,\.bak$,\~$'
"}}}
"{{{taglist options
" set the names of flags
let tlist_php_settings = 'php;c:class;f:function;d:constant'
" close all folds except for current file
let Tlist_File_Fold_Auto_Close = 1
" make tlist pane active when opened
let Tlist_GainFocus_On_ToggleOpen = 1
" width of window
let Tlist_WinWidth = 40
" close tlist when a selection is made
let Tlist_Close_On_Select = 1
"}}}
"{{{html options
let html_use_css = 1
"}}}

" mappings
" {{{ general
let mapleader = "\\"
" easier move screen up/down
nmap <C-j> <C-e>
nmap <C-k> <C-y>
" turns off highlighting
nmap <Leader>/ :nohl<CR>
" search for highlighted text
vmap // y/<C-R>"<CR>
" keep block highlighted when indenting
vmap >> >gv
vmap << <gv
" fix a block of XML; inserts newlines, indents properly, folds by indent
nmap <Leader>fx :setlocal filetype=xml<CR>:%s/></>\r</g<CR>:1,$!xmllint --format -<CR>:setlocal foldmethod=indent<CR>
" comment/uncomment highlighted block
vmap <Leader>cc :s!^!//!<CR>
vmap <Leader>cu :s!^//!!<CR>
" open local projects list file
nmap <Leader>l :60vsplit ~/projects.list<CR>
" fix syntax highlighting
nmap <Leader>ss :syntax sync fromstart<CR>
" open local journal file
nmap <Leader>j :60vsplit ~/journal.log<CR>G
" toggle the tag list
nmap <Leader>tl :TlistToggle<CR>
" make arrow keys useful
" use them to swap between split windows
nmap <left> <C-W>h
nmap <right> <C-W>l
nmap <up> <C-W>k
nmap <down> <C-W>j
"}}}
" php {{{
" syntax check
nmap <Leader>ps :!php -l %<CR>
" run current script
nmap <Leader>pr :!php % \| less -F<CR>
" lookup keyword in function reference
nmap <Leader>ph :!php --rf <cword><CR>
" create test method
nmap <Leader>pt o<CR>/**<CR>@test<CR>/<CR>public function<TAB>
" phpdoc comments
nmap <Leader>cc o/**<CR>$Rev$<CR>$Date$<CR>$Id$<CR>$Author$<CR>$HeadURL$<CR><CR><CR><CR>@author Lucas Oman <lucas.oman@bookit.com><CR><BS>/<ESC>kkk$a 
nmap <Leader>cb o/**<CR><CR><CR>@author Lucas Oman <lucas.oman@bookit.com><CR>@param <CR>@return <CR>@example <CR><BS>/<ESC>kkkkkk$a 
nmap <Leader>cv o/**<CR><CR><CR>@var <CR><BS>/<ESC>kkk$a 
nmap <Leader>cp o/**<CR><CR><CR>@author Lucas Oman <me@lucasoman.com><CR>@param <CR>@return <CR>@example <CR><BS>/<ESC>kkkkkk$a 
"}}}
" svn {{{
" set svn keywords
nmap <Leader>sk :!svn propset svn:keywords "Rev Date Id Author HeadURL" %<CR>
nmap <Leader>sp :call SvnPushFile()<CR>
com! -nargs=1 Sstat :call SvnStatus("<args>")

" view status of given path
fun! SvnStatus(path)
	tabe
	setl buftype=nofile
	exe "r !svn st ".a:path
endfunction

" call script to copy file to appropriate location in htdocs
fun! SvnPushFile()
	let line = getline('.')
	let file = strpart(l:line,8)
	exe "!updatedev.php ".l:file
endfunction
"}}}
"f keys {{{
nmap <F2> :call ToggleColumns()<CR>
imap <F2> <C-o>:call ToggleColumns()<CR>
nmap <F3> :Nload<CR>
" <F4>
set pastetoggle=<F5>
" <F6>
nmap <F7> :!updatedev.php %:p<CR>
nmap <F8> :call WriteTrace()<CR>
nmap <F9> \ph
" <F10>
" <F11> don't use; terminal full-screen
" <F12>
" }}}
"{{{ list file
let g:listFile_ranks = ['=','1','2','3','4','5','!','o','-','?','x']
autocmd BufNewFile,BufRead *.list call MyListFileStuff()
fun! MyListFileStuff()
	nmap <buffer> ,! :Lmark !<CR>
	vmap <buffer> ,! :Lmark !<CR>
	nmap <buffer> ,tq :Ltag quick<CR>
	vmap <buffer> ,tq :Ltag quick<CR>
	nmap <buffer> ,sq :Lsearch tag quick<CR>
endfunction
"}}}

" minor helpful stuff
fun! ToggleColumns() "{{{
	"make it easy to remove line number column etc. for cross-terminal copy/paste
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
fun! WriteTrace() "{{{
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
"{{{ctags stuff
nmap <Leader>tf :call CtagsFind(expand('<cword>'))<CR>
com! -nargs=+ Tf :call CtagsFind("<args>")
" split window and search for tag
nmap <Leader>ts :exe('stj '.expand('<cword>'))<CR>

" open new tab and search for tag
fun! CtagsFind(keyword)
	tabe
	exe "tj ".a:keyword
endfunction
"}}}

" stand-alone components
"{{{ TAB-COMPLETE and SNIPPETS
" add new snippets as regex=>completion
" first match encountered is used
let s:snippets = {}
let s:snippets['^\s*if$'] = " () {\<CR>}\<ESC>k^f)i" 
let s:snippets['function$'] = " () {\<CR>}\<ESC>k^f(i" 
let s:snippets['^\s*class$'] = "  {\<CR>}\<ESC>kt{i"
let s:snippets['^\s*interface$'] = "  {\<CR>}\<ESC>kt{i"
let s:snippets['^\s*foreach$'] = " () {\<CR>}\<ESC>k^f)i" 
let s:snippets['^\s*while$'] = " () {\<CR>}\<ESC>k^f)i" 

" when tab is pressed:
" 1) checks snippets for matches, return match if there is one
" 2) if character behind cursor is whitespace, just return a tab
" 3) if word behind cursor contains a slash, try filename complete
" 4) otherwise, try to ctrl-p complete
fun! CleverTab()
	if col('.') > 1
		let beginning = strpart( getline('.'), 0, col('.')-1 )
		let words = split(l:beginning,' ')
		let thisWord = l:words[-1]

		for key in keys(s:snippets)
			if l:beginning =~ key
				return s:snippets[key]
			endif
		endfor
	else
		let beginning = ''
	endif

	if l:beginning == '' || l:beginning =~ '\s$'
		return "\<Tab>"
	elseif (l:thisWord =~ '/')
		return "\<C-X>\<C-F>"
	else
		"return "\<C-X>\<C-O>"
		return "\<C-P>"
	endif
endfunction
imap <Tab> <C-R>=CleverTab()<CR>
"}}}
"CODE GREP {{{
" grep for given string (second is case insensitive)
" simply a wrapper for vimgrep
" eg: :F /badxmlexception/ *.php lib
com! -nargs=+ F :call CommandFind("<args>")
fun! CommandFind(args)
	tabe
	let parts = split(a:args,' ')
	exe "vimgrep ".l:parts[0]." ".l:parts[1]." ".l:parts[2]."/**/*"
	exe "copen"
endfunction
"}}}
"{{{ TAB MGMT
" Some useful bits for managing tabs.
" Also changes format of tab line.
" Commands and shortcuts:
" \oc - open dir of current file in new tab
" H - navigate to tab to the left
" L - navigate to tab to the right
" C-l - move current tab left
" C-h - move current tab right
" gf - changes default behavior from opening file under cursor in current window to opening in new tab
nmap <Leader>oc :tabe %:h<CR>

" quicker aliases for navigating tabs
nmap H gT
nmap L gt
" move tab left or right
nmap <C-l> :call MoveTab(0)<CR>
nmap <C-h> :call MoveTab(-2)<CR>

" gf should use new tab, not current buffer
map gf :tabe <cfile><CR>

"tab line
fun! MyTabLine()
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

fun! MyTabLabel(n)
	let buflist = tabpagebuflist(a:n)
	let winnr = tabpagewinnr(a:n)
	let fullname = bufname(buflist[winnr - 1])
	" show a/b/c/filename.ext
	"let fullname = substitute(fullname,"(\w){1}\w*/","\1/","g")
	" show filename.ext
	let fullname = substitute(fullname,".*/","","")
	if getbufvar(buflist[winnr - 1],"&mod")
		let modified = "+"
	else
		let modified = " "
	endif
	return modified.fullname
endfunction

" Use the above tabe naming scheme
set tabline=%!MyTabLine()

"tab moving
fun! MoveTab(n)
	let which = tabpagenr()
	let which = which + a:n
	exe "tabm ".which
endfunction
"}}}
"{{{ MYSQL MODE
com! -nargs=0 Dbopen :call DbOpen()
fun! DbOpen()
	tabe MySQL
	setl filetype=mysql
	setl buftype=nofile
	nmap <buffer> <CR> :call DbExecute()<CR>
	vmap <buffer> <CR> :call DbExecuteV()<CR>
endfunction
fun! DbExecute()
	let query = getline('.')
	call DbExecuteQuery(l:query)
endfunction
fun! DbExecuteV() range
	let query = join(getline(a:firstline,a:lastline),' ')
	call DbExecuteQuery(l:query)
endfunction
fun! DbExecuteQuery(query)
	tabe
	setl buftype=nofile
	setfiletype mysqlresult
	let query = escape(shellescape(a:query),'%')
	let @z = "Query:\n".a:query."\n\nResult:"
	normal "zPG
	exe "r !mysql -u ".g:db_user." -h ".g:db_host." --password=".g:db_pass." -t -e ".l:query
	normal gg
endfunction
"}}}
