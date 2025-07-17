" ============================================================================================================
" HEADER42 : INSERT 42 HEADER AND INCLUDE PROJECT HEADER
" ============================================================================================================
 
" =[ VAR ]====================================================================================================
let s:asciiart = [
            \"        :::      ::::::::",
            \"      :+:      :+:    :+:",
            \"    +:+ +:+         +:+  ",
            \"  +#+  +:+       +#+     ",
            \"+#+#+#+#+#+   +#+        ",
            \"     #+#    #+#          ",
            \"    ###   ########.fr    "
            \]

let s:start		= '/*'
let s:end		= '*/'
let s:fill		= '*'
let s:length	= 80
let s:margin	= 5

let s:types		= {
            \'\.c$\|\.h$\|\.cc$\|\.hh$\|\.cpp$\|\.hpp$\|\.tpp$\|\.php\|\.glsl':
            \['/*', '*/', '*'],
            \'\.htm$\|\.html$\|\.xml$':
            \['<!--', '-->', '*'],
            \'\.js$':
            \['//', '//', '*'],
            \'\.tex$':
            \['%', '%', '*'],
            \'\.ml$\|\.mli$\|\.mll$\|\.mly$':
            \['(*', '*)', '*'],
            \'\.vim$\|\vimrc$':
            \['"', '"', '*'],
            \'\.el$\|\emacs$':
            \[';', ';', '*'],
            \'\.f90$\|\.f95$\|\.f03$\|\.f$\|\.for$':
            \['!', '!', '/']
            \}

" =[ UTILS FUNCTIONS ]========================================================================================
" -[ s:filename() ]-------------------------------------------------------------------------------------------
" Get filename
function! s:filename()
    let l:filename = expand("%:t")
    if strlen(l:filename) == 0
        let l:filename = "< new >"
    endif
    return l:filename
endfunction

" -[ s:date() ]-----------------------------------------------------------------------------------------------
" Get date in YY/MM/DD hh:mm:ss format
function! s:date()
    return strftime("%Y/%m/%d %H:%M:%S")
endfunction

" =[ SPECIFIC FUNCTIONS ]=====================================================================================
" -[ s:filetype() ]-------------------------------------------------------------------------------------------
" Select commentstring chars (start,fill,end) depeneding on filetype (not the real one, just filename ext)
function! s:filetype()
    let l:f = s:filename()
    let s:start	= '#'
    let s:end	= '#'
    let s:fill	= '*'
    for type in keys(s:types)
        if l:f =~ type
            let s:start	= s:types[type][0]
            let s:end	= s:types[type][1]
            let s:fill	= s:types[type][2]
        endif
    endfor
endfunction

" -[ s:ascii(n) ]---------------------------------------------------------------------------------------------
" Get ascii 42 <n>'th line
function! s:ascii(n)
    return s:asciiart[a:n - 3]
endfunction

" -[ s:user() ]-----------------------------------------------------------------------------------------------
" Get user name (here force to be my 42 username so header created at home have the rigth name in it)
function! s:user()
    "let l:user = $USER
    let l:user = "lagrondi"
    if exists('g:hdr42user')
        let l:user = g:hdr42user
    endif
    if strlen(l:user) == 0
        let l:user = "marvin"
    endif
    return l:user
endfunction

" -[ s:mail() ]-----------------------------------------------------------------------------------------------
" Get user mail
function! s:mail()
    let l:mail = $MAIL
    if exists('g:hdr42mail')
        let l:mail = g:hdr42mail
    endif
    if strlen(l:mail) == 0
        let l:mail = "marvin@42.fr"
    endif
    return l:mail
endfunction

" -[ s:textline(left, right) ]--------------------------------------------------------------------------------
" Line builder
function! s:textline(left, right)
    let l:left = strpart(a:left, 0, s:length - s:margin * 3 - strlen(a:right) + 1)
    return s:start . repeat(' ', s:margin - strlen(s:start)) . l:left . repeat(' ', s:length - s:margin * 2 - strlen(l:left) - strlen(a:right)) . a:right . repeat(' ', s:margin - strlen(s:end)) . s:end
endfunction

" -[ s:line(n) ]----------------------------------------------------------------------------------------------
" Line insertor: append <n> line, works in reverse.
function! s:line(n)
    if a:n == 1 || a:n == 11 " top and bottom line
        return s:start . ' ' . repeat(s:fill, s:length - strlen(s:start) - strlen(s:end) - 2) . ' ' . s:end
    elseif a:n == 2 || a:n == 10 " blank line
        return s:textline('', '')
    elseif a:n == 3 || a:n == 5 || a:n == 7 " empty with ascii
        return s:textline('', s:ascii(a:n))
    elseif a:n == 4 " filename
        return s:textline(s:filename(), s:ascii(a:n))
    elseif a:n == 6 " author
        return s:textline("By: " . s:user() . " <" . s:mail() . ">", s:ascii(a:n))
    elseif a:n == 8 " created
        return s:textline("Created: " . s:date() . " by " . s:user(), s:ascii(a:n))
    elseif a:n == 9 " updated
        return s:textline("Updated: " . s:date() . " by " . s:user(), s:ascii(a:n))
    endif
endfunction

" -[ s:update() ]---------------------------------------------------------------------------------------------
" Check if line 9 is the 42Header Update members, then update just the update date and return 0
" If file do not have a 42Header, return 1
function! s:update()
    call s:filetype()
    if getline(9) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "
        if &mod
            call setline(9, s:line(9))
        endif
        call setline(4, s:line(4))
        return 0
    endif
    return 1
endfunction

" -[ s:insert() ]---------------------------------------------------------------------------------------------
" Insert 42Header line by line
function! s:insert()
    let l:line = 11
    call append(0, "")                  | " empty line after header
    while l:line > 0                    | " loop over lines
        call append(0, s:line(l:line))
        let l:line = l:line - 1
    endwhile
endfunction

" -[ s:is_a_c_file() ]----------------------------------------------------------------------------------------
" Check if the actual file is a c or cpp file (C HEADER FILE DO NOT COUNT, that's why filetype not use)
function! s:is_a_c_file()
    let l:ext = expand('%:e')
    if empty(l:ext)
        echohl WarningMsg | echom "ERROR: s:is_a_c_file(): expand() returns empty!" | echohl None
        return 0
    endif
    if l:ext == "c" || l:ext == "cpp"
        return 1
    endif
    return 0
endfunction

" -[ s:no_header_included() ]---------------------------------------------------------------------------------
" Check if the actual file already have a header included
function! s:header_included()
    for lnum in range(1, line('$'))
        let line_text = getline(lnum)
        if line_text =~# '^#include\s\+"[^"]\+"'
            return lnum
        endif
    endfor
    return 0
endfunction

" -[ s:search_project_header() ]------------------------------------------------------------------------------
" Get the project header filename, if mod == 0 skip the choose menu mecanic if multiple header found, 1 enable
function! s:search_project_c_header(mod)
    let l:parent_folder = expand('%:p:h')
    let l:paths_lst = [l:parent_folder, l:parent_folder.'/..', l:parent_folder.'/../..']
    let l:globs = []
    for dir in l:paths_lst
        call add(l:globs, dir . '/**/*.h')
        call add(l:globs, dir . '/**/*.hpp')
    endfor
    let l:headers_found = []
    for pattern in l:globs
        let l:matches = glob(pattern, 0, 1)
        let l:headers_found += l:matches
    endfor
    if empty(l:headers_found)
        echohl WarningMsg | echom "ERROR: Search_project_c_header(): DID NOT FOUND ANY HEADER FILE!" | echohl None
        return -1
    elseif len(l:headers_found) > 1 && a:mod
        let l:menu = ['Choose a header file:']
        for i in range(len(l:headers_found))
            call add(l:menu, printf('%2d. %s', i + 1, fnamemodify(l:headers_found[i], ':~:.')))
        endfor
        let l:choice = inputlist(l:menu)
        if l:choice <= 0 || l:choice > len(l:headers_found)
            echo "YOU CHOOSE POORLY"
            return -1
        endif
        let l:chosen_header = l:headers_found[l:choice - 1]
        "echo fnamemodify(l:chosen_header, ":t")
        return fnamemodify(l:chosen_header, ":t")
    else
        "echo fnamemodify(l:headers_found[0], ":t")
        return fnamemodify(l:headers_found[0], ":t")
    endif
endfunction

" =[ META-FUNCTION ]==========================================================================================
" If header already inserted, update the update date, else insert the header
" NOTES:
"  - Use g:header42_interactive_menu global variable defined in $VIMRC file
"    - g:header42_interactive_menu == 'on' --> if multiple header file found, display a choosing menu
"    - g:header42_interactive_menu == 'off' --> if multiple header file found, pic the first one by default
function! s:header42()
    if s:update()
        call s:insert()
    endif
    if s:is_a_c_file() && !s:header_included()
        if exists('g:header42_interactive_menu') && g:header42_interactive_menu ==# 'on'
            call append(12, ['#include "'.s:search_project_c_header(1).'"', ""]) 
        else
            call append(12, ['#include "'.s:search_project_c_header(0).'"', ""]) 
        endif
        13
    endif
endfunction

" ============================================================================================================
" BIND COMMAND AND SHORTCUT
" ============================================================================================================
command! Header42 call s:header42()
nmap <f1> <esc>:Header42<CR>
autocmd BufWritePre * call s:update()
