" Allows you to manage multiple session files for different projects.
" Use vim's :mksession [filename] command to create a session.
" Commands and shortcuts:
" :Nwhich - display name of currently used session file
" :Nload - load a session file
" :Ncreate <name> - create a new session with <name>. ".vim" extension is added automagically

com! -nargs=0 Nwhich :call WhichSession()
com! -nargs=0 Nload :call LoadSession()
com! -nargs=1 Ncreate :call CreateSession("<args>")

" localoptions has to be here:
" for some reason, new session loading code fails to set filetype of files in session
set sessionoptions=blank,tabpages,folds,localoptions

let s:sessionloaded = 0
let s:loadingsession = 0
let s:sessionfile = ''
let s:netrwsort = ''
autocmd BufRead *.vim call LoadSessionFinish()
autocmd VimLeave * call SaveSession()

" open current dir to select a session file
fun! LoadSession()
	" save current netrw sort sequence
	let s:netrwsort = g:netrw_sort_sequence
	" show sessions first, then dirs
	let g:netrw_sort_sequence = '\.vim$,[\/]$'
	let s:loadingsession = 1
	e .
endfunction

" we've selected a file, so load it
fun! LoadSessionFinish()
	if s:loadingsession == 1
		let s:loadingsession = 0
		let s:sessionloaded = 1
		" restore previous sort sequence setting
		let g:netrw_sort_sequence = s:netrwsort
		" save session filename for saving on exit
		let s:sessionfile = bufname('%')
		source %
	end
endfunction

" save the session (if one was loaded) when exiting
fun! SaveSession()
  if s:sessionloaded == 1
		" re-save session before exiting
    exe "mksession! ".s:sessionfile
  end
endfunction

" create a new session
fun! CreateSession(name)
	exe 'mksession! '.a:name.'.vim'
	let s:loadingsession = 0
	let s:sessionloaded = 1
	let s:sessionfile = a:name.'.vim'
endfunction

" print which session file is being used
fun! WhichSession()
	echo "Session: ".s:sessionfile
endfunction
