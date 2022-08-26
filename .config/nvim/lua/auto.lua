--[[ auto.lua ]]

-- run PackerInstall when plugins file saved
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plug.lua source <afile> | PackerInstall
  augroup end
]])
