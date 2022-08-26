--[[ opts.lua ]]
--    vim.o: maps to vim.api.nvim_set_option; equivalent to :set.
--    vim.go: maps to vim.api.nvim_set_option; equivalent to :setglobal.
--    vim.bo; maps to vim.api.nvim_buf_set_option; equivalent to :setlocal for buffer options.
--    vim.wo: maps to vim.api.nvim_win_set_option; equivalent to :setlocal for window options.

local opt = vim.opt
local optg = vim.go
local optb = vim.bo
local optw = vim.wo
local cmd = vim.api.nvim_command

-- [[ Context ]]
-- opt.colorcolumn = '80'           -- str:  Show col for max line length
opt.number = true                -- bool: Show line numbers
opt.relativenumber = false       -- bool: Show relative line numbers
opt.scrolloff = 4                -- int:  Min num lines of context
opt.signcolumn = "yes"           -- str:  Show the sign column
opt.cursorline = true            -- bool: highlight current line
opt.cursorcolumn = true          -- boot: highlight current column

-- [[ Filetypes ]]
opt.encoding = 'utf8'            -- str:  String encoding to use
opt.fileencoding = 'utf8'        -- str:  File encoding to use

-- [[ Theme ]]
opt.syntax = "ON"                -- str:  Allow syntax highlighting
opt.termguicolors = true         -- bool: If term supports ui color then enable
cmd('colorscheme onedark')       -- cmd:  Set the colorscheme

-- [[ Search ]]
opt.ignorecase = true            -- bool: Ignore case in search patterns
opt.smartcase = true             -- bool: Override ignorecase if search contains capitals
opt.incsearch = true             -- bool: Use incremental search
opt.hlsearch = true              -- bool: Highlight search matches

-- [[ Whitespace ]]
opt.expandtab = true             -- bool: Use spaces instead of tabs
opt.shiftwidth = 2               -- num:  Size of an indent
opt.softtabstop = 2              -- num:  Number of spaces tabs count for in insert mode
opt.tabstop = 2                  -- num:  Number of spaces tabs count for
opt.autoindent = true            -- bool: enable auto-indent
opt.foldmethod = "indent"
opt.foldlevel = 99

-- [[ Splits ]]
opt.splitright = true            -- bool: Place new window to right of current one
opt.splitbelow = true            -- bool: Place new window below the current one

-- [[ Other ]]
opt.ruler = true
opt.complete = 'i'
opt.laststatus = 2               -- num:  show status line
opt.autoindent = true            -- bool: enable auto-indent
opt.backspace = "indent,eol,start" -- str:  backspace through anything in insert mode
opt.wildmenu = true
opt.maxmempattern = 5000         -- num:  increase memory used for pattern matching
opt.modelines = 5

-- highlighting
vim.cmd[[highlight Search ctermbg=LightYellow]]
vim.cmd[[highlight Search ctermfg=Red]]
vim.cmd[[highlight BadWhitespace ctermbg=red guibg=darkred]]

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
opt.completeopt = {'menuone', 'noselect', 'noinsert'}
opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- configure fterm
vim.api.nvim_create_user_command('FTermOpen', require('FTerm').open, { bang = true })
vim.api.nvim_create_user_command('FTermClose', require('FTerm').close, { bang = true })
vim.api.nvim_create_user_command('FTermExit', require('FTerm').exit, { bang = true })
vim.api.nvim_create_user_command('FTermToggle', require('FTerm').toggle, { bang = true })

local fterm = require("FTerm")
local gitui = fterm:new({
    ft = 'fterm_gitui',
    cmd = "gitui",
    dimensions = {
        height = 0.9,
        width = 0.9
    }
})

-- Use this to toggle gitui in a floating terminal
vim.keymap.set('n', '<A-g>', function()
    gitui:toggle()
end)
