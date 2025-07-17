" ============================================================================================================
" TITLEATOR : Formatting titles
" ============================================================================================================
 
"............................................................................................................"
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
" - [X] ADD:    Fun. that detect title pattern
" - [X] ADD:    Delete mecanism (delete already formatted title line, restaure to normal line)
" - [X] ADD:    Update mecanism (on a already formatted title line, switch to new lvl)
" - [X] ADD:    Add number at the end of title (usefull on filetype=header)
" - [X] ADD:    Fun. that count the number of fun. in a file (C syntax)
" - [X] ADD:    Title 3 in header.c file should add the number of file found at the end 
" - [ ] ADD:    Comment section could be usefull
" - [ ] ADD:    Instead of title1, could convert to (ASCI_art + Signature = header)

" TODO FIXME:
" - [X] FIX:    simplify code (getter and setter fun. not usefull, let use not needed)
" - [X] FIX:    Title: should not insert an empty line before sep+title+sep+empty
" - [X] FIX:    Sub_Title: When a line already start with commentstring and is not completly in title format.
" - [X] FIX:    Sub_Title: Should respect line indentation.
" - [X] FIX:    Detect subtitle should work with title1 too.
" - [X] FIX:    Delete subtitle should work with title1 too.
" - [X] FIX:    Count_Fun_C_Syntax(): findfile() match wront pattern first, build path to limit search scope
" - [ ] FIX:    Title: should work with multiple selected lines.
".............................................................................................................

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
    + 0
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
        let l:formated_line = repeat(" ", l:indent).l:comstr." -[ ".l:title_name." ]"
    else
        let l:formated_line = l:comstr." -[ ".l:title_name." ]"
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

" -[ Is_a_title() ]-------------------------------------------------------------------------------------------
" Return the lvl of subtitle detected in the line under the cursor:
"  - 0  : Line is not a title
"  - 1  : Line is lvl 1 title
"  - 2  : Line is lvl 2 title
"  - 3  : Line is lvl 3 title
function! Is_a_title()
    let l:lnum = line(".")
    let l:line = trim(getline(l:lnum))
    let l:comstr = Get_commentstring()
    if &filetype ==? "Markdown" || &filetype ==? "VimWiki"
        let l:lvl_count = 0
        if match(l:line, '^#') == 0
            while (l:line[l:lvl_count] == '#')
                let l:lvl_count += 1
            endwhile
            "echom "line is a lvl ".l:lvl_count." markdown subtitle"
        else
            "echom "line is NOT a markdown subtitle"
        endif
        return l:lvl_count
    else
        if match(l:line, '^'.l:comstr.' =\[.*\]=*') == 0
            "echom "line is a lvl 2 subtitle"
            return 2
        elseif match(l:line, '^'.l:comstr.' -\[.*\]-*') == 0
            "echom "line is a lvl 3 subtitle"
            return 3
        elseif match(trim(getline(l:lnum - 1)), '^'.l:comstr.' =*$') == 0 && match(l:line, '^'.l:comstr.'.*$') == 0 && match(trim(getline(l:lnum + 1)), '^'.l:comstr.' =*$') == 0
            "echom "line is a lvl 1 subtitle"
            return 1
        else
            "echom "line is not a subtitle"
            return 0
        endif
    endif
endfunction

" -[ Delete_Title_Pattern() ]---------------------------------------------------------------------------------
" Remove subtitle pattern when detected
function! Delete_Title_Pattern()
    let l:lnum = line(".")
    let l:indent = indent(l:lnum)
    let l:line = trim(getline(l:lnum))
    let l:comstr = Get_commentstring()
    let l:title_lvl = Is_a_title()
    if title_lvl > 0
        if &filetype ==? "Markdown" || &filetype ==? "VimWiki"
            if l:indent > 0
                let l:cleaned_line = repeat(" ", l:indent).trim(trim(l:line, "#"))
            else
                let l:cleaned_line = trim(trim(l:line, "#"))
            endif
            call setline(l:lnum, l:cleaned_line)
        else
            if title_lvl > 1
                if l:indent > 0
                    let l:cleaned_line = repeat(" ", l:indent).trim(trim(l:line, l:comstr."-= []0987654321"))
                else
                    let l:cleaned_line = trim(trim(l:line, l:comstr."-= []0987654321"))
                endif
                call setline(l:lnum, l:cleaned_line)
            else
                if l:indent > 0
                    let l:cleaned_line = repeat(" ", l:indent).trim(trim(l:line, l:comstr))
                else
                    let l:cleaned_line = trim(trim(l:line, l:comstr))
                endif
                call setline(l:lnum - 1, l:cleaned_line)
                if match(trim(getline(l:lnum + 2)), '^$') == 0
                    let stop = l:lnum + 2
                else
                    let stop = l:lnum + 1
                endif
                execute l:lnum . ',' . l:stop . 'delete'
                -1
            endif
        endif
    endif
endfunction

" -[ Count_Fun_C_Syntax() ]-----------------------------------------------------------------------------------
" Count the number of function in a file (exclude prototype ending with ;)
" If <filename> not readable, build a recursive path pattern l:search_paths to limit research scope
function! Count_Fun_C_Syntax(filename)
    let l:filepath = a:filename
    if !filereadable(l:filepath)
        let l:parent_folder = expand('%:p:h')
        let l:paths_lst = [l:parent_folder, l:parent_folder.'/../src', l:parent_folder.'/../']
        let l:search_paths = join(map(l:paths_lst, {_, val -> val . '/**'}), ',')
        let l:filepath = findfile(l:filepath, l:search_paths)
        if empty(l:filepath) || !filereadable(l:filepath)
            echohl WarningMsg | echom "ERROR: Count_Fun_C_Syntax('".a:filename."'): No readable file found!" | echohl None
            return -1
        endif
    endif
    try
        let l:lines = readfile(l:filepath)
    catch
        echohl WarningMsg | echom "ERROR: Count_Fun_C_Syntax('".l:filepath."'): Cannot be readed!" | echohl None
        return -1
    endtry
    let l:count = 0
    let l:max = len(l:lines) - 1
    for lnum in range(0, l:max - 1)
        let l:line = l:lines[lnum]
        let l:next_line = l:lines[lnum + 1]
        if l:line =~ '^\s*[a-zA-Z_][a-zA-Z0-9_ \t\*]*\s\+\**[a-zA-Z_][a-zA-Z0-9_]*\s*(.*)\s*$' && l:line !~ ';' && l:next_line =~ '^\s*{'
            let l:count += 1
        endif
    endfor
    echohl Comment|echon "Count_Fun_C_Syntax("|echohl Foldcolumn|echon "'".l:filepath."'"|echohl Comment|echon ")=["|echohl Underlined|echon l:count|echohl Comment|echon "]"|echohl None
    return l:count
endfunction

" =[ META-FUNCTION ]==========================================================================================
function! Title(lvl)
    if &filetype ==? "Markdown" || &filetype ==? "VimWiki"
        call Insert_Markdown_Titles(a:lvl)
    else
        let l:actual_lvl = Is_a_title()
        if a:lvl == 0
            call Delete_Title_Pattern()
        elseif a:lvl == 1 && l:actual_lvl != 1
            call Delete_Title_Pattern()
            call Insert_Title("=")
        elseif a:lvl == 2 && l:actual_lvl != 2
            call Delete_Title_Pattern()
            call Insert_SubTitle("=")
        elseif a:lvl == 3
            call Delete_Title_Pattern()
            if expand('%:e') == "h"
                let l:num_fun = Count_Fun_C_Syntax(getline(line(".")))
                if l:num_fun >= 0
                    call Insert_Third_Title_With_Count(l:num_fun)
                else
                    call Insert_SubTitle("-")
                endif
            else
                call Insert_SubTitle("-")
            endif
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
