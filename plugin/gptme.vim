" gptme.vim - gptme integration for Vim
" Maintainer: Erik Bjäreholt
" Version: 0.2
" Last Change: 2025-01-30
"
" Configuration:
"   g:gptme_context_lines     - Number of context lines to include (default: 3)
"   g:gptme_terminal_position - Terminal window position: 'vertical' or 'horizontal' (default: 'vertical')
"   g:gptme_terminal_size     - Terminal window size in columns/lines (default: 80)
"   g:gptme_no_mappings       - Set to 1 to disable default mappings

if exists('g:loaded_gptme')
    finish
endif
let g:loaded_gptme = 1

" Default settings
if !exists('g:gptme_context_lines')
    let g:gptme_context_lines = 3
endif

" Default terminal position
if !exists('g:gptme_terminal_position')
    " Auto-detect position based on window layout
    function! s:detect_terminal_position()
        let l:window_width = &columns
        " Use vertical split if we have enough width (>160 columns)
        " otherwise use horizontal to preserve code width
        return l:window_width > 160 ? 'vertical' : 'horizontal'
    endfunction
    let g:gptme_terminal_position = s:detect_terminal_position()
endif

" Default terminal size
if !exists('g:gptme_terminal_size')
    " Set appropriate default size based on terminal position
    if g:gptme_terminal_position ==# 'vertical'
        let g:gptme_terminal_size = 80  " columns for vertical split
    else
        let g:gptme_terminal_size = 15  " lines for horizontal split
    endif
endif

function! s:gptme() range
    " Check if range was given (visual selection)
    let l:has_range = a:firstline != a:lastline

    if l:has_range
        " Get visually selected lines
        let l:context = getline(a:firstline, a:lastline)
    else
        " Get context around cursor
        let l:current_line = line('.')
        let l:start_line = max([1, l:current_line - g:gptme_context_lines])
        let l:end_line = min([line('$'), l:current_line + g:gptme_context_lines])
        let l:context = getline(l:start_line, l:end_line)
    endif

    let l:context_text = join(l:context, "\n")
    let l:ft = empty(&filetype) ? '' : &filetype
    let l:filename = expand('%:p')

    " Now get input from user
    let l:input = input('gptme prompt: ')
    if empty(l:input)
        return
    endif

    " Build the prompt with proper escaping
    let l:prompt = "Request: " . l:input . "\n\n"
    let l:prompt .= "File: " . l:filename . "\n"
    let l:prompt .= "Selected text/lines:\n```" . l:ft . "\n" . l:context_text . "\n```"

    " Check if gptme is installed
    if !executable('gptme')
        echoerr "gptme executable not found. Please install gptme first."
        return
    endif

    " Build the command with proper shell escaping
    let l:cmd = 'gptme ' . shellescape(l:prompt)

    " Debug: Show command (optional)
    " echom "Command: " . l:cmd

    " Open terminal in a new window based on settings
    if g:gptme_terminal_position ==# 'vertical'
        execute 'vertical new | vertical resize ' . g:gptme_terminal_size
    else
        execute 'new | resize ' . g:gptme_terminal_size
    endif

    file gptme
    " Configure window appearance
    setlocal nonumber
    setlocal norelativenumber
    setlocal signcolumn=no
    setlocal winfixwidth
    setlocal winfixheight
    setlocal nofoldenable
    setlocal bufhidden=hide

    " Use appropriate terminal function based on Vim/Neovim
    if has('nvim')
        call termopen(l:cmd)
        " Auto-enter insert mode in terminal (Neovim)
        startinsert
    else
        call term_start(l:cmd, {'curwin': 1})
    endif
endfunction

" Map it to <Leader>g (usually \g) unless user disabled default mappings
if !exists('g:gptme_no_mappings')
    nnoremap <Leader>g :call <SID>gptme()<CR>
    " Add visual mode mapping
    vnoremap <Leader>g :call <SID>gptme()<CR>
endif

" Command interface (note the capital G)
command! -range Gptme <line1>,<line2>call <SID>gptme()
