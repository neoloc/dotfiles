-- puppet functions
--
--

-- enter testmode
vim.cmd([[
function! OpenPuppetTestMode()
  echo "Test mode active."
  echo "Keybindings:"
  echo "    v - puppet-validate"
  echo "    l - puppet-lint"
  echo "    q - quit test mode"
  
  " Keybinding to run tests on the current buffer
  nnoremap <buffer> v :!/usr/local/bin/puppet-validate %<CR>
  nnoremap <buffer> l :!/usr/local/bin/puppet-lint %<CR>

  " Keybinding to quit test mode
  let keys_to_exit = ['q', ':', 'i', 'a', 'c', 'r', 'w', '<ESC>']
  for key in keys_to_exit
    execute "silent! nnoremap <buffer> " . key . " :call LeavePuppetTestMode()<CR>"
  endfor
endfunction

function! LeavePuppetTestMode()
  " Unmap the keybindings we defined for test mode
  let keys_to_exit = ['l', 'v', 'q', ':', 'i', 'a', 'c', 'r', 'w', '<ESC>']
  for key in keys_to_exit
    execute "silent! unmap <buffer> " . key
  endfor

  echo "Test Mode Exited!"
endfunction
]])

-- follow links to classes
vim.cmd([[
function! OpenPuppetClass()

  " Get the line under the cursor
  let line = getline(".")

  " Use a regex to find the full class name
  let classname = tolower(matchstr(line, '\v\w+(\:\:\w+)+'))

  " Initialize an empty variable for the directory
  let dirpath = ""

  " Check if the class name starts with 'profiles::' or 'roles::'
  if classname =~ '^profiles::'
    let dirpath = "site/profiles/manifests/"
    let classname = substitute(classname, 'profiles::', '', '')
  elseif classname =~ '^roles::'
    let dirpath = "site/roles/manifests/"
    let classname = substitute(classname, 'roles::', '', '')
  else
    echo "Unknown class prefix, should be profiles:: or roles::"
    return
  endif

  " Replace :: with / to convert class name to file path
  let filepath = substitute(classname, '::', '/', 'g')

  " Create the full file path
  let fullpath = dirpath . filepath . ".pp"

  " Open the file in a new tab
  execute "tabedit " . fullpath

endfunction
]])

-- follow links to templates
vim.cmd([[
function! OpenPuppetTemplate()

  " Get the line under the cursor
  let line = getline(".")

  " Use regex to find the full template name
  let template = matchstr(line, 'profiles\/.*\.erb')

  " Initialize an empty variable for the new directory path
  let newpath = ""

  " Check if the template name starts with 'profiles/'
  if template =~ '^profiles\/'
    let newpath = substitute(template, '^profiles/', 'site/profiles/templates/', '')
  else
    echo "Unknown template prefix, should be profiles/, line is: " . template
    return
  endif

  " Create the full file path
  let fullpath = newpath

  " Open the file in a new tab
  execute "tabedit " . fullpath

endfunction
]])

-- keybindings
vim.cmd([[
nnoremap <Leader>g :call OpenPuppetClass()<CR>
nnoremap <Leader>h :call OpenPuppetTemplate()<CR>
nnoremap <Leader>t :call OpenPuppetTestMode()<CR>
]])
