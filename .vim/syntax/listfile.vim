if exists("b:current_syntax")
	finish
endif

syn match listFilePri '^\s*[0-9] .*$'
syn match listFileNonStart '^\s*- .*$'
syn match listFileProg '^\s*= .*$'
syn match listFileUnk '^\s*o .*$'
"syn match listFileDone '^\s*x .*$'

let b:current_syntax = "listfile"

hi def link listFileNonStart Identifier
hi def link listFilePri Special
hi def link listFileProg Statement
hi def link listFileUnk Type
"hi def link listFileDone Normal

