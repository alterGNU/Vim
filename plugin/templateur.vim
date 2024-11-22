" ============================================================================================================
" LOAD TEMPLATE/SKELETON
" ============================================================================================================
"
" Functions, autogroup and mapping that insert value and template
"
" Commands/Functions :
"   - `:InsertMatches` = every '{{<match>}} occurence will be replace by their value
"       - Time      : day, DAY, date, time
"       - File      : file.name, file.NAME, file.path, file.ext, folder.name, filepath
"       - Special   : how_to.title
"   - `:Done` search status_line and end_date_line, then set how_to tickets/sheets to Done status by:
"       - adding end date (using InserMatches command)
"       - adding status icon ✅
"
" TO-DO :
"   - [ ] Move Done functions to it's own plugin
"   - [ ] Create InsertTemplate fct that wrap InsertSpecificTemplate
"   - [ ] Manage vimwiki creating how_to file
"   - [ ] Done add other filetypetemplate than how_to.tpl
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
    let l:how_to_title = "How to: ".substitute(substitute(expand('%:t:r'),"_"," ","g"),"how to ","","g")
    silent! exe "%s/\{\{how_to.title\}\}/".l:how_to_title."/gI" | " {{how_to.title}}-->always How to: {{file.name}}
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
    else
        echoerr l:abspath . " is NOT a template file"
    endif
    InsertMatches
endfun

" =[ DONE FUNCTION ]==========================================================================================
" -[ DONE HOW_TO.TPL ]----------------------------------------------------------------------------------------
" Done function for how_to.tpl template
fun! g:Done_how_to_tpl()
    let l:enddate_line_number = search("- End Date", 'n')
    if l:enddate_line_number > 0
        let l:new_enddate_line = split(getline(l:enddate_line_number), ':')[0].": {{date}} {{day}} {{time}}"
        call setline(l:enddate_line_number, l:new_enddate_line)
        InsertMatches
    endif

    let l:status_line_number = search("- Status", 'n')
    if l:status_line_number > 0
        let l:new_status_line = split(getline(l:status_line_number), ':')[0].": ✅"
        call setline(l:status_line_number, l:new_status_line)
    endif
endfun

" -[ DONE TO DONE THEM ALL ]----------------------------------------------------------------------------------
" Apply the done function depending on the file we're on.
fun! g:Done()
   let l:filename=expand('%:t')
   let l:foldername=expand('%:p:h:t')
   if l:filename =~? "^how_to" || l:foldername =~? "^how_to"
       call g:Done_how_to_tpl()
       echom "Done how_to.tpl file"
   else
       echom "nothing do be 'Done' here"
   endif
endfun

" ============================================================================================================
" COMMANDES
" ============================================================================================================
command! InsertMatches call s:TMP_InsertAllMatches()
command! -nargs=1 InsertTemplate call s:TMP_InsertSpecificTemplate(<f-args>)
command! Done call g:Done()

" ============================================================================================================
" AUGROUP
" ============================================================================================================
augroup Plugin_Templateur
	autocmd!
    " If parent folder name or filename start with how_to or How_to, then insert 'how_to.tpl'
	autocmd BufNewFile ~/GPW/**/*.md InsertTemplate("wiki_page")
    " If parent folder name or filename start with how_to or How_to, then insert 'how_to.tpl'
	autocmd BufNewFile {{H,h}ow_to*.md,**/{H,h}ow_to/*.md} InsertTemplate how_to
augroup END
 
