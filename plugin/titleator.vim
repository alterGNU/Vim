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
" - [X] FIX:    Title 1 should not insert an empty line before sep+title+sep+empty
" - [ ] FIX:    Title 1 should work with multiple selected lines.
" - [ ] FIX:    When a line already start with commentstring and is not completly in title format.

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
    echo comm
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
    let l:lnum = line(".")
    let l:text1 = getline(".")
    let l:texte2 = Get_commentstring()." ".a:sym."[ ".text1." ]"
    let l:text = len(texte2)
    let l:reste = &textwidth - len(texte2)
    let l:final = texte2 . repeat(a:sym, reste)
    let l:final2 = setline(lnum,final)
endfunction
 
" -[ Insert_Markdown_Titles(D) ]------------------------------------------------------------------------------
" Format the actual line into a N lvl markdown title
function! Insert_Markdown_Titles(lvl) 
    let l:lnum = line(".")
    " Récupére la ligne courante sans les anciennes balises de titres markdown (#)
    let l:li0 = substitute(getline("."),'^#\{1,\}\ ',"","")
    if a:D==0
        let l:li1 = repeat("#", a:lvl).li0
    else
        let l:li1 = repeat("#", a:lvl)." ".li0
    endif
    let l:li2 = setline (lnum ,li1)
endfunction
 
" ============================================================================================================
" MAPPING
" ============================================================================================================
" TODO : Regroup in 1 insert_title_function that detect filetype and then apply Insert_Title if not Markdown
command! Title1 call Insert_Title("=")
command! Title2 call Insert_SubTitle("=")
command! Title3 call Insert_SubTitle("-")

nmap <silent> <Leader>1 :Title1<CR>
nmap <silent> <Leader>2 :Title2<CR>
nmap <silent> <Leader>3 :Title3<CR>
