" Creates and maintains text files of nested lists.
" File must end in '.list'.
" Use >> and << to adjust depth of item.
" Includes nested folding for lists. Use standard vim fold shortcuts (e.g.: zo, zc).
" Commands and shortcuts:
" CREATING
" ,n - create new item
" <tab> - (insert or normal) create new item
" ,s - create sub item
" ,u - create super item
" MARKING
" ,p - mark item with '=' (in progress)
" ,x - mark item with 'x' (completed)
" ,o - mark item with 'o'
" ,? - mark item with '?'
" ,- - mark item with '-' (default, incomplete)
" ,N - set priority as N, where N is 1-5
" ET CETERA
" ,t - add/update timestamp on item
" ,r - (visual line) sort highlighted items
" ,r - (normal) sort entire file
" :Lsearch mark <mark> - find all items with <mark> (e.g.: =, 1, -, etc.) using location list
"          tag <tag> - find all items with <tag> using location list
" :Lcreate <name> - create new list file with <name> (".list" is added automagically)
" :Ltag <tag> - add tag to current line

" should items have timestamps by default?
if (!exists("g:listFile_timestamp"))
	let listFile_timestamp = 0
endif
" how far should each level indent?
if (!exists("g:listFile_indent"))
	let listFile_indent = 4
endif
if (!exists("g:listFile_ranks"))
	let listFile_ranks = {
		\'1':0,
		\'2':1,
		\'3':2,
		\'4':3,
		\'5':4,
		\'=':5,
		\'o':6,
		\'-':7,
		\'?':8,
		\'x':9
	\}
endif

autocmd BufNewFile,BufRead *.list call ListFile()

" 'install' list features
fun! ListFile()
	setfiletype listfile
	" set some options
	setl foldmethod=expr
	setl foldexpr=ListFoldLevel(v:lnum)
	exe 'setlocal shiftwidth='.g:listFile_indent
	exe 'setlocal tabstop='.g:listFile_indent
	setl foldtext=ListFoldLine(v:foldstart)
	setl noshowmatch
	setl cindent
	" map all the magic shortcuts
	if (g:listFile_timestamp == 1)
		" add [n]ew item below current
		nmap <buffer> ,n o-  [<ESC>:call ListTimestamp()<CR><ESC>^la
		" add new sub item below current
		nmap <buffer> ,s o-  [<ESC>:call ListTimestamp()<CR><ESC>>>^la
		" add new super item below current
		nmap <buffer> ,u o-  [<ESC>:call ListTimestamp()<CR><ESC><<^la
	else
		" add [n]ew item below current
		nmap <buffer> ,n o- 
		" add new sub item below current
		nmap <buffer> ,s o- <ESC>>>^la
		" add new super item below current
		nmap <buffer> ,u o- <ESC><<^la
	endif
	imap <buffer> <tab> <ESC>,n
	nmap <buffer> <tab> ,n
	" mark item as [x]
	nmap <buffer> ,x :call ListSetMark('x')<CR>
	vmap <buffer> ,x :call ListSetMarkV('x')<CR>
	" mark item as [-]
	nmap <buffer> ,- :call ListSetMark('-')<CR>
	vmap <buffer> ,- :call ListSetMarkV('\-')<CR>
	" mark item as = (in [p]rogress)
	nmap <buffer> ,p :call ListSetMark('=')<CR>
	vmap <buffer> ,p :call ListSetMarkV('=')<CR>
	" mark item as [o]
	nmap <buffer> ,o :call ListSetMark('o')<CR>
	vmap <buffer> ,o :call ListSetMarkV('o')<CR>
	" mark item as [?]
	nmap <buffer> ,? :call ListSetMark('?')<CR>
	vmap <buffer> ,? :call ListSetMarkV('?')<CR>
	" mark item with a priority
	nmap <buffer> ,1 :call ListSetMark('1')<CR>
	nmap <buffer> ,2 :call ListSetMark('2')<CR>
	nmap <buffer> ,3 :call ListSetMark('3')<CR>
	nmap <buffer> ,4 :call ListSetMark('4')<CR>
	nmap <buffer> ,5 :call ListSetMark('5')<CR>
	" add/update [t]imestamp
	nmap <buffer> ,t mz$a [<ESC>:call ListTimestamp()<CR><ESC>`z
	vmap <buffer> ,r :call ListSortV()<CR>
	nmap <buffer> ,r :call ListSortAll()<CR>

	com! -nargs=+ -buffer Lsearch :call ListSearch("<args>")
	com! -nargs=1 -buffer Lcreate :call ListCreate("<args>")
	com! -nargs=+ -buffer -range Ltag :call ListTagV(<count>,"<args>")
endfunction

fun! ListSearch(args)
	let args = split(a:args,' ')
	let type = remove(l:args,0)
	echo l:args
	let string = join(l:args,' ')
	if (l:type == 'mark')
		call ListMark(l:string)
	elseif (l:type == 'tag')
		call ListTagSearch(l:string)
	endif
endfunction

fun! ListCreate(name)
	exe 'tabe '.a:name.'.list'
	let @z = '- '
	normal "zP
endfunction

" fix properly formatted timestamp
fun! ListTimestamp()
	let addStamp = 0
	if getline('.') =~ '\['
		let addStamp = 1
	endif
	normal ^t[d$
	if l:addStamp
		call ListTimestampString()
		normal "zp
	endif
endfunction

" return actual timestamp string
fun! ListTimestampString()
	let @z = ' ['.strftime('%y-%m-%d %H:%M').']'
endfunction


"""
""" FOLDING
"""

" return fold line format
fun! ListFoldLine(linenum)
	let s:count = 1
	let s:spaces = ''
	while s:count <= &shiftwidth
		let s:spaces = s:spaces.' '
		let s:count = s:count + 1
	endwhile
	return substitute(getline(a:linenum),"\t",s:spaces,'g')
endfunction

" foldexpr function
fun! ListFoldLevel(linenum)
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
		s:pnumtabs = ListGetDepth(s:pline)
		if s:level < s:pnumtabs
		" if this is higher level than prev, start a new fold
			let s:prefix = '>'
		endif
	endif
	return s:prefix.s:level
endfunction


"""
""" SORTING
"""

" sort highlighted lines
fun! ListSortV() range
	call ListSort(a:firstline,a:lastline)
endfunction

" sort whole file
fun! ListSortAll()
	call ListSort(1,line('$'))
endfunction

" sort range of lines
fun! ListSort(start,end)
	let s:sortLines = getline(a:start,a:end)
	let s:sortDict = {0:[]}

	let s:curDepth = ListGetDepth(s:sortLines[0])
	let s:stack = [0]
	let s:index = 0

	while (ListDictFormat())
	endwhile
	let sorted = ListCompileSorted(0)
	call setline(a:start,l:sorted)
endfunction

" construct sorted list string from sortDict
fun! ListCompileSorted(index)
	let list = get(s:sortDict,a:index,[])
	if (!empty(l:list))
		let sorted = sort(s:sortDict[a:index],"ListSortFunction")
		let allSorted = []
		for item in l:sorted
			call add(l:allSorted,item[1])
			let sublist = ListCompileSorted(item[0])
			if (sublist != [])
				call extend(l:allSorted,l:sublist)
			endif 
		endfor
		return l:allSorted
	else
		return []
	endif
endfunction

" put entire list in dictionary format for sorting
" this cannot be recursive, as any list file with lines > maxfuncdepth could be sorted
fun! ListDictFormat()
	if (len(s:sortLines) == 0)
		return 0
	endif
	let line = remove(s:sortLines,0)
	let s:prevDepth = s:curDepth
	let s:curDepth = ListGetDepth(l:line)
	if (s:curDepth > s:prevDepth) " we're starting a sub-list
		" add prev index to stack because it's now a parent
		call add(s:stack,s:index)
		" create empty list in dictionary
		let s:sortDict[s:index] = []
	elseif (s:curDepth < s:prevDepth) " we're ending sub-list(s)
		" pop the stack as many times as necessary
		let diff = s:prevDepth - s:curDepth
		while (l:diff > 0)
			call remove(s:stack,len(s:stack)-1)
			let diff = l:diff - 1
		endwhile
	endif
	call add(s:sortDict[s:stack[len(s:stack) - 1]],[s:index + 1,l:line])
	let s:index = s:index + 1
	return 1
endfunction

" sorting function
fun! ListSortFunction(one,two)
	let onerank = ListGetItemRank(a:one[1])
	let tworank = ListGetItemRank(a:two[1])
	return l:onerank == l:tworank ? 0 : l:onerank < l:tworank ? -1 : 1
endfunction

" get rank for the given line based on user-defined mark ranks
fun! ListGetItemRank(line)
	let matches = matchlist(a:line,'^\s*\(\S\+\)')
	let mark = l:matches[1]
	return g:listFile_ranks[l:mark]
endfunction

" get the depth of the given line
fun! ListGetDepth(line)
	return match(a:line,"[^\t]",0)
endfunction


"""
""" MARKING
"""

" mark current line
fun! ListSetMark(mark)
	let @z = a:mark
	normal mz^dl"zP
	call ListTimestamp()
	normal `z
endfunction

" mark lines in visual mode
fun! ListSetMarkV(mark)
	exe "'<,'>s/^\\(\\s\\+\\)./\\1".a:mark."/"
	nohl
endfunction

" find items with mark
fun! ListMark(mark)
	exe 'lvimgrep /^\s*'.a:mark.'/ %'
	lopen
endfunction


"""
""" TAGGING
"""

" tag a line
fun! ListTag(line,tags)
	let line = getline(a:line)
	let tags = ' :'.join(split(a:tags,' '),': :').':'
	let pos = match(l:line,'\[')
	if (l:pos == -1)
		let line = l:line.l:tags
	else
		let line = strpart(l:line,0,l:pos-1).l:tags.strpart(l:line,l:pos-1)
	endif
	call setline(a:line,l:line)
endfunction

" tag lines in visual mode
fun! ListTagV(end,tags) range
	let start = line('.')
	let end = a:end > 0 ? a:end : line('.')
	while (l:start <= l:end)
		call ListTag(l:start,a:tags)
		let start = l:start + 1
	endwhile
endfunction

" search for tag
fun! ListTagSearch(string)
	exe 'lvimgrep /:'.a:string.':/ %'
	lopen
endfunction
