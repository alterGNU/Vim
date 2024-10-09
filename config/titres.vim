" ========================================================================================
" MISE EN FORME DES TITRES 
" ========================================================================================
" Ensemble de fonction permettant la mise en forme des titres de scripts en fonction de
" leurs langages (prend en compte la textwidth ainsi que le commentstring via filetype)

" UTILISATION:
" Il s'utilise en mode Normal, une fois le nom du titre saisi sans avoir mis le
" commentstring, placer le cuseur sur la ligne puis faire [²]+[x] pour mettre en forme 
" un titre x... pour l'instant x est compris entre 1 et 3...

" TODO :
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

" ========================================================================================
" DÉCLARATION DES FUNCTIONS
" ========================================================================================
 
" =[ FONCTIONS UTILITAIRES ]==============================================================
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

" =[ FONCTIONS TITRES DÉCORATIVES ]======================================================
" -[ FONCTION TITRE 1 ]-------------------------------------------------------------------
" Encadre le texte mis en majuscule par deux lignes de symbole '=' + espace : frises!
function! Titre1(len,com,sym) 
    s/.*/\U&/ | "Met tous les caractères de la ligne en majuscule
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

" -[ FONCTION TITRE 2  ]------------------------------------------------------------------
function! Titre2(len,com,sym)
    s/.*/\U&/ | " substitue toute la ligne par des majuscules
    let l:lnum = line(".")
    let l:text1 = getline(".")
    let l:texte2 = a:com." ".a:sym."[ ".text1." ]"
    let l:text = len(texte2)
    let l:reste = (a:len - len(texte2))
    let l:final = texte2 . repeat(a:sym, reste)
    let l:final2 = setline(lnum,final)
endfunction

" =[ FONCTIONS TITRES DÉCORATIVES ]======================================================
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
" ========================================================================================
" MAPPING
" ========================================================================================
" On ne les mets pas ds vimrc car pas dit que ce .vim soit toujours là sur les != devices
command! Titre1 call Titre1(Textwidth(),DefCom(),"=")
command! Titre2 call Titre2(Textwidth(),DefCom(),"=")
command! Titre3 call Titre2(Textwidth(),DefCom(),"-")

nmap <silent> <Leader>1 :Titre1<CR>
nmap <silent> <Leader>2 :Titre2<CR>
nmap <silent> <Leader>3 :Titre3<CR>

" Pour l'exception des fichiers.md, voir ~/.vim/ftplugin/markdown_mappings.vim instead of:
" autocmd FileType {filetype_names} nnoremap <........>
