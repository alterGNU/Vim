" ============================================================================================================
" INSERTOR : Insert all kind of thing
" ============================================================================================================
"
" ............................................................................................................
" Insert Emojis: 
"  - fun g:InsertEmojis()               : Insert emojis using Search&Replace vim feature + Vimwiki emojis dictionnary, do not move the cursor to last emojy founded
"  - cmd InsertEmojis                   : Call g:InsertEmojis()
"
" Insert Matches: 
"   - matches-insertion:
"       - fun s:InsertTimeFormat()      : Insert time format matches=[yes, YES, yesterday, day, DAY, today, now, tom, TOM, tomorrow]
"       - fun s:InsertFileInfos()       : Insert file infos matches=[file.name, file.NAME, file.path, file.ext, folder.name, filepath]
"       - fun s:InsertFiletypeTitle()   : Insert special matches=[how_to.title, fix_it.title, resume.title]
"       - fun s:InsertAllMatches()      : Insert all matches without mouving the cursor to last matche founded.
"       - cmd InsertMatches             : Call s:InsertAllMatches()
"   - auto-completion:
"       - fun ListMatches()             : Auto-completion function that display all matches availlable
"       - insert-mode mapping <F3>      : Call ListMatches() 
"
" Insert Templates: 
"   - fun s:InsertTemplate(tmp_name)    : Insert ~/.vim/templates/<tmp_name>.txt if exists. then call s:InsertAllMatches and g:InsertEmojis
"   - cmd InsertTemplate <tmp_name>     : Call s:InsertTemplate(tmp_name).
"   - augroup Insert_templates          : Auto-Insertion of templates
"       - if filename==hhhh-mm-dd.md                          ➡️  insert ~/.vim/templates/diary.txt       
"       - if filepath&filename==wiki0:Notes/Tools/**/index.md ➡️  insert ~/.vim/templates/tool_index.txt  
"       - TODO:if filetype fix_it                             ➡️  insert ~/.vim/templates/fix_it.txt      
"       - TODO:if filetype how_to                             ➡️  insert ~/.vim/templates/how_to.txt      
"       - TODO:if filetype vimwikiype)                        ➡️  insert ~/.vim/templates/wiki_page.txt    
"       - TODO:if filetype resume .txt                        ➡️  insert ~/.vim/templates/resume.txt
" ............................................................................................................
 
" ============================================================================================================
" INSERT EMOJIS
" ============================================================================================================
" =[ FUNCTIONS ]==============================================================================================
" -[ INSERTEMOJIS ]--------------------------------------------------------------------------------------------
" insert emojis using vimwiki dict, adding a space after and without moving the cursor to last match founded.
" Long search&replace: replace all :...: pattern if ... is a key of our dict, then will display a space after
" the emoticon only if its size is lesser than 2(number of columns an emoticons should take in terminal)
" By adding this extra space, its avoid any overlapping character.
fun! s:InsertEmojis()
    let l:save_cursor = getcurpos()
    silent! %s/:\([^: ]\+\):/\=has_key(vimwiki#emoji#get_dic(), submatch(1)) ? vimwiki#emoji#get_dic()[submatch(1)].(strdisplaywidth(vimwiki#emoji#get_dic()[submatch(1)])==1?" ":"") : submatch(0)/g
    call setpos('.', l:save_cursor)
endfun
" =[ COMMANDES ]==============================================================================================
command! InsertEmojis call s:InsertEmojis()

" ============================================================================================================
" INSERT MATCHES
" ============================================================================================================
" =[ SEARCH&REPLACE FUNCTIONS ]===============================================================================
" -[ INSERT TIME FORMAT ]-------------------------------------------------------------------------------------
fun! s:InsertTimeFormat()
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
" -[ INSERT FILE INFOS ]--------------------------------------------------------------------------------------
fun! s:InsertFileInfos()
    silent! exe "%s/\{\{folder.name\}\}/".expand('%:p:h:t')."/g" | " plugin='vim'
    silent! exe "%s:\{\{folder.path\}\}:".expand('%:p:h').":g"   | " /home/altergnu/Projects/Dotfiles/vim/plugin='/path/folder/'
    let l:filename = substitute(expand('%:t:r'),"_"," ","g")     | " replace toto_titi_tutu by toto titi tutu
    silent! exe "%s/\{\{file.name\}\}/".l:filename."/gI"         | " templateur='vimrc'     CASE SENSITIVE
    silent! exe "%s/\{\{file.NAME\}\}/".expand('%:t')."/gI"      | " templateur.vim='vimrc.vim' CASE SENSITIVE
    silent! exe "%s/\{\{file.ext\}\}/\.".expand('%:e')."/g"      | " .vim='.vim'
    silent! exe "%s:\{\{file.path\}\}:".expand('%:p').":g"       | " /home/altergnu/Projects/Dotfiles/vim/plugin/templateur.vim='/path/folder/filename.ext'
endfun
" -[ INSERT SPECIAL FORMAT ]----------------------------------------------------------------------------------
fun! s:InsertFiletypeTitle()
    let l:file_name=expand('%:t')
    " How_to:
    let l:how_to_title = substitute(substitute(l:file_name,"_"," ","g"),"how to ","","g")
    silent! exe "%s/\{\{how_to.title\}\}/"."How_to : ".toupper(l:how_to_title[0]).l:how_to_title[1:-4]."/gI"
    " Fix_it:
    let l:fix_it_title = substitute(substitute(l:file_name,"_"," ","g"),"fix it ","","g")
    silent! exe "%s/\{\{fix_it.title\}\}/"."Fix_it : ".toupper(l:fix_it_title[0]).l:fix_it_title[1:-4]."/gI"
    " Resume:
    let l:resume_title = "Resume: ".substitute(substitute(l:file_name,"_"," ","g"),"resume ","","g")
    silent! exe "%s/\{\{resume.title\}\}/".l:resume_title."/gI"
endfun
" -[ INSERT THEM ALL ]----------------------------------------------------------------------------------------
fun! s:InsertAllMatches()
    let l:save_cursor = getcurpos()
    call s:InsertTimeFormat()
    call s:InsertFileInfos()
    call s:InsertFiletypeTitle()
    call setpos('.', l:save_cursor)
endfun
" =[ SEARCH&REPLACE COMMANDS ]================================================================================
command! InsertMatches call s:InsertAllMatches()

" =[ AUTO-COMPLETION-FUN ]====================================================================================
" -[ LISTMATCHES ]--------------------------------------------------------------------------------------------
" list all the matches.
fun! ListMatches()
    call complete(col('.'), [ '{{today}}', '{{day}}', '{{now}}', '{{yesterday}}', '{{yes}}', '{{file.name}}', '{{YES}}', '{{DAY}}', '{{tomorrow}}', '{{tom}}', '{{TOM}}', '{{folder.name}}', '{{folder.path}}', '{{file.NAME}}', '{{file.ext}}', '{{file.path}}', '{{how_to.title}}', '{{fix_it.title}}', '{{resume.title}}' ])
    return ''
endfun
" -[ MAPPING ]------------------------------------------------------------------------------------------------
inoremap <F3> <C-R>=ListMatches()<CR>
 
" ============================================================================================================
" INSERT TEMPLATES
" ============================================================================================================
" =[ FUNCTIONS  ]=============================================================================================
" -[ INSERT A SPECIFIC TEMPLATE ]-----------------------------------------------------------------------------
" if template_name is a available template, insert on line 0 then call InsertMatches and InsertEmojis commands
fun! s:InsertTemplate(template_name)
    if a:template_name =~? ".txt"
        let l:tpl_name=a:template_name
    else
        let l:tpl_name=a:template_name . ".txt"
    endif
    if isdirectory(expand('~/.vim/templates/'))
        let l:abspath = expand("~/.vim/templates/" . l:tpl_name)
    elseif isdirectory(expand($VIMPATH."/templates/"))
        let l:abspath = expand($VIMPATH."/templates/". l:tpl_name)
    endif
    if filereadable(l:abspath)
        exe "0r " . l:abspath
        exe "InsertMatches"
        exe "InsertEmojis"
    else
        echoerr l:abspath . " is NOT a template file"
    endif
endfun
" =[ COMMANDES ]==============================================================================================
command! -nargs=1 InsertTemplate call s:InsertTemplate(<f-args>)
" =[ AUGROUP ]================================================================================================
augroup Insert_templates
	autocmd!
    " Insert tool_index.txt 
    autocmd BufNewfile */Tools/**/index.md exe "InsertTemplate tool_index"
    " Insert diary.txt 
    autocmd BufNewfile ????-??-??.md call s:InsertTemplate('diary')
    "" Insert resume.txt
    "autocmd BufEnter *.md if ( !filereadable(expand('%')) && ( expand('%:t') =~# '^\(R\|r\)esume' || expand('%:p:h:t') =~# '^\(R\|r\)esume')) | call s:InsertTemplate('resume') | endif
    "" Insert how_to.txt
    "autocmd BufEnter *.md if ( !filereadable(expand('%')) && ( expand('%:t') =~# '^\(H\|h\)ow_to' || expand('%:p:h:t') =~# '^\(H\|h\)ow_to')) | call s:InsertTemplate('how_to') | endif
    "" Insert fix_it.txt
    "autocmd BufEnter *.md if ( !filereadable(expand('%')) && ( expand('%:t') =~# '^\(F\|f\)ix_' || expand('%:p:h:t') =~# '^\(F\|f\)ix')) | call s:InsertTemplate('fix_it') | endif
    "" Insert wiki_page.txt
    "autocmd filetype vimwiki if ( join(getline(1, '$')) ==# '' ) | call s:InsertTemplate('wiki_page') | endif
augroup END
 
