-- FUNCTIONS --

-- puppet language functions
vim.cmd [[
  augroup lang_puppet
    autocmd!
    autocmd FileType puppet luafile ~/.config/nvim/lua/func/puppet.lua
  augroup END
]]

