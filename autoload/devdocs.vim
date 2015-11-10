let s:save_cpo = &cpo
set cpo&vim

let s:V = vital#of('devdocs')
let s:URI = s:V.import('Web.URI')

let s:IS_WINDOWS = has('win32') || has('win64')
let s:IS_OS_X = has('mac') || has('macunix') || has('gui_macvim')
let s:IS_UNIX = !s:IS_OS_X && has('unix')

let s:DEFAULT_FILETYPE_MAP = {
            \   'c': 'c',
            \   'cpp': 'cpp',
            \   'clojure': 'clojure',
            \   'css': 'css',
            \   'go': 'go',
            \   'haskell': 'haskell',
            \   'rust': 'rust',
            \   'php': 'php',
            \   'python': 'python',
            \ }

let s:filetype_map = extend(copy(s:DEFAULT_FILETYPE_MAP), g:devdocs_filetype_map)

function! s:open_fallback(url) abort
    let url = shellescape(url)
    if s:IS_UNIX
        if executable('xdg-open')
            call system('xdg-open ' . url)
        else
            " Fallback
            call system('chromium ' . url)
        endif
    elseif s:IS_OS_X
        call system('open ' . url)
    elseif s:IS_WINDOWS
        call system('start ' . url)
    else
        echoerr 'Unknown platform. devdocs.vim doesn''t know how to open URL: ' . url
        return
    endif
    if v:shell_error
        echoerr 'Error on opening URL: ' . url
    endif
endfunction

function! s:build_query(query, doc) abort
    let query = a:query
    if a:doc !=# ''
        let query = a:doc . ' ' . query
    endif
    return s:URI.encode(query)
endfunction

"
" devdocs#url(query?: string, filetype?: string): string
"
function! devdocs#url(...) abort
    let url = 'http://' . g:devdocs_host
    if a:0 == 0
        return url
    endif

    let query = a:1
    let ft = a:0 > 1 ? a:2 : '_'
    let doc = get(s:filetype_map, '*', get(s:filetype_map, ft, ''))

    return url . '/#q=' . s:build_query(query, doc)
endfunction

"
" devdocs#open(query?: string, filetype?: string): void
"
function! devdocs#open(...) abort
    let url = call('devdocs#url', a:000)
    try
        call openbrowser#open(url)
    catch /^Vim\%((\a\+)\)\=:E117/
        call s:open_fallback(url)
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
