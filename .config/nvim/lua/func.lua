-- FUNCTIONS --

-- all language functions
require('func.utils')
require('func.tabline')
require('func.popterm')
require('func.sessions')
require('func.findfile')

--  vim.cmd [[
--    augroup lang_all
--      autocmd!
--      autocmd FileType * luafile ~/.config/nvim/lua/func/utils.lua
--      autocmd FileType * luafile ~/.config/nvim/lua/func/tabline.lua
--      autocmd FileType * luafile ~/.config/nvim/lua/func/popterm.lua
--      autocmd FileType * luafile ~/.config/nvim/lua/func/sessions.lua
--      autocmd FileType * luafile ~/.config/nvim/lua/func/findfile.lua
--    augroup END
--  ]]

-- puppet language keybindings
vim.cmd [[
  augroup lang_puppet
      autocmd!
      autocmd FileType puppet nnoremap <buffer> <Leader>gg :call OpenPuppetClassOrTemplate('tab')<CR>
      autocmd FileType puppet nnoremap <buffer> <Leader>gt :call OpenPuppetClassOrTemplate('tab')<CR>
      autocmd FileType puppet nnoremap <buffer> <Leader>gh :call OpenPuppetClassOrTemplate('horizontal')<CR>
      autocmd FileType puppet nnoremap <buffer> <Leader>gv :call OpenPuppetClassOrTemplate('vertical')<CR>
      autocmd FileType puppet nnoremap <buffer> <Leader>t :call OpenPuppetTestMode()<CR>
      autocmd BufNewFile site/roles/manifests/**.pp call ApplyPuppetTemplate()
      autocmd BufNewFile site/profiles/manifests/**.pp call ApplyPuppetTemplate()
  augroup END
]]

-- erb/eruby language keybindings
vim.cmd [[
  augroup lang_eruby
      autocmd!
      autocmd FileType eruby nnoremap <buffer> <Leader>s :call ToggleERBSyntax()<CR>
  augroup END
]]


-- terraform language keybindings
vim.cmd [[
  augroup lang_terraform
      autocmd!
      autocmd BufNewFile,BufRead *.tf set filetype=terraform
  augroup END
]]

-- tmpl language keybindings
vim.cmd [[
  augroup lang_tmpl
      autocmd!
      autocmd BufNewFile,BufRead *.yml.tmpl set filetype=yaml
      autocmd BufNewFile,BufRead *.yaml.tmpl set filetype=yaml
      autocmd BufNewFile,BufRead *.hcl.tmpl set filetype=hcl
  augroup END
]]
