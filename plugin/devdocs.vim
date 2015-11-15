if (exists('g:loaded_devdocs') && g:loaded_devdocs) || &cp
    finish
endif

let g:devdocs_host = get(g:, 'devdocs_host', 'devdocs.io')
let g:devdocs_filetype_map = get(g:, 'devdocs_filetype_map', {})

command! -nargs=* DevDocs call devdocs#open(<q-args>, &l:ft)
command! -nargs=* DevDocsAll call devdocs#open(<q-args>)
command! -nargs=0 DevDocsUnderCursor call devdocs#open(expand('<cword>'), &l:ft)
command! -nargs=0 DevDocsAllUnderCursor call devdocs#open(expand('<cword>'))

nnoremap <silent><Plug>(devdocs-under-cursor) :<C-u>call devdocs#open(expand('<cword>'), &l:ft)<CR>
nnoremap <silent><Plug>(devdocs-under-cursor-all) :<C-u>call devdocs#open(expand('<cword>'))<CR>

let g:loaded_devdocs = 1
