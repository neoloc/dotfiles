-- FUNCTIONS --

-- all language functions
vim.cmd [[
  augroup lang_all
    autocmd!
    autocmd FileType * luafile ~/.config/nvim/lua/func/tabline.lua
  augroup END
]]

-- puppet language keybindings
vim.cmd [[
  augroup lang_puppet
      autocmd!
      autocmd FileType puppet nnoremap <buffer> <Leader>g :call OpenPuppetClassOrTemplate()<CR>
      autocmd FileType puppet nnoremap <buffer> <Leader>t :call OpenPuppetTestMode()<CR>
      autocmd BufNewFile site/roles/manifests/**.pp call ApplyPuppetTemplate()
      autocmd BufNewFile site/profiles/manifests/**.pp call ApplyPuppetTemplate()
  augroup END
]]

