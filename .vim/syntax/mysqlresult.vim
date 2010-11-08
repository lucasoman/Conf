if exists("b:current_syntax")
	finish
endif

syn match mysqlHeader '^Query:'
syn match mysqlHeader '^Result:'
syn match mysqlResultTable '^+\([-]\++\)\+'
syn match mysqlResultTable '^| '
syn match mysqlResultTable ' | '
syn match mysqlResultTable ' |$'

let b:current_syntax = "mysql_result"

hi def mysqlResultTable ctermfg=4 cterm=NONE
hi def mysqlHeader ctermfg=1 cterm=NONE
