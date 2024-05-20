" ========================================================================================
" SETTINGS
" ========================================================================================
setlocal textwidth=120
setlocal nowrap
setlocal commentstring=#%s
" =[ TAB ET LIMITES DU TEXTE ]============================================================
set expandtab             | " Remplace la tabulation par des espaces
set tabstop=4  	          | " remplace la tabulation par 4 espaces
set shiftwidth=4          | " elimine le bud d'indentation 8espaces...
 
" ========================================================================================
" MAPPINGS
" ========================================================================================

" =[ MD_TITLES ]==========================================================================
" Permet de mettre en forme les titres mardown 
" -[ MODE NORMAL ET VISUEL ]--------------------------------------------------------------
map <buffer> <Leader><Leader> :call Markdown_Titles(0)<CR>
map <buffer> <Leader>1 :call Markdown_Titles(1)<CR>
map <buffer> <Leader>2 :call Markdown_Titles(2)<CR>
map <buffer> <Leader>3 :call Markdown_Titles(3)<CR>
map <buffer> <Leader>4 :call Markdown_Titles(4)<CR>
map <buffer> <Leader>5 :call Markdown_Titles(5)<CR>
map <buffer> <Leader>6 :call Markdown_Titles(6)<CR>
map <buffer> <Leader>7 :call Markdown_Titles(7)<CR>
map <buffer> <Leader>8 :call Markdown_Titles(8)<CR>
map <buffer> <Leader>9 :call Markdown_Titles(9)<CR>
