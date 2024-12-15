" ============================================================================================================
" CUSTOMFTDETECTOR.vim : Overwrite default filetype detector
" ============================================================================================================

augroup Cmds_to_bash
    autocmd!
    autocmd BufRead,BufNewFile cmds/**/* if index(['conf',''], &filetype) > -1 | setfiletype sh | endif
augroup END

