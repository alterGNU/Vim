" ============================================================================================================
" LOAD TEMPLATE/SKELETON
" ============================================================================================================
"
" Functions, autogroup and mapping that insert value and template
"
" Commands/Functions :
"   - `:InsertMatches` = every '{{<match>}} occurence will be replace by their value
"       - <match> : day,DAY,date,time,file.name,file.NAME,foldername,file.ext,filepath, how_to.title
"   - `:Done` search status_line and end_date_line, then set how_to tickets/sheets to Done status by:
"       - adding end date (using InserMatches command)
"       - adding status icon ✅
"
" TO-DO :
"   - [ ] Create InsertTemplate fct that wrap InsertSpecificTemplate
"   - [ ] Manage vimwiki creating how_to file
"   - [ ] Done add other filetypetemplate than how_to.tpl
" ============================================================================================================

" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
" =[ SEARCH&REPLACE FUNCTIONS ]===============================================================================
" -[ TIME ]---------------------------------------------------------------------------------------------------
fun! g:TMP_InsertTime()
    silent! exe "%s/\{\{day\}\}/".strftime("%a")."/gI"          | " {{day}}='Sat'              CASE SENSITIVE
    silent! exe "%s/\{\{DAY\}\}/".strftime("%A")."/gI"          | " {{DAY}}='Saturday'         CASE SENSITIVE
    silent! exe "%s/\{\{date\}\}/".strftime("%Y-%m-%d")."/g"    | " {{date}}='2024-12-24'
    silent! exe "%s/\{\{time\}\}/".strftime("%H:%M:%S")."/g"    | " {{time}}='23:59:45'
endfun
" -[ PATH ]---------------------------------------------------------------------------------------------------
fun! g:TMP_InsertFile()
    let l:filename = substitute(expand('%:t:r'),"_"," ","g")    | " replace toto_titi_tutu by toto titi tutu
    silent! exe "%s/\{\{file.name\}\}/".l:filename."/gI"        | " {{file.name}}='vimrc'      CASE SENSITIVE
    silent! exe "%s/\{\{file.NAME\}\}/".expand('%:t')."/gI"     | " {{file.NAME}}='vimrc.vim'  CASE SENSITIVE
    silent! exe "%s/\{\{foldername\}\}/".expand('%:p:h:t')."/g" | " {{foldername}}='vim'
    silent! exe "%s/\{\{file.ext\}\}/\.".expand('%:e')."/g"     | " {{file.ext}}='.vim'
    silent! exe "%s:\{\{file.path\}\}:".expand('%:p').":g"      | " {{file.path}}='/path/folder/filname.ext'
endfun
" -[ SPECIAL FORMAT ]-----------------------------------------------------------------------------------------
fun! g:TMP_InsertSpecial()
    let l:how_to_title = "How to: ".substitute(substitute(expand('%:t:r'),"_"," ","g"),"how to ","","g")
    silent! exe "%s/\{\{how_to.title\}\}/".l:how_to_title."/gI" | " {{how_to.title}}-->always How to: {{file.name}}
endfun
" -[ ONE TO CALL THEM ALL ]-----------------------------------------------------------------------------------
fun! g:TMP_InsertAllMatches()
    call g:TMP_InsertTime()
    call g:TMP_InsertFile()
    call g:TMP_InsertSpecial()
endfun

" -[ INSERT A SPECIFIC TEMPLATE ]-----------------------------------------------------------------------------
" if template_name is a file in templates folder, insert on line 0 then call InsertMatches cmd
fun! g:TMP_InsertSpecificTemplate(template_name)
    if len($MYVIMRC) == 0
        let l:abspath = "~/.vim/templates/" . a:template_name . ".tpl"
    else
        let l:abspath = "/".join(split($MYVIMRC, '/')[:-2], '/') . "/templates/" . a:template_name . ".tpl"
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

" =[ VIMWIKI TRIGGER ]========================================================================================
" When vimwiki create a file, it doesn't trigger autocmd BufNewFile or BufWritePost.
" When vimwiki create a file, it trigger the event `user VimwikiIndex`

" ============================================================================================================
" AUGROUP
" ============================================================================================================
augroup Plugin_Templateur
	autocmd!
    " If parent folder name or filename start with how_to or How_to, then insert 'how_to.tpl'
	autocmd BufNewFile ~/GPW/**/*.md call g:TMP_InsertSpecificTemplate("wiki_page")
    " If parent folder name or filename start with how_to or How_to, then insert 'how_to.tpl'
	autocmd BufNewFile {{H,h}ow_to*.md,**/{H,h}ow_to/*.md} call g:TMP_InsertSpecificTemplate("how_to")
augroup END
 
" ============================================================================================================
" COMMANDES
" ============================================================================================================
command InsertMatches call g:TMP_InsertAllMatches()
command! Done call g:Done()
