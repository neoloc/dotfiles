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

-- movement mappings
map('', '<C-t><up>', 'tabr<cr>', {})
map('', '<C-t><down>', 'tabl<cr>', {})
map('', '<C-t><left>', 'tabp<cr>', {})
map('', '<C-t><right>', 'tabn<cr>', {})

-- swap between split windows
map('n', '<A-Up>', ':wincmd k<CR>', {})
map('n', '<A-Down>', ':wincmd j<CR>', {})
map('n', '<A-Left>', ':wincmd h<CR>', {})
map('n', '<A-Right>', ':wincmd l<CR>', {})

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
map('n', 'T', ':lua require("FTerm").toggle()<CR>', {})
