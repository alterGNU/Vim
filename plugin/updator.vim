" ============================================================================================================
" UPDATOR : set of fum,cmd and au that update things...
" ============================================================================================================
"
" Fun:
"   - s:UpdateTicketsUpdate(aV) : call VimwikiGenerateLinks a:aV TODO
" Cmd:
"   - Update aV         : call s:UpdateTicketsUpdate(aV)
" Augroup Updator:
"   - if filetype not zsh or vim       ➡️  InsertEmojis
"   - if filetype not text, zsh or vim ➡️  InsertMatches
" ============================================================================================================

" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
" -[ UPDATEINDEX ]--------------------------------------------------------------------------------------------
fun! UpdateTicketsUpdate()
    let l:foldername = expand("%:p:h:t")
    let l:link_header_default_value = g:vimwiki_global_vars['links_header']
    let g:vimwiki_global_vars['links_header'] = 'List of '.foldername.' tickets'
    let l:link_header_level_default_value = g:vimwiki_global_vars['links_header_level']
    let g:vimwiki_global_vars['links_header_level'] = 2
    " If shell allow motif-extension an alternative is :VimwikiGenerateLinks Tickets/<...>/{*,!(index)}.md
    exe ":VimwikiGenerateLinks Tickets/".l:foldername."/*" | exe ":g/- \\[.*\\](index.md)/d"
    let g:vimwiki_global_vars['links_header'] = l:link_header_default_value
    let g:vimwiki_global_vars['links_header_level'] = l:link_header_level_default_value
    update
endfun

" ============================================================================================================
" COMMANDES
" ============================================================================================================
command! Update call UpdateTicketsUpdate()
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
    autocmd BufEnter,BufWritePre,FileWritePre */Tickets/*/index.md call UpdateTicketsUpdate()
augroup END
