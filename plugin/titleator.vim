" ============================================================================================================
" TITLEATOR : FORMATTING TITLES
" ============================================================================================================
 
" DEF:
" Collections of functions for formatting titles.
" Works for different languages, it uses their filetype:
"  - Takes the 'textwidth' variable into account to determine the length of the separator/line/title.
"  - Takes the 'commentstring' variable into account to determine the char to use to comment out the line.

" USAGE:
" In normal mode, place the cursor on the line to transform into a title, then press [²]+[x] to transform it.
" (x ∈ {0..4} corresponds to the title level)

" NOTES:
" - Markdown filtype format is specific and has it own title functions (no separator, just [#]*)
" - Title 1 rewritte the line in UPPERCASE

" TODO ADD:
" - [X] UPDATE: text and com. in english
" - [ ] ADD:    Fun. that detect title pattern
" - [ ] ADD:    Delete mecanism (delete already formatted title line, restaure to normal line)
" - [ ] ADD:    Update mecanism (on a already formatted title line, switch to new lvl)
" - [ ] ADD:    Add number at the end of title (usefull on filetype=header)
" - [ ] ADD:    Instead of title1, could convert to (ASCI_art + Signature = header)

" TODO FIXME:
" - [X] FIX:    simplify code (getter and setter fun. not usefull, let use not needed)
" - [X] FIX:    Title: should not insert an empty line before sep+title+sep+empty
" - [X] FIX:    Sub_Title: When a line already start with commentstring and is not completly in title format.
" - [X] FIX:    Sub_Title: Should respect line indentation.
" - [ ] FIX:    Title: should work with multiple selected lines.

" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
 
" =[ UTILS FUNCTIONS ]========================================================================================
" -[ Get_commentstring() ]------------------------------------------------------------------------------------
" Get the comment symbol for this filetype
function! Get_commentstring()
    let l:rcmd = execute(":set commentstring?")
    let l:inter = substitute(rcmd,"commentstring=","","")
    let l:comm = trim(substitute(inter,"%s","",""))
    return comm
endfunction

" =[ TITLES FUNCTIONS ]=======================================================================================
" -[ Insert_Title(sym) ]--------------------------------------------------------------------------------------
" Format the actual line into title format
function! Insert_Title(sym) 
    s/.*/\U&/                                                   | " Set all char in line to uppercase
    let l:com = Get_commentstring()
    let l:lnum = line(".")                                      | " Get the line number (where the cursor is)
    let l:ligne = getline(".")
    let l:nbr = &textwidth - (len(com) + 1)
    call setline(lnum, com." ".repeat(a:sym, nbr))              | " Replace lnum line by 
    call append(lnum, [com ." ".ligne, com ." ".repeat(a:sym, nbr), " "])
    + 3
endfunction
" -[ Insert_SubTitle(sym) ]-----------------------------------------------------------------------------------
" Format the actual line into subtitle format
function! Insert_SubTitle(sym)
    let l:comstr = Get_commentstring()                          | " Get comment string char
    let l:lnum = line(".")                                      | " Get line under cursor number
    let l:indent = indent(l:lnum)                               | " Get line under cursor indentation
    let l:raw = getline(".")                                    | " Get line under cursor
    let l:title_name = trim(l:raw, l:comstr)                    | " Remove starting comment string char
    let l:title_name = trim(l:title_name)                       | " Remove starting and ending spaces
    if l:indent > 0
        let l:formated_line = repeat(" ", l:indent).l:comstr." ".a:sym."[ ".l:title_name." ]"
    else
        let l:formated_line = l:comstr." ".a:sym."[ ".l:title_name." ]"
    endif
    call setline(l:lnum, formated_line . repeat(a:sym, &textwidth - len(formated_line)))
endfunction

" -[ Insert_SubTitle_With_Count(sym, nb) ]--------------------------------------------------------------------
" Format the actual line into subtitle format, adding the <nb> at the end
function! Insert_Third_Title_With_Count(nb)
    let l:comstr = Get_commentstring()                          | " Get comment string char
    let l:lnum = line(".")                                      | " Get line under cursor number
    let l:indent = indent(l:lnum)                               | " Get line under cursor indentation
    let l:raw = getline(".")                                    | " Get line under cursor
    let l:title_name = trim(l:raw, l:comstr)                    | " Remove starting comment string char
    let l:title_name = trim(l:title_name)                       | " Remove starting and ending spaces
    if l:indent > 0
        let l:formated_line = repeat(" ", l:indent).l:comstr." ".a:sym."[ ".l:title_name." ]"
    else
        let l:formated_line = l:comstr." ".a:sym."[ ".l:title_name." ]"
    endif
    call setline(line("."), formated_line . repeat("-", &textwidth - len(formated_line) - 2) . " ". a:nb)
endfunction
 
" -[ Insert_Markdown_Titles(D) ]------------------------------------------------------------------------------
" Format the actual line into markdown title format
function! Insert_Markdown_Titles(lvl) 
    let l:lnum = line(".")
    let l:li0 = substitute(getline("."),'^#\{1,\}\ ',"","")    | " Get the actual line, without old starting #
    if a:lvl == 0
        let l:li1 = repeat("#", a:lvl).li0
    else
        let l:li1 = repeat("#", a:lvl)." ".li0
    endif
    let l:li2 = setline (lnum ,li1)
endfunction

" =[ META-FUNCTION ]==========================================================================================
function! Title(lvl)
    if &filetype ==? "Markdown" || &filetype ==? "VimWiki"
        call Insert_Markdown_Titles(a:lvl)
    else
        if a:lvl == 1
            call Insert_Title("=")
        elseif a:lvl == 2
            call Insert_SubTitle("=")
        else
            call Insert_SubTitle("-")
        endif
    endif
endfunction

" ============================================================================================================
" MAPPING
" ============================================================================================================
nmap <silent> <Leader>0 :call Title(0)<CR>
nmap <silent> <Leader>1 :call Title(1)<CR>
nmap <silent> <Leader>2 :call Title(2)<CR>
nmap <silent> <Leader>3 :call Title(3)<CR>
nmap <silent> <Leader>4 :call Title(4)<CR>
nmap <silent> <Leader>5 :call Title(5)<CR>
nmap <silent> <Leader>6 :call Title(6)<CR>
nmap <silent> <Leader>7 :call Title(7)<CR>
nmap <silent> <Leader>8 :call Title(8)<CR>
nmap <silent> <Leader>9 :call Title(9)<CR>
