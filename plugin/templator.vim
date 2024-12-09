" ============================================================================================================
" LOAD TEMPLATE/SKELETON
" ============================================================================================================
"
" Functions, autogroup and mapping that insert value and template
"
"
" Commands/Functions:
"   - `:InsertMatches` = every '{{<match>}} occurence will be replace by their value
"       - Time      : yes, YES, yesterday, day, DAY, today, now, tom, TOM, tomorrow
"       - File      : file.name, file.NAME, file.path, file.ext, folder.name, filepath
"       - Special   : how_to.title, fix_it.title
"   - Autogroup filetype-detection :
"       - how_to    : any mardown file that file.name or folder.name start with how_to
"       - fix_it    : any mardown file that's not a how_to file AND file.name or folder.name start with how_to
"   - `:InsertTemplate` = insert the args1 if known
"       - diary.txt     : diary entries   (match: name==hhhh-mm-dd.md)
"       - fix_it.txt    : fix_it filetype (TODO match: custom-filetype) 
"       - how_to.txt    : how_to filetype (TODO match: custom-filetype)
"       - tool_index.txt: Tools index page(match: path&name==wiki0:Notes/Tools/**/index.md
"       - wiki_page.txt : filetype vimwiki(TODO:if not already insert/or/if not any of other filetype)
"       - resume.txt    : resume filetype (TODO:match: name==resume*.md)
"
" TODO :
" ============================================================================================================
" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
" =[ AUTO-COMPLETION ]========================================================================================
" To create a insert
func! ListMatches()
    call complete(col('.'), [ '{{yes}}', '{{YES}}', '{{yesterday}}', '{{day}}', '{{DAY}}', '{{today}}', '{{now}}', '{{tom}}', '{{TOM}}', '{{tomorrow}}', '{{folder.name}}', '{{folder.path}}', '{{file.name}}', '{{file.NAME}}', '{{file.ext}}', '{{file.path}}' ])
    return ''
endfunc
inoremap <F3> <C-R>=ListMatches()<CR>
" =[ SEARCH&REPLACE FUNCTIONS ]===============================================================================
" -[ TIME ]---------------------------------------------------------------------------------------------------
fun! s:TMP_InsertTimeFormat()
    " Date Yesterday
    silent! exe "%s/\{\{yes\}\}/".trim(system('date -d "yesterday" +%a'))."/gI"     | " {{yes}}      ='Sun'             CASE SENSITIVE
    silent! exe "%s/\{\{YES\}\}/".trim(system('date -d "yesterday" +%A'))."/gI"     | " {{YES}}      ='Sunday'        CASE SENSITIVE
    silent! exe "%s/\{\{yesterday\}\}/".trim(system('date -d "yesterday" +%F'))."/g"| " {{yesterday}}='2024-12-01'
    " Date Today
    silent! exe "%s/\{\{day\}\}/".trim(system('date +%a'))."/gI"                    | " {{day}}      ='Mon'             CASE SENSITIVE
    silent! exe "%s/\{\{DAY\}\}/".trim(system('date +%A'))."/gI"                    | " {{DAY}}      ='Monday'        CASE SENSITIVE
    silent! exe "%s/\{\{today\}\}/".trim(system('date +%F'))."/g"                   | " {{today}}    ='2024-12-02'
    " Time Now
    silent! exe "%s/\{\{now\}\}/".trim(system('date +%T'))."/g"                     | " {{now}}      ='23:59:45'
    " Date Tomorow
    silent! exe "%s/\{\{tom\}\}/".trim(system('date -d "tomorrow" +%a'))."/gI"      | " {{tom}}      ='Tue'             CASE SENSITIVE
    silent! exe "%s/\{\{TOM\}\}/".trim(system('date -d "tomorrow" +%A'))."/gI"      | " {{TOM}}      ='Tuesday'        CASE SENSITIVE
    silent! exe "%s/\{\{tomorrow\}\}/".trim(system('date -d "tomorrow" +%F'))."/g"  | " {{tomorrow}} ='2024-12-03'
endfun
" -[ PATH ]---------------------------------------------------------------------------------------------------

fun! s:TMP_InsertFileInfos()
    silent! exe "%s/\{\{folder.name\}\}/".expand('%:p:h:t')."/g" | " plugin='vim'
    silent! exe "%s:\{\{folder.path\}\}:".expand('%:p:h').":g"   | " /home/altergnu/Projects/Dotfiles/vim/plugin='/path/folder/'
    let l:filename = substitute(expand('%:t:r'),"_"," ","g")     | " replace toto_titi_tutu by toto titi tutu
    silent! exe "%s/\{\{file.name\}\}/".l:filename."/gI"         | " templateur='vimrc'     CASE SENSITIVE
    silent! exe "%s/\{\{file.NAME\}\}/".expand('%:t')."/gI"      | " templateur.vim='vimrc.vim' CASE SENSITIVE
    silent! exe "%s/\{\{file.ext\}\}/\.".expand('%:e')."/g"      | " .vim='.vim'
    silent! exe "%s:\{\{file.path\}\}:".expand('%:p').":g"       | " /home/altergnu/Projects/Dotfiles/vim/plugin/templateur.vim='/path/folder/filename.ext'
endfun
" -[ SPECIAL FORMAT ]-----------------------------------------------------------------------------------------
fun! s:TMP_InsertSpecial()
    let l:file_name=expand('%:t:r')
    let l:folder_name=expand('%:p:h:t')
    " How to: templateur-->always How to: templateur
    let l:how_to_title = "How to: ".substitute(substitute(l:file_name,"_"," ","g"),"how to ","","g")
    silent! exe "%s/\{\{how_to.title\}\}/".l:how_to_title."/gI"
    " Fix_it : templateur-->always Fix_it: templateur
    let l:fix_it_title = "Fix it: ".substitute(substitute(l:file_name,"_"," ","g"),"fix it ","","g")
    silent! exe "%s/\{\{fix_it.title\}\}/".l:fix_it_title."/gI"
    " Resume : templateur-->always Resume: templateur
    let l:resume_title = "Resume: ".substitute(substitute(l:file_name,"_"," ","g"),"resume ","","g")
    silent! exe "%s/\{\{resume.title\}\}/".l:resume_title."/gI"
endfun
" -[ ONE TO CALL THEM ALL ]-----------------------------------------------------------------------------------
fun! s:TMP_InsertAllMatches()
    call s:TMP_InsertTimeFormat()
    call s:TMP_InsertFileInfos()
    call s:TMP_InsertSpecial()
endfun
" -[ INSERT A SPECIFIC TEMPLATE ]-----------------------------------------------------------------------------
" if template_name is a file in templates folder, insert on line 0 then call InsertMatches cmd
fun! s:TMP_InsertSpecificTemplate(template_name)
    "if g:template_inserted
    "    echo "return from ". a:template_name
    "    return
    "endif
    if a:template_name =~? ".txt"
        let l:tpl_name=a:template_name
    else
        let l:tpl_name=a:template_name . ".txt"
    endif
    if exists("$VIMPATH") == 0
        let l:abspath = "~/.vim/templates/" . l:tpl_name
    else
        let l:abspath = $VIMPATH . "/templates/" . l:tpl_name
    endif
    if filereadable(l:abspath)
        exe "0r " . l:abspath
    "    let g:template_inserted = 1
    else
        echoerr l:abspath . " is NOT a template file"
    endif
    InsertMatches
endfun

" ============================================================================================================
" COMMANDES
" ============================================================================================================
command! InsertMatches call s:TMP_InsertAllMatches()
command! -nargs=1 InsertTemplate call s:TMP_InsertSpecificTemplate(<f-args>)
" ============================================================================================================
" AUGROUP
" ============================================================================================================
augroup Plugin_Templateur
	autocmd!
    " Insert tool_index.txt 
    autocmd BufNewfile */Tools/**/index.md call s:TMP_InsertSpecificTemplate('tool_index')
    " Insert diary.txt 
    autocmd BufNewfile ????-??-??.md call s:TMP_InsertSpecificTemplate('diary')
    " Insert resume.txt
    autocmd BufEnter *.md if ( !filereadable(expand('%')) && ( expand('%:t') =~# '^\(R\|r\)esume' || expand('%:p:h:t') =~# '^\(R\|r\)esume')) | call s:TMP_InsertSpecificTemplate('resume') | endif
    " g:template_inserted is set to 0 before every read of a file
    "autocmd BufReadPost * let g:template_inserted = 0
    " If parent folder name or filename start with how_to or How_to, then insert 'how_to.txt'
    "autocmd BufEnter *.md if ( !filereadable(expand('%')) && ( expand('%:t') =~# '^\(H\|h\)ow_to' || expand('%:p:h:t') =~# '^\(H\|h\)ow_to')) | call s:TMP_InsertSpecificTemplate('how_to') | endif
    " If parent folder name or filename start with Fix or fix, then insert 'fix_it.txt'
    "autocmd BufEnter *.md if ( !filereadable(expand('%')) && ( expand('%:t') =~# '^\(F\|f\)ix_' || expand('%:p:h:t') =~# '^\(F\|f\)ix')) | call s:TMP_InsertSpecificTemplate('fix_it') | endif
    " If it's a wiki page, insert wiki_page
    "autocmd filetype vimwiki if ( join(getline(1, '$')) ==# '' ) | call s:TMP_InsertSpecificTemplate('wiki_page') | endif
augroup END
 
