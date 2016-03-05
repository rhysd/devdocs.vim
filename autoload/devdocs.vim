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

function! s:related_to(ft) abort
    return get(g:devdocs_filetype_map, a:ft, get(s:DEFAULT_FILETYPE_MAP, a:ft, ''))
endfunction

function! s:open_fallback(url) abort
    let url = shellescape(a:url)
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
        call system('cmd /q /c start "" ' . url)
    else
        echoerr 'Unknown platform. devdocs.vim doesn''t know how to open URL: ' . url
        return
    endif
    if v:shell_error
        echoerr 'Error on opening URL: ' . url
    else
        echo 'Page opened: ' . url
    endif
endfunction

function! s:doc_url(base_url, doc_name) abort
    return printf('%s/%s/', a:base_url, s:URI.encode(a:doc_name))
endfunction

function! s:query_url(base_url, query, doc) abort
    let query = a:query
    if a:doc !=# ''
        let query = a:doc . ' ' . query
    endif
    return a:base_url . '/#q=' . s:URI.encode(query)
endfunction

function! s:build_url(query, doc) abort
    let url = 'http://' . g:devdocs_host
    if a:query ==# ''
        if a:doc ==# ''
            return url
        endif
        return s:doc_url(url, a:doc)
    else
        return s:query_url(url, a:query, a:doc)
    endif
endfunction

"
" devdocs#url(query?: string, filetype?: string): string
"
function! devdocs#url(...) abort
    let query = get(a:, 1, '')
    let ft =  get(a:, 2, '_')
    let doc = get(g:devdocs_filetype_map, '*', s:related_to(ft))
    return s:build_url(query, doc)
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

"
" devdocs#open_doc(query?: string, doc_name?: string): void
"
function! devdocs#open_doc(...) abort
    let url = s:build_url(get(a:, 1, ''), get(a:, 2, ''))
    try
        call openbrowser#open(url)
    catch /^Vim\%((\a\+)\)\=:E117/
        call s:open_fallback(url)
    endtry
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
