" ============================================================================================================
" LOAD TEMPLATE/SKELETON
" ============================================================================================================
"
" Functions, autogroup and mapping that insert value and template
"
" USAGE :
"   - <F5> OR `: call TMP_InsertAllMatches` = every '{{<match>}} occurence will be replace by their value
"       - <match> : day,DAY,date,time,file.name,file.NAME,foldername,file.ext,filepath
"   - call TMP_InsertTemplate(file) : if exist, insert ../vim/templates/<file>.tpl at the first line.
"
" TO-DO :
" ============================================================================================================

" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
" =[ SEARCH&REPLACE FUNCTIONS ]===============================================================================
" -[ TIME ]---------------------------------------------------------------------------------------------------
function! s:TMP_InsertTime()
    silent! exe "%s/\{\{day\}\}/".strftime("%a")."/gI"         | " {{day}}='Sat'               CASE SENSITIVE
    silent! exe "%s/\{\{DAY\}\}/".strftime("%A")."/gI"         | " {{DAY}}='Saturday'          CASE SENSITIVE
    silent! exe "%s/\{\{date\}\}/".strftime("%Y-%m-%d")."/g"   | " {{date}}='2024-12-24'
    silent! exe "%s/\{\{time\}\}/".strftime("%H:%M:%S")."/g"   | " {{time}}='23:59:45'
endfunction
" -[ PATH ]---------------------------------------------------------------------------------------------------
function! s:TMP_InsertFile()
    let l:filename = substitute(expand('%:t:r'),"_"," ","g")   | " replace toto_titi_tutu by toto titi tutu
    silent! exe "%s/\{\{file.name\}\}/".l:filename."/gI"       | " {{file.name}}='vimrc'       CASE SENSITIVE
    silent! exe "%s/\{\{file.NAME\}\}/".expand('%:t')."/gI"    | " {{file.NAME}}='vimrc.vim'   CASE SENSITIVE
    silent! exe "%s/\{\{foldername\}\}/".expand('%:p:h:t')."/g"| " {{foldername}}='vim'
    silent! exe "%s/\{\{file.ext\}\}/\.".expand('%:e')."/g"    | " {{file.ext}}='.vim'
    silent! exe "%s:\{\{file.path\}\}:".expand('%:p').":g"     | " {{file.path}}='/path/folder/filname.ext'
endfunction
" -[ ONE TO CALL THEM ALL ]-----------------------------------------------------------------------------------
function! g:TMP_InsertAllMatches()
    call s:TMP_InsertTime()
    call s:TMP_InsertFile()
endfunction

" =[ INSERT TEMPLATE ]========================================================================================
" if template_name is a file in templates folder, insert on line 0 then call TMP_InsertAllMatches() fct
function! g:TMP_InsertTemplate(template_name)
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
    call g:TMP_InsertAllMatches()
endfunction

" ============================================================================================================
" AUGROUP
" ============================================================================================================
augroup Plugin_Templateur
	autocmd!
	autocmd BufNewFile ~/GPW/**/*.md call g:TMP_InsertTemplate("wiki_page")
augroup END
 
" ============================================================================================================
" MAPPING
" ============================================================================================================
map <silent> <F2> <Esc>:call TMP_InsertAllMatches()<CR>
