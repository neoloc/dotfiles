vim.cmd([[
let g:previous_buffer = 0

function! FindFile()
    " Store the buffer number of the current window
    let g:previous_buffer = bufnr('%')

    " Prompt user for search pattern
    let pattern = input('Enter search pattern: ')
    let escaped_pattern = escape(pattern, '\/$.*[~')
    "let cmd = "grep -Rl " . escaped_pattern . " *"
    let cmd = "rg --column --no-heading --color=never -l " . shellescape(escaped_pattern)


    " Get the search results as a list
    let results = systemlist(cmd)
    if empty(results)
        echo "No files found for pattern: " . pattern
        return
    endif

    " Open a new split window at the bottom
    new
    " Set the height of the new split window
    resize 10

    " Set the buffer to be unlisted, no swapfile
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile

    " Clear the 'readonly' option in case it's set by default
    setlocal noreadonly

    " Populate the buffer with the search results
    call setline(1, results)

    " Make the buffer read-only after populating it
    setlocal readonly

    " Map keys to open files in different modes
    nnoremap <silent> <buffer> <CR> :call OpenFile('edit', g:previous_buffer)<CR>
    nnoremap <silent> <buffer> v :call OpenFile('vsplit', g:previous_buffer)<CR>
    nnoremap <silent> <buffer> h :call OpenFile('split', g:previous_buffer)<CR>
    nnoremap <silent> <buffer> t :call OpenFile('tabedit', g:previous_buffer)<CR>

    " Focus on the results window
    normal! G
endfunction

function! OpenFile(openType, bufnr)
    " Extract the file path from the current line
    let file_path = getline('.')
    if filereadable(file_path)
        " Save the current buffer number
        let current_bufnr = bufnr('%')
        " Close the search results window
        bd!
        " Switch to the buffer that was active before the search
        execute 'buffer' g:previous_buffer
        " Open the file based on the specified openType
        execute a:openType . ' ' . file_path
        " If opening in a new tab, switch back to the original buffer in the new tab
        if a:openType == 'tabnew'
            execute 'tabnext'
            execute 'buffer' . current_bufnr
        endif
    else
        echo "File does not exist or cannot be read"
    endif
endfunction

nnoremap <Leader>ff :call FindFile()<CR>
]])
