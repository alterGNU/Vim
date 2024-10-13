" ========================================================================================
" BASIC SETUP
" ========================================================================================
" -[ DÉSACTIVER LA COMPATIBILITÉ AVEC VI ]----------------------------------------------
set nocompatible

" -[ "ACTIVER GESTION DES PLUGINS NATIVE DE VIM8 ]----------------------------------------
packloadall

" -[ MODIFICATIONS DU VIMRC ACTIVES À LA SAUVEGARDE DU $MYVIMRC ]------------------------
autocmd! bufwritepost $MYVIMRC source % 

" -[ RACC. SAVE MANUELLE DE LA PAGE ACTUELLE => SOURCE $MYVIMRC ]-------------------------
function! ReloadVimrc()
	silent! source $MYVIMRC
	silent! PlugInstall
	silent! PlugUpdate
	silent! PlugClean
endfunction
map <silent> <F5> <Esc>:call ReloadVimrc()<CR>

" -[ MODIFICATION DE L'EMPLACEMENT PAR DÉFAUT DU VIMINFO ]-------------------------------
set viminfo+=n~/.vim/viminfo

" -[ DÉFINITION DE <LEADER> ]------------------------------------------------------------
let mapleader = "`"

" -[ ACTIVATION DES EXTENSIONS DU VIMRC DANS LE DOSSIER ~/.VIM/CONFIG/ ]------------------
runtime! config/**/*.vim

" -[ ACTIVATION DE LA SOURIS ]------------------------------------------------------------
set mouse=a

" ========================================================================================
" OPTIONNALS SETTINGS
" ========================================================================================

" =[ INDENTATION ]========================================================================
set autoindent            | " Préserve l'indentation de la ligne précédente
set smartindent           | " Petit plus...

" =[  AFFICHAGE ]=========================================================================
set title             	  | " Affiche le titre des fenêtres et terminaux en bas à gauche
set number 	          | " Affiche le numéro des lignes
set ruler                 | " Affiche barre bas à droite la position du curseur
set wrap	          | " Lorsque la ligne est trop longue, l'affiche en dessous

" =[ BEEP/ALERTE ]========================================================================
set belloff=all           | " Désactive toutes les alertes sonnores et visuelles

" =[ DIFFSPLIT EN VERTICAL (DEFAUT HORIZONTAL...PAS PRATIQUE) ]===========================
set diffopt=vertical      | " Permet comparaison cote à cote des fichiers

" =[ EMPLACEMENT DU CURSEUR LORS DU SCROLL ]==============================================
set scrolloff=5           | " Garde toujours le curseur à 5lignes du bord de la fenêtre

" =[ COLORATION ]=========================================================================
syntax enable             | " Activation de la coloration syntaxique

" =[ LIMITATION DE LARGEUR DU TEXTE ]=====================================================
set textwidth=080          | " Par defaut, indépendemment du filetype, largeur max = 99!

" =[ RECHERCHES ET SURLIGNAGES DANS LE TEXTE ]============================================
set incsearch             | " Active la recherche et surlignage pendant la saisie du texte
set hlsearch              | " Active le surlignage des correspondance   
set ignorecase            | " Permet d'ignorer la case...
set smartcase             | " ... mais si on met une maj dans la recherche la prend en compte

" ========================================================================================
" GENERAL MAPPINGS
" ========================================================================================
 
" =[ TABULATION ]=========================================================================
map th : tab help<Space>  | " Ouvre dans un nouvel onglet une page d'aide
map tm : tabm<Space>      | " Décalle vers la droite + et vers la gauche - l'onglet actuel
map ts : vsplit<Space>    | " Ouvre dans onglet actuel, avec separation vertical, un fichier existant
map te : tabe<Space>      | " Ouvre dans un nouvel onglet un fichier existant

" =[ :SAVE ]==============================================================================
noremap <c-s> :write<CR>
vnoremap <c-s> <c-c>:write<CR>
inoremap <c-s> <c-o>:write<CR>

" =[ :NOHL : CTRL+N PERMET D'ARRÊTER LE SURLIGNAGE ACTIF  ]===============================
noremap <c-n> :nohl<CR>
vnoremap <c-n> <c-c>:nohl<CR>
inoremap <c-n> <c-o>:nohl<CR>

"" =[ :SORT : '²'+T PERMET DE TRIER L'ENSEMBLE DES LIGNES SELECTIONNÉES ]==================
"vnoremap <leader>t :sort<CR>
"vnoremap <leader>T :sort!<CR>

" =[ SEARCH&REPLACE ]=====================================================================
noremap ;; :%s:::gc<left><left><left><left>
vnoremap ;; :s:::g<left><left><left>

" ========================================================================================
" FILETYPE CONFIGURATION
" ========================================================================================
" Active filetype detection + Active loading ftplugin/*.vim + Active loadinf indent files
filetype plugin indent on

" =[ C FILES ]============================================================================
autocmd FileType c setlocal commentstring=//\ %s

" -[ SWITCH CAPS<->ESCAP ]----------------------------------------------------------------
"au VimEnter * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
"au VimLeave * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

" ========================================================================================
" CONFIGURATION PLUGINS
" ========================================================================================
" auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    echo "Installing VimPlug..."
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin()
Plug 'alexandregv/norminette-vim' | " Norminette checking
Plug 'itchyny/calendar.vim'       | " Calendar for VimWiki
Plug 'morhetz/gruvbox'            | " Theme & color retro groove
Plug 'mzlogin/vim-markdown-toc'   | " Creation de TOC 
Plug 'scrooloose/nerdtree'        | " File system explorer
Plug 'scrooloose/syntastic'       | " Syntax checking
Plug 'vim-utils/vim-man'          | " View man pages in vim
Plug 'vimwiki/vimwiki'            | " Personnal Wiki
call plug#end()

" =[ NORMINETTE-VIM ]=====================================================================
" Enable norminette-vim (and gcc)
let g:syntastic_c_checkers = ['norminette', 'cc']
let g:syntastic_aggregate_errors = 1
" Set the path to norminette (do no set if using norminette of 42 mac)
let g:syntastic_c_norminette_exec = 'norminette'
" Support headers (.h)
let g:c_syntax_for_h = 1
let g:syntastic_c_include_dirs = ['include', '../include', '../../include', 'libft', '../libft/include', '../../libft/include']
" Pass custom arguments to norminette (this one ignores 42header)
let g:syntastic_c_norminette_args = '-R CheckTopCommentHeader'
" Check errors when opening a file (disable to speed up startup time)
let g:syntastic_check_on_open = 1
" Enable error list
let g:syntastic_always_populate_loc_list = 1
" Automatically open error list
let g:syntastic_auto_loc_list = 1
" Skip check when closing
let g:syntastic_check_on_wq = 0

" =[ CALENDAR.VIM ]=============================================================
source ~/.cache/calendar.vim/credentials.vim
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
map <silent> <F4> <Esc>:Calendar<CR>

" =[ GRUVBOX ]============================================================================
set t_Co=256
set background=dark
colorscheme gruvbox
" -[ FONCTION AFFICHANT LA COLONE LIMITE QUAND ELLE EXISTE ]------------------------------
" Si textwidth est déclarée, accorde colorcolumn avec sa valeur
" Sinon met la limite à 80 (pour 79)
function! SetColorColumnPerFile()
    "Récupération de la valeur de textwidth dans var-locale:textaille
    let l:textaille = substitute(trim(execute(":set textwidth?")),"textwidth=","","")
    if l:textaille == 0
        setlocal colorcolumn=80
    else
        execute(":setlocal colorcolumn=".l:textaille)
    endif
endfunction
"Lancement automatique à chaque chargement
augroup colorcolumn
    autocmd!
    autocmd BufEnter * call SetColorColumnPerFile()
augroup end

" =[ VIM-MARKDOWN-TOC ]===================================================================
map <silent> <F3> <Esc>:GenTocGFM<CR>

" =[ NERD-TREE ]==========================================================================
nnoremap <c-t> :NERDTreeToggle<CR>
nnoremap <c-f> :NERDTreeFind<CR>

" =[ MAN-VIM ]============================================================================
map <leader>m <Plug>(Vman)
map <leader>M <Plug>(Man)

" =[ VIMWIKI ]============================================================================
" Use Markdwon syntax to my folder vimwiki
"let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': 'md'}]
let g:vimwiki_list = [
			\{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': 'md'}, 
			\{'path': '~/migration/Notes/WikiNotes_13_02_2022', 'syntax': 'markdown', 'ext': 'md'}, 
			\{'path': '~/migration/Notes/WikiNotes_09_06_2020', 'syntax': 'markdown', 'ext': 'md'}, 
			\{'path': '~/migration/Notes/WikiNotes_24_09_2018', 'syntax': 'markdown', 'ext': 'md'}, 
			\{'path': '~/migration/Notes/WikiNotes_30_04_2018', 'syntax': 'markdown', 'ext': 'md'},
			\{'path': '~/migration/Notes/Notes_2018', 'syntax': 'markdown', 'ext': 'md'}
			\]
" Treat all markdown files in my system as part of vimwiki
let g:vimwiki_global_ext = 0
