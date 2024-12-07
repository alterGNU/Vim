" ============================================================================================================
" Update command
" ============================================================================================================
"
" Functions, autogroup and mapping that update page depending on their specifics(filetype, name, location ...)
"
" Commands:
"   - `:InsertMatches` = every '{{<match>}} occurence will be replace by their value
"       - Time      : yes, YES, yesterday, day, DAY, today, now, tom, TOM, tomorrow
"       - File      : file.name, file.NAME, file.path, file.ext, folder.name, filepath
"       - Special   : how_to.title, fix_it.title
"
" TODO :
" ============================================================================================================

" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
" -[ UPDATOR ]------------------------------------------------------------------------------------------------
" Fun that insert matches from `{{...}}` and `:...:` pattern, then update (save only if changes occured)
fun! g:Updator()
    echo "TODO"
endfun

" -[ UPDATEINDEX ]--------------------------------------------------------------------------------------------
fun! s:UpdateIndex(argV)
    call VimwikiGenerateLinks(a:argv)
endfun

" ============================================================================================================
" COMMANDES
" ============================================================================================================
command! Update call g:Updator()
command! -nargs=1 Update call s:UpdateIndex(<f-args>)
" ============================================================================================================
" AUGROUP
" ============================================================================================================
augroup Plugin_Updator
	autocmd!
    " When file update, replace templator matches pattern {{...}} by their value
    autocmd BufWritePre,FileWritePre * if &ft !=# 'vim' | execute "InsertMatches" | endif
    " When vimwiki file update, replace :text_emoji: by emoji's icone
	autocmd FileType vimwiki autocmd BufWritePre,FileWritePre <buffer> :silent! %s/:\([^: ]\+\):/\=get(vimwiki#emoji#get_dic(), submatch(1), submatch(0))/g
    " Update diary index
    autocmd BufEnter */diary/diary.md execute "VimwikiDiaryGenerateLinks" | update
    " Update How_to/
    "autocmd BufEnter How_to/index.md call s:Plugin#Updator#UpdateIndex
augroup END
 
