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
function! OpenPuppetProfileOrRole(layout)

  " Get the line under the cursor
  let line = getline(".")

  " Use a regex to find the full class name
  let classname = tolower(matchstr(line, '\v\w+(\:\:\w+)+'))

  " Initialize an empty variable for the directory
  let dirpath = ""

  " List modules in puppet-control here
  let module_list = []
  call add(module_list, 'certbot')
  call add(module_list, 'glauth')
  call add(module_list, 'jellyfin')
  call add(module_list, 'lidarr')
  call add(module_list, 'networking')
  call add(module_list, 'nzbget')
  call add(module_list, 'prowlarr')
  call add(module_list, 'radarr')
  call add(module_list, 'readarr')
  call add(module_list, 'redisha')
  call add(module_list, 'sonarr')

  " Check if the class name starts with 'profiles::' or 'roles::'
  if classname =~ '^profiles::'
    let dirpath = "site/profiles/manifests/"
    let classname = substitute(classname, 'profiles::', '', '')
  elseif classname =~ '^roles::'
    let dirpath = "site/roles/manifests/"
    let classname = substitute(classname, 'roles::', '', '')
  else
    let matched = 0
    for module in module_list
      if classname =~ '^' . module . '::'
        let dirpath = "modules/" . module . "/manifests/"
        let parts = split(classname, '::')
        if len(parts) > 1
          let classname = join(parts[1:], '::')
        else
          let classname = 'init'
        endif
        let matched = 1
        break
      endif
    endfor
    if matched == 0
      if classname =~ '::'
        echo "Unknown module"
        return
      else
        echo "Unknown class prefix, should be profiles:: or roles::, or be a listed module."
        return
      endif
    endif
  endif

  " Replace :: with / to convert class name to file path
  let filepath = substitute(classname, '::', '/', 'g')

  " Create the full file path
  let fullpath = dirpath . filepath . ".pp"

  " Open the file in a new tab
  if a:layout == 'horizontal'
    execute 'split ' . fullpath
  elseif a:layout == 'vertical'
    execute 'vsplit ' . fullpath
  elseif a:layout == 'tab'
    execute 'tabedit ' . fullpath
  else
    echo "Invalid layout specified."
  endif
endfunction
]])

vim.cmd([[
function! OpenPuppetProfileOrRoleOriginal(layout)

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
  if a:layout == 'horizontal'
    execute 'split ' . fullpath
  elseif a:layout == 'vertical'
    execute 'vsplit ' . fullpath
  elseif a:layout == 'tab'
    execute 'tabedit ' . fullpath
  else
    echo "Invalid layout specified."
  endif
endfunction
]])

-- follow links to templates
vim.cmd([[
function! OpenPuppetTemplate(layout)

  " Get the line under the cursor
  let line = getline(".")

  " Use regex to find the full template name (erb or epp)
  let template = matchstr(line, 'profiles\/.*\.\(erb\|epp\)')

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
  if a:layout == 'horizontal'
    execute 'split ' . fullpath
  elseif a:layout == 'vertical'
    execute 'vsplit ' . fullpath
  elseif a:layout == 'tab'
    execute 'tabedit ' . fullpath
  else
    echo "Invalid layout specified."
  endif
endfunction
]])

-- open puppet resource
vim.cmd([[
function! OpenPuppetClassOrTemplate(layout)
  " Get the line under the cursor
  let line = getline(".")

  " Check if it's a template (erb or epp)
  if line =~ 'profiles\/.*\.\(erb\|epp\)'
    call OpenPuppetTemplate(a:layout)
    return
  endif

  " Check if it's an included class (profiles:: or roles::)
  if line =~ '::'
    call OpenPuppetProfileOrRole(a:layout)
    return
  endif

  " If none of the above, show an error message
  echo "Unrecognized puppet resource."
endfunction
]])


vim.cmd([[
function! GeneratePuppetClassName()
  " get the full file path
  let l:filepath = expand('%:p')

  " check if the file path ends with the desired patterns
  if l:filepath =~ 'site/roles/manifests/.\+\.pp$' || l:filepath =~ 'site/profiles/manifests/.\+\.pp$'
    " extract the part of the path after 'manifests/'
    let l:manifest_path = matchstr(l:filepath, 'manifests/.\+\.pp$')
    " remove 'manifests/' and '.pp' to get the class path
    let l:class_path = substitute(l:manifest_path, 'manifests/\(.\+\)\.pp', '\1', '')

    " replace slashes with double colons to form the class name
    let l:class_name = substitute(l:class_path, '/', '::', 'g')

    " detect if it is a role or profile based on the path
    let l:type = l:filepath =~ 'site/roles/manifests/' ? 'roles' : 'profiles'

    " return the generated class name with the type prefix
    return l:type . '::' . l:class_name
  endif

  " if the file path doesn't match the pattern, return an empty string
  return ''
endfunction
]])

vim.cmd([[
function! ApplyPuppetTemplate()
  " Generate the class name based on the file path
  let l:class_name = GeneratePuppetClassName()

  " If a class name was successfully generated
  if l:class_name != ''
    " Determine the template based on class name pattern
    if l:class_name =~ '^profiles::exports::'
      let l:template = '$HOME/.config/nvim/templates/puppet/export.pp'
    else
      let l:template = '$HOME/.config/nvim/templates/puppet/newclass.pp'
    endif

    " Read the appropriate template content
    execute '0r ' . l:template

    " Substitute the placeholder with the class name
    execute "1,\$s/%CLASS_NAME%/" . l:class_name . "/g"
  endif
endfunction
]])

vim.cmd([[
function! ToggleERBSyntax()
    if !exists('b:original_syntax')
        " If b:original_syntax is not set, default to eruby and store the current syntax
        let b:original_syntax = &filetype
        setlocal syntax=eruby
    else
        " If b:original_syntax is set, toggle the syntax based on the current setting
        if &syntax == 'eruby'
            " Extract the base file type from the file name
            let l:filename = expand('%:t')
            let l:base_filetype = matchstr(l:filename, '\v%(\.\w+)?\.erb$')
            let l:base_filetype = substitute(l:base_filetype, '\.erb$', '', '')
            let l:base_filetype = substitute(l:base_filetype, '^.', '', '')

            " Determine the syntax based on the base file type
            if l:base_filetype == 'sh'
                setlocal syntax=sh
            elseif l:base_filetype == 'py'
                setlocal syntax=python
            elseif l:base_filetype == 'pl'
                setlocal syntax=perl
            elseif l:base_filetype == 'yml' || l:base_filetype == 'yaml'
                setlocal syntax=yaml
            else
                " Attempt to guess the syntax from the shebang if unknown
                let l:firstline = getline(1)
                if l:firstline =~# '^#!.*\/bash'
                    setlocal syntax=sh
                elseif l:firstline =~# '^#!.*\/zsh'
                    setlocal syntax=sh
                elseif l:firstline =~# '^#!.*\/python'
                    setlocal syntax=python
                elseif l:firstline =~# '^#!.*\/perl'
                    setlocal syntax=perl
                else
                    " Fallback to eruby syntax if no known type is found
                    echo "Could not swap syntax highlighter; falling back to eruby."
                endif
            endif
        else
            " If the current syntax is not eruby, revert to the original syntax
            setlocal syntax=eruby
            echo "Switched back to eruby syntax."
        endif
        " Reset b:original_syntax to indicate the syntax has been toggled back
        unlet b:original_syntax
    endif
endfunction
]])

