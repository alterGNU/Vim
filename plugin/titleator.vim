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

" TODO:
" - [X] : UPDATE: text and com. in english
" - [ ] : Fct: Insertion titre0 (ASCI_art + Signature)
"       -> `inoremap <F2> <C-R>=expand('%:p:h')<CR>`
" - [ ] : Si la ligne commence déjà par le commentstring, ne pas le prendre en compte
"       -> `s/^\(#\)\{1,\}\ //` permet rem tout '# ' '## ' '#### ' !
"   - [ ] : Fct: detection ligne comme commentaire/mise en forme (!=.md)
"
" - [ ] : Like *.md files, mapp to <leader><leader> fct annulant mise en page!
"   - [ ] : Fct: suppression de la mise en forme sur la ligne (=!.md)
"   - [ ] : Cmd: suppression de la mise en forme sur la page (!=.md)
"

" FIXME:
" - [ ] : Le mapping en mode insert ne semble pas marcher (markdown)

 
" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
 
" =[ UTILS FUNCTIONS ]========================================================================================
" -[ FONCTION RETOURNANT LA LARGEUR MAXIMAL DU TEXTE ]------------------------------------
" Retourne la valeur de textwidth : taille maximal du text autorisée
function! Textwidth()
    let l:rcmd = trim(execute(":set textwidth?"))
    let l:taille = substitute(rcmd,"textwidth=","","")
    return l:taille
endfunction

" -[ FONCTION DETECTANT LE SYMBOLE DE COMMENTAIRE ]---------------------------------------
" retourne le symbole commentaire(commentstring)
function! DefCom()
    let l:rcmd = execute(":set commentstring?")
    let l:inter = substitute(rcmd,"commentstring=","","")
    let l:comm = trim(substitute(inter,"%s","",""))
    echo comm
    return comm
endfunction

" =[ TITLES FUNCTIONS ]=======================================================================================
" -[ FONCTION TITRE 1 ]-------------------------------------------------------------------
" Encadre le texte mis en majuscule par deux lignes de symbole '=' + espace : frises!
function! Titre1(len,com,sym) 
    s/.*/\U&/
    let l:lnum = line(".")
    let l:ligne = getline(".")
    let l:li0 = setline (lnum ," " )
    let l:nbr = a:len - (len(a:com) + 1)
    let l:li1 = append ( lnum , a:com ." ".repeat(a:sym, nbr))
    let l:li2 = append ( lnum , a:com ." ".ligne)
    let l:li3 = append ( lnum , a:com ." ".repeat(a:sym, nbr))
    let l:li4 = append ( lnum + 3 ," " )
    + 4
endfunction
 
" =[ FONCTION Markdown_Titles ]===========================================================
" S'appelle avec un argument D correspondant au nombre de '#' à insérer au début de phrase
function! Markdown_Titles(D) 
    let l:lnum = line(".") | " Récupère le N° de ligne où se trouve le curseur
    " Récupére la ligne courante sans les anciennes balises de titres markdown (#)
    let l:li0 = substitute(getline("."),'^#\{1,\}\ ',"","")
    if a:D==0
        let l:li1 = repeat("#", a:D).li0
    else
        let l:li1 = repeat("#", a:D)." ".li0
    endif
    let l:li2 = setline (lnum ,li1) | " Remplace la N°Ligne par ligne1
endfunction
 
" ============================================================================================================
" MAPPING
" ============================================================================================================
command! Titre1 call Titre1(Textwidth(),DefCom(),"=")
command! Titre2 call Titre2(Textwidth(),DefCom(),"=")
command! Titre3 call Titre2(Textwidth(),DefCom(),"-")

nmap <silent> <Leader>1 :Titre1<CR>
nmap <silent> <Leader>2 :Titre2<CR>
nmap <silent> <Leader>3 :Titre3<CR>
