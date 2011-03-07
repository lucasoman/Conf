" Syntax file for List File plugin
" by Lucas Oman <me@lucasoman.com>

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "listfile"

syn match listFilePriOne '^\s*1 [^\[\]{}:]*'
syn match listFilePriTwo '^\s*2 [^\[\]{}:]*'
syn match listFilePriRest '^\s*[3-9] [^\[\]{}:]*'
syn match listFileNonStart '^\s*- [^\[\]{}:]*'
syn match listFileProg '^\s*= [^\[\]{}:]*'
syn match listFileUnk '^\s*o [^\[\]{}:]*'
syn match listFileDone '^\s*x [^\[\]{}:]*'
syn match listFileDate '\[[^\]]\+\]'
syn match listFileDate '{[^}]\+}'
syn match listFileTag ':\S\+:'

hi def listFileNonStart ctermfg=NONE cterm=bold
hi def listFilePriOne ctermfg=1 cterm=bold
hi def listFilePriTwo ctermfg=3
hi def listFilePriRest ctermfg=3 cterm=bold
hi def listFileProg ctermfg=2 cterm=bold
hi def listFileUnk ctermfg=4 cterm=bold
hi def listFileDone ctermfg=4 cterm=NONE
hi def listFileDate ctermfg=4 cterm=NONE
hi def listFileTag ctermbg=4 ctermfg=0
