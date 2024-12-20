" ============================================================================================================
" CSCOPE SETTINGS FOR VIM           
" ============================================================================================================

" ============================================================================================================
" cscope configuation and mapping for vim
"
" The cscope commands are :
"   - 's' symbol    : Find all references to the token under cursor
"   - 'g' global    : Find global definition(s) of the token under cursor
"   - 'c' calls     : Find all calls to the function name under cursor
"   - 't' text      : Find all instances of the text under cursor
"   - 'e' egrep     : Egrep search for the word under cursor
"   - 'f' file      : Open the filename under cursor
"   - 'i' includes  : Find files that include the filename under cursor
"   - 'd' called    : Find functions that function under cursor calls
"
" GOOD-TO-KNOW:
"   - Configuration loaded only if vim was config. with the `--enable-scope` option when compiled.
"   - Largely inspired by Jason Duell's configuration file
" ============================================================================================================

if has("cscope")
    " SETTINGS
    set cscopetag                  " use both cscope and ctag for 'ctrl-]', ':ta', and 'vim -t'
    set csto=0                     " check cscope for definition of a symbol before checking ctags: set to 1 if you want the reverse search order.
    " DATA-BASE
    if filereadable("cscope.out")  " add any cscope database in current directory
        cs add cscope.out  
    elseif $CSCOPE_DB != ""      " else add the database pointed to by environment variable 
        cs add $CSCOPE_DB
    endif
    set cscopeverbose              " show msg when any other cscope db added
    " 'CTRL-\' MAPPING : CURRENT WINDOWS
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    " 'CTRL-space' MAPPING: HORIZONTAL SPLIT
    nmap <C-@>s :scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>g :scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>c :scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>t :scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>e :scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@>d :scs find d <C-R>=expand("<cword>")<CR><CR>
    " 'CTRL-space-CTRL-space' MAPPING: VERTICAL SPLIT
    nmap <C-@><C-@>s :vert scs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>g :vert scs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>c :vert scs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>t :vert scs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>e :vert scs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-@><C-@>f :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-@><C-@>i :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-@><C-@>d :vert scs find d <C-R>=expand("<cword>")<CR><CR>
endif
