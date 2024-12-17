" ============================================================================================================
" UPDATOR : set of fum,cmd and au that update things...
" ============================================================================================================
"
" Fun:
"   - s:UpdateIndex(aV) : call VimwikiGenerateLinks a:aV TODO
" Cmd:
"   - Update aV         : call s:UpdateIndex(aV)
" Augroup Updator:
"   - if filetype not zsh or vim       ➡️  InsertEmojis
"   - if filetype not text, zsh or vim ➡️  InsertMatches
" ============================================================================================================

" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
" -[ UPDATEINDEX ]--------------------------------------------------------------------------------------------
fun! s:UpdateIndex(argV)
    call VimwikiGenerateLinks(a:argv)
endfun

" ============================================================================================================
" COMMANDES
" ============================================================================================================
command! -nargs=1 Update call s:UpdateIndex(<f-args>)
" ============================================================================================================
" AUGROUP
" ============================================================================================================
augroup Updator
	autocmd!
    " When vimwiki file update, replace :text_emoji: by emoji's icone
    autocmd BufWritePre,FileWritePre * if index(['vim','zsh'], &filetype) < 0 | exe ":silent! InsertEmojis" | endif
    " When vimwiki file update, replace :text_emoji: by emoji's icone
    autocmd BufWritePre,FileWritePre * if index(['vim','zsh','text'], &filetype) < 0 | exe ":silent! InsertMatches" | endif
    " Update Wiki/diarydiary.me
    autocmd BufEnter,BufWritePre,FileWritePre */diary/diary.md execute "VimwikiDiaryGenerateLinks" | update
    " Update Wiki/Tickets/../index.md : Insert automatically the link to the files present in the Ticket folder (except index.md)
    autocmd BufEnter,BufWritePre,FileWritePre */Tickets/*/index.md exe join([":VimwikiGenerateLinks Tickets/",expand("%:p:h:t"),"/[^i]*.md"],"") | update
augroup END
