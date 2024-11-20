" ========================================================================================================== "
"                                __      __  _____   __  __   _____     _____                                "
"                                \ \    / / |_   _| |  \/  | |  __ \   / ____|                               "
"                                 \ \  / /    | |   | \  / | | |__) | | |                                    "
"                                  \ \/ /     | |   | |\/| | |  _  /  | |                                    "
"                                   \  /     _| |_  | |  | | | | \ \  | |____                                "
"                                    \/     |_____| |_|  |_| |_|  \_\  \_____|                               "
"                                                                                            by alterGNU     "
" ========================================================================================================== "
 
" ============================================================================================================
" CONFIGURATION
" ============================================================================================================
" =[ SOURCE ]=================================================================================================
" auto. re-source vimrc when buffer is saved(handy when testing new settings in vimrc file)
autocmd! bufwritepost $MYVIMRC source %
" if not in vimrc file then SAVE and SOURCE file(handy when writting vimscript function outside vimrc file)
function! g:SaveAndSourceFile()
    let l:filename = fnamemodify(expand('%'), ':t')
    if l:filename == "vimrc"
        echom "vimrc can't be source with <F5> (g:SourceFile) command"
    else
        silent! write 
        source %
        echom 'Sourced ' . l:filename
    endif
endfunction
map <silent> <F5> <Esc>:call g:SaveAndSourceFile()<Esc>

" =[ FILETYPE & INDENT ]======================================================================================
" Active filetype detection (load my ~/.vim/ftplugin/*.vim) & indent (load my ~/.vim/indent/*.vim)
filetype plugin indent on
autocmd BufNewFile,BufRead ${DOTPATH}/fcts/* set filetype=zsh " set filetype for functions in DOTPATH/fcts
" =[ LEADERKEY ]==============================================================================================
" Define [`] as leaderkey
let mapleader = "`"
" =[ SETTINGS ]===============================================================================================
" -[ BASICS ]-------------------------------------------------------------------------------------------------
set nocompatible                         | " Desable vi compatibility
set viminfo+=n~/.vim/viminfo             | " Change default location of viminfo file
set mouse=a                              | " Enable the use of the mouse in all mode ('a')
set scrolloff=5                          | " When scroll, keep cursor 5lines away of top/bottom
set belloff=all                          | " Desable all bell/sound
set clipboard=unnamedplus                | " Use clipboard as default buffer for cpy/past (cross-plat: all UNIX)
" -[ DISPLAY ]------------------------------------------------------------------------------------------------
set textwidth=110                        | " Default max lines width
set number 	                             | " Display the line numbering
set wrap                                 | " If line longer than windows, wrap text instead of horizontal scrolling
set linebreak                            | " If line longer than windows, prevent word from being split in two
" -[ INDENTATION ]--------------------------------------------------------------------------------------------
set autoindent                           | " Use the indent from the previous line
set smartindent                          | " Like autoindent but also recognizes some C syntax
" -[ TABULATION ]---------------------------------------------------------------------------------------------
set tabstop=4                            | " Specify the width of a tab character (8 by default)
set shiftwidth=4                         | " In normod, indenting with '>'insert 4spaces instead of one tabulation
set expandtab                            | " On pressing tab, insert 4 spaces
" -[ SEARCH ]-------------------------------------------------------------------------------------------------
set hlsearch                             | " Enable hightlighting matches ... 
set incsearch                            | " ... while typping (progressively/interactivelly)
set ignorecase                           | " Ignore case...
set smartcase                            | " ... unless we put write an upper-case lettre, then active case.

" ============================================================================================================
" MAPPING
" ============================================================================================================
" =[ NOHL ]===================================================================================================
" Remove HighLighting (handy after search)
noremap <c-n> :nohl<CR>
vnoremap <c-n> <c-c>:nohl<CR>
inoremap <c-n> <c-o>:nohl<CR>
 
" =[ TABULATIONS ]============================================================================================
" -[ OPEN NEW TAB ]-------------------------------------------------------------------------------------------
map te : tabe<Space>
" -[ MOVE ACTUAL TAB ORDER ]----------------------------------------------------------------------------------
map tm : tabm<Space>
" -[ OPEN IN VSPLIT MODE ]------------------------------------------------------------------------------------
map ts : vsplit<Space>
" -[ OPEN A NEW HELP TAB ]------------------------------------------------------------------------------------
map th : tab help<Space>

" =[ SAVE COMMAND ]===========================================================================================
" -[ FORCE SAVE ]---------------------------------------------------------------------------------------------
":w -> Always save (even if file was not modify)
"noremap <c-s> :write<CR>
"vnoremap <c-s> <c-c>:write<CR>
"inoremap <c-s> <c-o>:write<CR>
" -[ SAVE ONLY IF CHANGES ]-----------------------------------------------------------------------------------
" :u -> Save only if file was modified since last save
noremap <c-s> :update<CR>
vnoremap <c-s> <c-c>:update<CR>
inoremap <c-s> <c-o>:update<CR>

" =[ SEARCH&REPLACE ]=========================================================================================
" Search&replace globaly(entire file) and interactive(ask before replacing)
noremap ;; :%s:::gc<left><left><left><left>
" Search&replace only in selection and automatically(no Q? asks)
vnoremap ;; :s:::g<left><left><left>

" ============================================================================================================
" AUTOMATIONS
" ============================================================================================================
" =[  SWITCH CAPS<->ESCAP ]===================================================================================
"au VimEnter * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
"au VimLeave * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

" =[ DISPLAY TEXTWIDTH COLUMN ]===============================================================================
" Display a colored column where textwidth is (if no textwidth, default value=80)
" -[ FUNCTION ]-----------------------------------------------------------------------------------------------
function! s:SetColorColumnPerFile()
    let l:textaille = substitute(trim(execute(":set textwidth?")),"textwidth=","","")
    if l:textaille == 0
        setlocal colorcolumn=80
    else
        execute(":setlocal colorcolumn=".l:textaille)
    endif
endfunction
" -[ AUTOMATION GROUP ]---------------------------------------------------------------------------------------
augroup colorcolumn
    autocmd!
    autocmd BufEnter * call s:SetColorColumnPerFile()
augroup end

" ============================================================================================================
" PLUGINS
" ============================================================================================================
" =[ PLUGIN MANAGER ]=========================================================================================
" -[ NATIVE PLUGIN MANAGER (VIM8) ]---------------------------------------------------------------------------
" Since vim8.0, vim can nativaly manage plugin:
" - 1 . activate this feature by adding to your vimrc `packloadall`
" - 2 . create the directory `mkdir -p ~/.vim/pack/plugins/start`
" - 3 . clone any plugin in this directory, ex:`git clone "   https://github.com/morhetz/gruvbox.git ~/.vim/pack/plugins/start/gruvbox`

" -[ VIM-PLUG : ONE PLUG TO RULE THEM ALL ]-------------------------------------------------------------------
" auto-install vim-plug
if empty(glob('~/.vim/autoload/plug.vim'))
    echo "Installing VimPlug..."
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall
endif

call plug#begin()
Plug 'alexandregv/norminette-vim'    " Norminette checking
Plug 'itchyny/calendar.vim'          " Calendar for VimWiki
Plug 'morhetz/gruvbox'               " Theme & color retro groove
Plug 'mzlogin/vim-markdown-toc'      " Creation de TOC 
Plug 'scrooloose/nerdtree'           " File system explorer
Plug 'scrooloose/syntastic'          " Syntax checking
Plug 'vim-utils/vim-man'             " View man pages in vim
Plug 'vimwiki/vimwiki'               " Personnal Wiki
call plug#end()

" =[ NORMINETTE-VIM ]=========================================================================================
" Check norminette inside of vim using syntastic plugin
" -[ NORMINETTE-VIM CONFIGURATION ]---------------------------------------------------------------------------
let g:c_syntax_for_h = 1                                       " Support headers (.h)
" -[ SYNTASTIC CONFIGURATION FOR NORMINETTE-VIM ]-------------------------------------------------------------
let g:syntastic_c_checkers = ['norminette', 'cc'] |            " Enable norminette-vim (and gcc)
let g:syntastic_aggregate_errors = 1                           " Check all checker that apply (c + norminette) then regroup then as one 
let g:syntastic_c_norminette_exec = 'norminette'               " Set the path to norminette
let g:syntastic_c_include_dirs = ['include', '../include', '../../include', 'libft', '../libft/include', '../../libft/include']
let g:syntastic_c_norminette_args = '-R CheckTopCommentHeader' " Pass custom arguments to norminette (this one ignores 42header)
let g:syntastic_check_on_open = 1                              " Check errors when opening a file (disable to speed up startup time)
let g:syntastic_always_populate_loc_list = 1                   " Enable error list
let g:syntastic_auto_loc_list = 1                              " Automatically open error list
let g:syntastic_check_on_wq = 0                                " Skip check when closing

" =[ CALENDAR.VIM ]===========================================================================================
" -[ SETTING ]------------------------------------------------------------------------------------------------
source ~/.cache/calendar.vim/credentials.vim
let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
" -[ MAPPING ]------------------------------------------------------------------------------------------------
map <silent> <F4> <Esc>:Calendar<CR>

" =[ GRUVBOX ]================================================================================================
" -[ SETTING ]------------------------------------------------------------------------------------------------
set t_Co=256
set background=dark
colorscheme gruvbox
" -[ MAPPING ]------------------------------------------------------------------------------------------------
" =[ VIM-MARKDOWN-TOC ]=======================================================================================
" -[ SETTING ]------------------------------------------------------------------------------------------------
" -[ MAPPING ]------------------------------------------------------------------------------------------------
map <silent> <F3> <Esc>:GenTocGFM<CR>

" =[ NERD-TREE ]==============================================================================================
" -[ SETTING ]------------------------------------------------------------------------------------------------
" -[ MAPPING ]------------------------------------------------------------------------------------------------
nnoremap <c-t> :NERDTreeToggle<CR>
nnoremap <c-f> :NERDTreeFind<CR>

" =[ MAN-VIM ]================================================================================================
" -[ SETTING ]------------------------------------------------------------------------------------------------
" -[ MAPPING ]------------------------------------------------------------------------------------------------
noremap <leader>m <Plug>(Vman)
vnoremap <silent> <leader>m "vy:Vman <C-r>"<CR>
noremap <leader>M <Plug>(Tman)
vnoremap <silent> <leader>M "vy:Tman <C-r>"<CR>

" =[ VIMWIKI ]================================================================================================
" -[ SETTINGS ]-----------------------------------------------------------------------------------------------
" Force show extension in links
let g:vimwiki_markdown_link_ext = 1
" Treat all markdown files in my system as part of vimwiki
let g:vimwiki_global_ext = 0
" -[ WIKIS SETTINGS ]-----------------------------------------------------------------------------------------
" create a wiki entrie at <path> with common settings + <extra_settings>
fun! MyWiki(path, extra_settings)
    let l:dict_common_settings={}
    let l:dict_common_settings['path']=a:path          " Wiki's path
    let l:dict_common_settings['syntax']='markdown'    " Use markdown syntax
    let l:dict_common_settings['ext']='.md'            " Use .md extension
    let l:dict_common_settings['links_space_char']='_' " When create, replace space by underscore in filename
    return extend(l:dict_common_settings, a:extra_settings)
endfun
" dict of settings specific to a wiki that will be use as a blog using github.io feature
let s:github_blog_extra_settings={
			\ 'template_path': '~/Templates/',
            \ 'template_default': 'default',
            \ 'template_ext': '.tpl',
			\ 'path_html': '~/Projects/HUGO/',
			\ 'custom_wiki2html': '~/.vim/plugged/vimwiki_markdown/bin/vimwiki_markdown',
			\ 'html_filename_parameterization': 1}
" Mywikis
let g:vimwiki_list = [
            \MyWiki('~/Wiki', {}),
            \MyWiki('~/Notes', s:github_blog_extra_settings),
            \MyWiki('~/GPW', {'index': 'Home'})
			\]
" -[ MAPPING ]------------------------------------------------------------------------------------------------
noremap <Leader><CR> <plug>VimwikiVSplitLink
inoremap <Leader><CR> <plug>VimwikiVSplitLink
