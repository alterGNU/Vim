" ============================================================================================================
" DATEDIFF
" ============================================================================================================
"
" Functions, autogroup and mapping that calculate the difference between dates
"
" Fonctions
"   - `g:InsertDuration()` = search if duration line is set, if not set un possible to calculate, insert value
"
" Commands
"   - `:DateDiff <yyyy-mm-dd day hh:mm:ss> <YYYY-MM-DD DAY HH:MM:SS>` = return hh:mm:ss 
"   - `:InsertDuration` = search if duration line is set, if not set un possible to calculate, insert value
"
" TODO :
"   - [X] handle cas if more than 24 hours, output format x days hh:mm:ss
"   - [ ] add other output time and date format
"   - [ ] add other input time and date format (parser)
" ============================================================================================================

" ============================================================================================================
" FUNCTIONS
" ============================================================================================================
" -[ DATEDIFF ]-----------------------------------------------------------------------------------------------
" Return diff between stop and start dates as '(x day(s) )xxhxxmxx'
fun! s:DateDiff(start, stop)
    let l:start=trim(system('date -d "' . a:start . '" "+%s"'))
    let l:stop=trim(system('date -d "' . a:stop . '" "+%s"'))
    let l:duree=l:stop - l:start
    let l:dd=l:duree / 86400
    let l:hh=(l:duree%86400)/3600
    let l:mm=(l:duree%3600)/ 60
    let l:ss=l:duree%60
    if l:dd == 0
        let l:days=""
    elseif l:dd == 1
        let l:days=l:dd . 'day '
    else
        let l:days=l:dd . 'days '
    endif
    let l:res = printf('%s%02dh%02dm%02ds', l:days, l:hh ,l:mm ,l:ss)
    return l:res
endfun

" -[ SEARCH AND INSERT DURATION ]-----------------------------------------------------------------------------
fun! g:InsertDuration()
    let l:duration_line_number = search("^- Duration", 'n')
    if l:duration_line_number > 0
        let l:duration_split = split(getline(l:duration_line_number), ':')
        let l:duration_value = len(l:duration_split) > 1 ? trim(join(l:duration_split[1:], ":"), " ") : ""
        if l:duration_value == ""
            let l:start_split = split(getline(search("^- Start Date", 'n')), ':')
            let l:start_date = len(l:start_split) > 1 ? trim(join(l:start_split[1:], ":"), " ") : ""
            let l:stop_split = split(getline(search("^- End Date", 'n')), ':')
            let l:stop_date = len(l:stop_split) > 1 ? trim(join(l:stop_split[1:], ":"), " ") : ""
            if l:start_date != "" && l:stop_date != "" 
                let l:new_duration_line = printf('%s: %s', l:duration_split[0], s:DateDiff(l:start_date, l:stop_date))
                call setline(l:duration_line_number, l:new_duration_line)
            else
                echo "Can't use duration without start AND stop line"
            endif
        else
            echo "duration already set at: ".l:duration_value
        endif
    else
        echo "No duration line"
    endif
endfun

 
" ============================================================================================================
" COMMANDS
" ============================================================================================================
command! InsertDuration call g:InsertDuration()
command! -nargs=* DateDiff call s:DateDiff(<f-args>)
