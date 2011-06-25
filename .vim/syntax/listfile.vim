" Syntax file for List File plugin
" by Lucas Oman <me@lucasoman.com>

if exists("b:current_syntax")
	finish
endif

let b:current_syntax = "listfile"

syn match listFilePriOne '^\s*1 .*' contains=listFileDate,listFileTag
syn match listFilePriTwo '^\s*2 .*' contains=listFileDate,listFileTag
syn match listFilePriRest '^\s*[3-9] .*' contains=listFileDate,listFileTag
syn match listFileNonStart '^\s*- .*' contains=listFileDate,listFileTag
syn match listFileProg '^\s*= .*' contains=listFileDate,listFileTag
syn match listFileUnk '^\s*o .*' contains=listFileDate,listFileTag
syn match listFileDone '^\s*x .*' contains=listFileDate,listFileTag
syn match listFileDate '\[[^\]]\+\]' contained
syn match listFileDate '{[^}]\+}' contained
syn match listFileTag ':\S\+:' contained

hi def listFileNonStart ctermfg=NONE cterm=bold
hi def listFilePriOne ctermfg=1 cterm=bold
hi def listFilePriTwo ctermfg=3
hi def listFilePriRest ctermfg=3 cterm=bold
hi def listFileProg ctermfg=2 cterm=bold
hi def listFileUnk ctermfg=4 cterm=bold
hi def listFileDone ctermfg=4 cterm=NONE
hi def listFileDate ctermfg=4 cterm=NONE
hi def listFileTag ctermbg=4 ctermfg=0
