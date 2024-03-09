-- FUNCTIONS --

-- all language functions
vim.cmd [[
  augroup lang_all
    autocmd!
    autocmd FileType * luafile ~/.config/nvim/lua/func/utils.lua
    autocmd FileType * luafile ~/.config/nvim/lua/func/tabline.lua
    autocmd FileType * luafile ~/.config/nvim/lua/func/popterm.lua
    autocmd FileType * luafile ~/.config/nvim/lua/func/sessions.lua
  augroup END
]]

-- puppet language keybindings
vim.cmd [[
  augroup lang_puppet
      autocmd!
      autocmd FileType puppet nnoremap <buffer> <Leader>gg :call OpenPuppetClassOrTemplate(tab)<CR>
      autocmd FileType puppet nnoremap <buffer> <Leader>gt :call OpenPuppetClassOrTemplate(tab)<CR>
      autocmd FileType puppet nnoremap <buffer> <Leader>gh :call OpenPuppetClassOrTemplate(horizontal)<CR>
      autocmd FileType puppet nnoremap <buffer> <Leader>gv :call OpenPuppetClassOrTemplate(vertical)<CR>
      autocmd FileType puppet nnoremap <buffer> <Leader>t :call OpenPuppetTestMode()<CR>
      autocmd BufNewFile site/roles/manifests/**.pp call ApplyPuppetTemplate()
      autocmd BufNewFile site/profiles/manifests/**.pp call ApplyPuppetTemplate()
  augroup END
]]

