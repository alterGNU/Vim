" ============================================================================================================
" CPP FILES CONFIGURATION
" ============================================================================================================
 
" =[ SETTINGS ]===============================================================================================
" -[ COMMENTS ]-----------------------------------------------------------------------------------------------
setlocal commentstring=//\ %s  | " The comment string characters

" -[ TABULATION ]---------------------------------------------------------------------------------------------
setlocal tabstop=4             | " Specify the width of a tab character (8 by default)
"setlocal shiftwidth=4         | " In normod, indenting with '>'insert 4spaces instead of one tabulation⚠️  42 NORMINETTE ERROR⚠️
"setlocal expandtab            | " On pressing tab, insert 4 spaces ⚠️  42 NORMINETTE ERROR⚠️

" -[ LINES WIDTH ]--------------------------------------------------------------------------------------------
setlocal textwidth=80          | " Line width
setlocal wrap                  | " If line longer than windows, wrap text instead of horizontal scrolling
setlocal linebreak             | " If line longer than windows, prevent word from being split in two

" =[ MAPPINGS ]===============================================================================================
