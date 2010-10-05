if exists("b:current_syntax")
	finish
endif

syn keyword svnLogKeyword Changed paths from line lines
syn match svnLogDelim '|'
syn match svnLogDelim '----\+'

syn match svnLogRevision 'r\d\+'
syn match svnLogRevision ':\d\{3,}'

syn match svnLogDate '\d\{4}-\d\{2}-\d\{2}[^)]*)'

syn match svnLogFile '/[a-zA-Z_\-\./0-9 ]\+'
syn match svnLogType '^   [MAD]'

let b:current_syntax = "svnlog"

hi def link svnLogKeyword Comment
hi def link svnLogDelim Identifier
hi def link svnLogRevision String
hi def link svnLogDate String
hi def link svnLogFile Special
hi def link svnLogType Statement
