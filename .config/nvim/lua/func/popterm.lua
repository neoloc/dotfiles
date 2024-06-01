-- enter testmode
vim.cmd([[
  " nvim-only config
  if has('nvim')

    function! OpenCenteredTerminal()
      " Calculate the desired width and height as 80% of the current window size
      let height = float2nr((&lines * 0.8) / 1)
      let width = float2nr((&columns * 0.8) / 1)

      " Calculate the top and left positions to center the terminal
      let top = float2nr((&lines - height) / 2)
      let left = float2nr((&columns - width) / 2)

      " Define options for the floating window, including its size and position
      let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

      " Create a new buffer for the terminal, set it to not listed and with no swapfile
      let buf = nvim_create_buf(v:false, v:true)

      " Open a new window with the terminal buffer, applying the specified options
      call nvim_open_win(buf, v:true, opts)

      " Run the default shell in the terminal
      call termopen($SHELL)

      " Adjust the focus to the newly opened terminal window
      startinsert
    endfunction

    " Define the :Popterm command to open the centered terminal
    highlight Terminal guibg=#000000 guifg=none
    "autocmd TermOpen * setlocal winhighlight=Normal:Terminal
    command! Popterm call OpenCenteredTerminal()
    nnoremap T :Popterm<CR>

  endif
]])
