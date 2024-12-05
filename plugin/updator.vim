" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    updator.vim                                        :+:      :+:    :+:    "
"                                                     +:+ +:+         +:+      "
"    By: lagrondi <marvin@42.fr>                    +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2024/12/04 13:48:54 by lagrondi          #+#    #+#              "
"    Updated: 2024/12/05 12:52:22 by lagrondi         ###   ########.fr        "
"                                                                              "
" **************************************************************************** "

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
    if exists("*")
    endif
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
    " Update diary index
    autocmd BufEnter */diary/diary.md :VimwikiDiaryGenerateLinks
    " Update How_to/
    "autocmd BufEnter How_to/index.md call s:Plugin#Updator#UpdateIndex
augroup END
 
