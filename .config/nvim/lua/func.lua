-- FUNCTIONS --

-- puppet language functions
vim.cmd [[
  augroup lang_all
    autocmd!
    autocmd FileType * luafile ~/.config/nvim/lua/func/tabline.lua
  augroup END
]]

-- puppet language functions
vim.cmd [[
  augroup lang_puppet
    autocmd!
    autocmd FileType puppet luafile ~/.config/nvim/lua/func/puppet.lua
  augroup END
]]

