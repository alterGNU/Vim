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
" =[ ENV-VAR ]================================================================================================
let $DOTPATH=expand($DOTPATH)
let $VIMPATH=expand($DOTPATH) . '/vim' " Use by plugin/templator.vim
let $MYREALVIMRC=resolve($MYVIMRC)     " Use by autocmd below to id the real vimrc if sym-link use
" =[ SOURCE ]=================================================================================================
" auto. re-source vimrc when buffer is saved(handy when testing new settings in vimrc file)
autocmd! BufWritePost $MYVIMRC,$MYREALVIMRC source $MYVIMRC | echom "Reloaded " . $MYVIMRC 
" if not in vimrc file then SAVE and SOURCE file(handy when writting vimscript function outside vimrc file)
function! g:SaveAndSourceFile()
    let l:filename = fnamemodify(expand('%'), ':t')
    if l:filename == "vimrc" || l:filename == ".vimrc"
        echom "vimrc can't be source with <F5> (g:SaveAndSourceFile) because of the 'vimrc' augroup declaration"
    else
        silent! write 
        source %
        echom 'Sourced ' . l:filename
    endif
endfunction
map <silent> <F5> <Esc>:call g:SaveAndSourceFile()<Esc>
" =[ COMPATIBLE VI ]==========================================================================================
" Resetting compatible:Filetypes & 'compatible' don't work together well, since being Vi compatible means options are global.
set nocompatible
" =[ FILETYPE ]===============================================================================================
" Active default filetypes detection, filetype-plugin and filetype-indent
"   - filetype on   : Enable filetype-detect by sourcing the $VIMRUNTIME/filetype.vim file.
"   - indent on     : Enable filetype-indent by sourcing the $VIMRUNTIME/indent.vim and $VIMRUNTIME/ftplugin/<filetype>.vim files
"   - plugin on     : Enable filetype-plugin by sourcing the $VIMRUNTIME/plugin.vim and $VIMRUNTIME/ftplugin/<filetype>.vim files
filetype plugin indent on
" =[ SYNTAX ]=================================================================================================
syntax on           " Enable syntax feature by sourcing the $VIMRUNTIME/syntax/syntax.vim file.
" =[ LEADERKEY ]==============================================================================================
" Define [`] as leaderkey
let mapleader = "`"
" =[ SETTINGS ]===============================================================================================
" -[ BASICS ]-------------------------------------------------------------------------------------------------
set viminfo+=n~/.vim/viminfo             | " Change default location of viminfo file
set mouse=a                              | " Enable the use of the mouse in all mode ('a')
set scrolloff=5                          | " When scroll, keep cursor 5lines away of top/bottom
set belloff=all                          | " Desable all bell/sound
" -[ CLIPBOARD AND REGISTERS ]--------------------------------------------------------------------------------
set clipboard=unnamedplus                | " Use clipboard as default buffer for cpy/past (cross-plat: all UNIX)
" To force sync. after vim put in background using Ctrl_z and reput in frontground using `fg` cmd:
aug ClipboardSync
  au!
  au VimSuspend * exe "!echo ".shellescape(trim(getreg('+')), "#%`*?")." | xsel -bi"
  "au VimResume  * let @+ = @"           | " Obsolet since vim compiled with +CLIPBOARD
aug END
" -[ DISPLAY ]------------------------------------------------------------------------------------------------
set textwidth=110                        | " Default max lines width
set colorcolumn=+0                       | " Hihlight the column at textwidth
set number 	                             | " Display the line numbering
set nowrap                               | " If line longer than windows, do not wrap text instead of horizontal scrolling
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
" COMMANDS
" ============================================================================================================
" =[ VIMGREP  ]===============================================================================================
command! -nargs=+ Vimgrep tabnew | execute 'vimgrep' . <q-args> | copen

" ============================================================================================================
" MAPPING
" ============================================================================================================
" =[ EX MODE ]================================================================================================
" Get rid of [Shift]+[q] to enter Ex-mode (miss-click all the time and I personnaly never use this mode)
noremap Q <Nop>

" =[ COMPLETION ]=============================================================================================
" Allow 'j' and 'k' to navigate in 'Insert completion mode'
imap <expr> j pumvisible() ? "\<C-n>" : 'j'
imap <expr> k pumvisible() ? "\<C-p>" : 'k'

" =[ TABULATIONS ]============================================================================================
" -[ OPEN NEW TAB ]-------------------------------------------------------------------------------------------
map te : tabe<Space>
" -[ MOVE ACTUAL TAB ORDER ]----------------------------------------------------------------------------------
map tm : tabm<Space>
" -[ OPEN IN VSPLIT MODE ]------------------------------------------------------------------------------------
map ts : vsplit<Space>
" -[ OPEN A NEW HELP TAB ]------------------------------------------------------------------------------------
map th : tab help<Space>

" =[ CUSTOM COMMANDS ]========================================================================================
" =[ Ctrl+l ]=================================================================================================
" Combine multiple action: Remove HighLighting (abbrev :noh) + Active syntax-coloration + redraw page
noremap <silent> <C-l> :<C-u>:nohl<CR>:syn on<CR><C-l>:up<CR>
vnoremap <silent> <C-l> <C-c>:<C-u>nohl<CR>:syn on<CR><C-l>:up<CR>
inoremap <silent> <C-l> <C-o>:<C-u>nohl<CR>:syn on<CR><C-l>:up<CR>
 
" -[ FORCE SAVE ]---------------------------------------------------------------------------------------------
":w -> Always save (even if file was not modify)
noremap <c-s> :write<CR>
vnoremap <c-s> <c-c>:write<CR>
inoremap <c-s> <c-o>:write<CR>

" =[ SEARCH&REPLACE ]=========================================================================================
" Search&replace globaly(entire file) and interactive(ask before replacing)
noremap ;; :%s:::gc<left><left><left><left>
" Search&replace only in selection and automatically(no Q? asks)
vnoremap ;; :s:::g<left><left><left>

" ============================================================================================================
" AUTOMATIONS
" ============================================================================================================
"Force refresh to fix plugin
" To force sync. after vim put in background using Ctrl_z and reput in frontground using `fg` cmd:
aug ForceRefresh
  au!
  au VimEnter,VimResume,BufEnter * exe "update"
aug END
" =[  SWITCH CAPS<->ESCAP ]===================================================================================
"au VimEnter * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
"au VimLeave * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'

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
Plug 'junegunn/vim-peekaboo'         " Display the registers content on sidebar
Plug 'majutsushi/tagbar'             " Display tags in a windows (ordered by scope)
Plug 'morhetz/gruvbox'               " Theme & color retro groove
Plug 'scrooloose/nerdtree'           " File system explorer
Plug 'scrooloose/syntastic'          " Syntax checking
Plug 'vim-utils/vim-man'             " View man pages in vim
Plug 'vimwiki/vimwiki'               " Personnal Wiki
call plug#end()

" =[ NORMINETTE-VIM ]=========================================================================================
" -[ GENERAL SETTINGS ]---------------------------------------------------------------------------------------
let g:syntastic_aggregate_errors = 1                           " Check all checker that apply (c + norminette) then regroup then as one 
let g:syntastic_error_symbol = "✗"                             " Syntastic error symbol (default >>)
let g:syntastic_check_on_open = 1                              " Check errors when opening a file (disable to speed up startup time)
let g:syntastic_always_populate_loc_list = 1                   " Enable error list
let g:syntastic_auto_loc_list = 1                              " Automatically open error list
let g:syntastic_check_on_wq = 0                                " Skip check when closing
" -[ C SETTING ]----------------------------------------------------------------------------------------------
" Activates the norminette checker only if it's a c file inside a folder whose name is contained in the following list of names: (aka: a 42 project)
let g:normed_project_list = ["first_try","second_try","libft","libft_enhanced","ft_printf","get_next_line","GNL","push_swap", "pipex", "so_long"]
" Combine norminette+gcc as default checkers for files c file when inside a 42 project: (name found in normed_project_list)
autocmd FileType c if len(filter(copy(g:normed_project_list), {_, v -> match(expand("%:p"), "/".v."/") >= 0})) > 0 | let b:syntastic_checkers = ['norminette', 'gcc'] | endif
let g:syntastic_c_checkers = ['gcc']                           " set gcc compilator as default C checker
let g:c_syntax_for_h = 1                                       " Support headers (.h)
let g:syntastic_c_norminette_exec = 'norminette'               " Set the path to norminette
let g:syntastic_c_include_dirs = ['include', '../include', '../../include', 'libft', '../libft/include', '../../libft/include']
" -[ MAPPING ]------------------------------------------------------------------------------------------------
cabbrev stm SyntasticToggleMode<CR>
cabbrev sc SyntasticCheck<CR>

" =[ GRUVBOX ]================================================================================================
" -[ SETTING ]------------------------------------------------------------------------------------------------
set t_Co=256
set background=dark
colorscheme gruvbox
" -[ MAPPING ]------------------------------------------------------------------------------------------------

" =[ NERD-TREE ]==============================================================================================
" -[ SETTING ]------------------------------------------------------------------------------------------------
" -[ MAPPING ]------------------------------------------------------------------------------------------------
nnoremap <c-t> :NERDTreeToggle<CR>
nnoremap <c-f> :NERDTreeFind

" =[ MAN-VIM ]================================================================================================
" -[ SETTING ]------------------------------------------------------------------------------------------------
" -[ MAPPING ]------------------------------------------------------------------------------------------------
" Open man in new tab
noremap <leader>m <Plug>(Tman)
" Open man in split tab
noremap <leader>vm <Plug>(Vman)

" =[ VIMWIKI ]================================================================================================
" -[ MARKDOWN SYNTAX ]----------------------------------------------------------------------------------------
" Force show extension in links
let g:vimwiki_markdown_link_ext = 1
" Treat all markdown files in my system as part of vimwiki
let g:vimwiki_global_ext = 1
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
" Open link in split tab
noremap <Leader>v<CR> <Plug>VimwikiVSplitLink
" Open link in a new tab
noremap <Leader><CR> <Plug>VimwikiTabDropLink
" =[ TAGBAR ]=================================================================================================
nmap <F8> :TagbarToggle<CR>
