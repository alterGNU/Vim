" ============================================================================================================
" LOAD TEMPLATE/SKELETON
" ============================================================================================================
"
" Functions, autogroup and mapping that insert value and template
"
"
" Commands/Functions:
"   - `:InsertMatches` = every '{{<match>}} occurence will be replace by their value
"       - Time      : day, DAY, date, time
"       - File      : file.name, file.NAME, file.path, file.ext, folder.name, filepath
"       - Special   : how_to.title, fix_it.title
"   - Autogroup filetype-detection :
"       - how_to    : any mardown file that file.name or folder.name start with how_to
"       - fix_it   : any mardown file that's not a how_to file AND file.name or folder.name start with how_to
"   - `:InsertTemplate` = insert the args1 if known
"       - diary.tpl     : diary entries
"       - fix_it.tpl    : fix_it filetype
"       - how_to.tpl    : how_to filetype
"       - tool_index.tpl: wiki0:Notes/Tools/**/index.md
"       - wiki_page.tpl : filetype vimwiki (if not any of other filetype)
"
" TODO :
" ============================================================================================================

" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
" =[ SEARCH&REPLACE FUNCTIONS ]===============================================================================
" -[ TIME ]---------------------------------------------------------------------------------------------------
fun! s:TMP_InsertTimeFormat()
    silent! exe "%s/\{\{day\}\}/".strftime("%a")."/gI"           | " {{day}}='Sat'             CASE SENSITIVE
    silent! exe "%s/\{\{DAY\}\}/".strftime("%A")."/gI"           | " {{DAY}}='Saturday'        CASE SENSITIVE
    silent! exe "%s/\{\{date\}\}/".strftime("%Y-%m-%d")."/g"     | " {{date}}='2024-12-24'
    silent! exe "%s/\{\{time\}\}/".strftime("%H:%M:%S")."/g"     | " {{time}}='23:59:45'
endfun
" -[ PATH ]---------------------------------------------------------------------------------------------------
fun! s:TMP_InsertFileInfos()
    silent! exe "%s/\{\{folder.name\}\}/".expand('%:p:h:t')."/g" | " {{folder.name}}='vim'
    silent! exe "%s:\{\{folder.path\}\}:".expand('%:p:h').":g"   | " {{folder.path}}='/path/folder/'
    let l:filename = substitute(expand('%:t:r'),"_"," ","g")     | " replace toto_titi_tutu by toto titi tutu
    silent! exe "%s/\{\{file.name\}\}/".l:filename."/gI"         | " {{file.name}}='vimrc'     CASE SENSITIVE
    silent! exe "%s/\{\{file.NAME\}\}/".expand('%:t')."/gI"      | " {{file.NAME}}='vimrc.vim' CASE SENSITIVE
    silent! exe "%s/\{\{file.ext\}\}/\.".expand('%:e')."/g"      | " {{file.ext}}='.vim'
    silent! exe "%s:\{\{file.path\}\}:".expand('%:p').":g"       | " {{file.path}}='/path/folder/filename.ext'
endfun
" -[ SPECIAL FORMAT ]-----------------------------------------------------------------------------------------
fun! s:TMP_InsertSpecial()
    let l:file_name=expand('%:t:r')
    let l:folder_name=expand('%:p:h:t')
    " How to: templateur-->always How to: templateur
    let l:how_to_title = "How to: ".substitute(substitute(l:file_name,"_"," ","g"),"how to ","","g")
    silent! exe "%s/\{\{how_to.title\}\}/".l:how_to_title."/gI"
    " Fix_it : templateur-->always Fix_it : templateur
    let l:fix_it_title = "Fix it : ".substitute(substitute(l:file_name,"_"," ","g"),"fix it ","","g")
    silent! exe "%s/\{\{fix_it.title\}\}/".l:fix_it_title."/gI"
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
    if a:template_name =~? ".tpl"
        let l:tpl_name=a:template_name
    else
        let l:tpl_name=a:template_name . ".tpl"
    endif
    if len($MYVIMRC) == 0
        let l:abspath = "~/.vim/templates/" . l:tpl_name
    else
        let l:abspath = "/".join(split($MYVIMRC, '/')[:-2], '/') . "/templates/" . l:tpl_name
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
    " Insert tool_index.tpl 
    autocmd BufNewfile */Tools/**/index.md call s:TMP_InsertSpecificTemplate('tool_index')
    " Insert diary.tpl 
    autocmd BufNewfile ????-??-??.md call s:TMP_InsertSpecificTemplate('diary')
    " g:template_inserted is set to 0 before every read of a file
    "autocmd BufReadPost * let g:template_inserted = 0
    " If parent folder name or filename start with how_to or How_to, then insert 'how_to.tpl'
    "autocmd BufEnter *.md if ( !filereadable(expand('%')) && ( expand('%:t') =~# '^\(H\|h\)ow_to' || expand('%:p:h:t') =~# '^\(H\|h\)ow_to')) | call s:TMP_InsertSpecificTemplate('how_to') | endif
    " If parent folder name or filename start with Fix or fix, then insert 'fix_it.tpl'
    "autocmd BufEnter *.md if ( !filereadable(expand('%')) && ( expand('%:t') =~# '^\(F\|f\)ix_' || expand('%:p:h:t') =~# '^\(F\|f\)ix')) | call s:TMP_InsertSpecificTemplate('fix_it') | endif
    " If it's a wiki page, insert wiki_page
    "autocmd filetype vimwiki if ( join(getline(1, '$')) ==# '' ) | call s:TMP_InsertSpecificTemplate('wiki_page') | endif
augroup END
 
