--[[ keys.lua ]]
--
-- This function takes in four parameters:
--
--  mode: the mode you want the key bind to apply to (e.g., insert mode, normal mode, command mode, visual mode).
--  sequence: the sequence of keys to press.
--  command: the command you want the keypresses to execute.
--  options: an optional Lua table of options to configure (e.g., silent or noremap).

local map = vim.api.nvim_set_keymap

-- remap the key used to leave insert mode
map('i', 'jk', '', {})

-- swap between split windows
map('n', '<a-up>', ':wincmd k<cr>', {})
map('n', '<a-down>', ':wincmd j<cr>', {})
map('n', '<a-left>', ':wincmd h<cr>', {})
map('n', '<a-right>', ':wincmd l<cr>', {})

-- switch to tab
for i = 1, 9 do
  map('n', '<A-'..i..'>', ':tabn '..i..'<CR>', {noremap = true, silent = true})
end

-- rewrite tabs to spaces
map('' ,'<F2>' ,'%retab!' , {})

-- press 'enter' after searching to clear highlighting until the next search
map('n', '<CR>', ':noh<CR><CR>', {noremap = true})

-- copy/paste between vim instances
map('v' ,'<leader>y' ,':w! ~/.cache/nvim/vitmp<CR>' , {})
map('n' ,'<leader>p' ,':r ~/.cache/nvim/vitmp<CR>' , {})

-- save as sudo
map('c', 'w!!', ':w !sudo tee > /dev/null %', {})

-- quickly edit/reload this configuration file
map('n', 'gev', ':e $MYVIMRC<CR>', {noremap = true})
map('n', 'gsv', ':so $MYVIMRC<CR>', {noremap = true})

-- plugin mappings
map('', '<C-n>', ':NvimTreeToggle<CR>', {})
map('n', 'l', ':IndentLinesToggle<CR>', {})
map('n', 't', ':TagbarToggle<CR>', {})
map('n', 'ff', [[:Telescope find_files]], {})
-- map('n', 'T', ':lua require("FTerm").toggle()<CR>', {})

-- Open a file in a vertical split, horizontal split and move a split to a new tab
map('n', '<Leader>ov', ':vsplit ', {noremap = true, silent = false})
map('n', '<Leader>oh', ':split ', {noremap = true, silent = false})
map('n', '<Leader>mt', ':tabedit %<CR>', {noremap = true, silent = true})
