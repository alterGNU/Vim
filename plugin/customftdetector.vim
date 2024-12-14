" ============================================================================================================
" CUSTOMFTDETECTOR.vim : Overwrite default filetype detector
" ============================================================================================================

augroup Cmds_to_bash
    autocmd!
    autocmd BufRead,BufNewFile cmds/**/* if &filetype ==# 'conf' | setfiletype sh | endif
augroup END

