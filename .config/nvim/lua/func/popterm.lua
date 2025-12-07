-- Popterm configuration with named terminals support
vim.cmd([[
  " nvim-only config
  if has('nvim')

    " Global dictionaries to track terminal windows and buffers by name
    let g:popterm_windows = {}
    let g:popterm_buffers = {}
    let g:popterm_current_win = -1

    function! ToggleNamedPopterm(name, command)
      " Check if this named terminal window exists and is valid
      if has_key(g:popterm_windows, a:name) && g:popterm_windows[a:name] != -1 && nvim_win_is_valid(g:popterm_windows[a:name])
        " Close the terminal window
        call nvim_win_close(g:popterm_windows[a:name], v:false)
        let g:popterm_windows[a:name] = -1
        let g:popterm_current_win = -1
        return
      endif

      " Close any other open popterm window first
      for [term_name, win_id] in items(g:popterm_windows)
        if win_id != -1 && nvim_win_is_valid(win_id)
          call nvim_win_close(win_id, v:false)
          let g:popterm_windows[term_name] = -1
        endif
      endfor

      " Calculate the desired width and height as 80% of the current window size
      let height = float2nr((&lines * 0.8) / 1)
      let width = float2nr((&columns * 0.8) / 1)

      " Calculate the top and left positions to center the terminal
      let top = float2nr((&lines - height) / 2)
      let left = float2nr((&columns - width) / 2)

      " Define options for the floating window with border
      let opts = {
        \ 'relative': 'editor',
        \ 'row': top,
        \ 'col': left,
        \ 'width': width,
        \ 'height': height,
        \ 'style': 'minimal',
        \ 'border': 'rounded',
        \ 'title': ' ' . a:name . ' ',
        \ 'title_pos': 'center'
        \ }

      " Reuse existing buffer for this terminal or create new one
      if !has_key(g:popterm_buffers, a:name) || g:popterm_buffers[a:name] == -1 || !nvim_buf_is_valid(g:popterm_buffers[a:name])
        let g:popterm_buffers[a:name] = nvim_create_buf(v:false, v:true)
      endif

      " Open a new window with the terminal buffer
      let g:popterm_windows[a:name] = nvim_open_win(g:popterm_buffers[a:name], v:true, opts)
      let g:popterm_current_win = g:popterm_windows[a:name]

      " Start terminal if buffer is empty or hasn't been initialized
      let buffer_lines = nvim_buf_get_lines(g:popterm_buffers[a:name], 0, -1, v:false)
      if empty(buffer_lines) || (len(buffer_lines) == 1 && buffer_lines[0] == '')
        if a:command != ''
          call termopen(a:command, {'buffer': g:popterm_buffers[a:name]})
        else
          call termopen($SHELL, {'buffer': g:popterm_buffers[a:name]})
        endif
      endif

      " Set terminal-specific key mappings for this terminal
      execute 'tnoremap <buffer> <leader>T <C-\><C-n>:call ToggleNamedPopterm("' . a:name . '", "' . a:command . '")<CR>'
      execute 'tnoremap <buffer> <leader>a <C-\><C-n>:call ToggleNamedPopterm("claude", "claude")<CR>'

      " Enter insert mode
      startinsert
    endfunction

    " Wrapper functions for specific terminals
    function! TogglePopterm()
      call ToggleNamedPopterm('general', '')
    endfunction

    function! ToggleClaudePopterm()
      call ToggleNamedPopterm('claude', 'claude')
    endfunction

    " Define commands
    highlight Terminal guibg=#000000 guifg=none
    command! Popterm call TogglePopterm()
    command! ClaudePopterm call ToggleClaudePopterm()

    " Key mappings
    nnoremap T :Popterm<CR>
    nnoremap <S-t> :Popterm<CR>
    nnoremap <leader>a :ClaudePopterm<CR>

  endif
]])
