devdocs.vim
===========
[![Build Status](https://travis-ci.org/rhysd/devdocs.vim.svg)](https://travis-ci.org/rhysd/devdocs.vim)

This is a Vim plugin for [devdocs](https://devdocs.io/), which is an awesome multiple API documentation
service.  You can open and search devdocs from Vim.

- Open and search devdocs using command `:DevDocs` or `:DevDocsAll`
- Relate filetype to specific documentation.
- Search word under the cursor.

## Usage

- `:DevDocs [query]` : Search with query with filetype related documentation (`query` can be omitted)
- `:DevDocsAll [query]` : Search with query with all documentation (`query` can be omitted)

## Customize

### Mapping `K` to search under the word quickly

devdocs.vim doesn't overrides any mapping by default.  You should define key mappings if you need.

If you always want to override `K` mapping,

```vim
nmap K <Plug>(devdocs-under-cursor)
```

If you want to override `K` mapping in specific filetypes,

```
augroup plugin-devdocs
  autocmd!
  autocmd FileType c,cpp,rust,haskell,python nmap <buffer>K <Plug>(devdocs-under-cursor)
augroup END
```

Above replaces `K` in C, C++, Rust, Haskell, and Python.

### Open with specific documentation on specific filetype

You can customize relationship between Vim's filetype and documentation.
Below is an example of customization.

```vim
let g:devdocs_filetype_map = {
    \   'ruby': 'rails',
    \   'javascript.jsx': 'react',
    \   'javascript.test': 'chai',
    \ }
```

With above configuration, `:DevDocs blah` searches Rails documentation on filetype `ruby`.

`:DevDocsAll` searches all documentation ignoring filetype relation and below configuration explicitly
disables this feature.

```vim
let g:devdocs_filetype_map = { '*': '' }
```

### Open local devdocs

You can easily [host local devdocs](https://github.com/Thibaut/devdocs#quick-start).  If your local
devdocs is hosted at `localhost:9292`, devdocs.vim uses it by following configuration.

```vim
let g:devdocs_host = 'localhost:9292'
```

If you use `http://` to host your DevDocs instance, please use `g:devdocs_url` variable to specify
an `http://` scheme.

```vim
let g:devdocs_url = 'http://localhost:9292'
```

### Make a command for specific document

You can use `devdocs#open_doc()` function to make such a command.

Below is an example for `:DevDocsReact` command to open page with 'react' documentation

```vim
command! -nargs=* DevDocsReact call devdocs#open_doc(<q-args>, 'react')
```

You can execute as below,

```
:DevDocsReact
:DevDocsReact componentDidMount
```

### Open in non-default browser

devdocs.vim opens URL with [open-browser.vim](https://github.com/tyru/open-browser.vim) at first.
If it is not installed, it tries to open default browser. If you don't install open-browser.vim and
want to use non-default browser, please use `g:devdocs_open_cmd` to specify what command should be
used for opening a browser.

```vim
" Open devdocs.io in Safari on macOS
let g:devdocs_open_cmd = 'open -a Safari'

" Open devdocs.io in Firefox on Linux
let g:devdocs_open_cmd = 'firefox'
```

## License

```
Copyright (c) 2015 rhysd

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```

