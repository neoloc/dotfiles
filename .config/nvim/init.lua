--[[ init.lua ]]

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = "\\"
vim.g.localleader = "\\"

-- IMPORTS
require('vars')      -- Variables
require('opts')      -- Options
require('keys')      -- Keymaps
require('auto')      -- Automaps
require('plug')      -- Plugins

-- nvim-tree
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
    mappings = {
      list = {
        { key = "u", action = "dir_up" },
      },
    },
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
    custom = { "^.git$" },
  },
})

-- mason
require("mason").setup()

-- lspconfig
require('lspconfig')['pyright'].setup {
  on_attach = on_attach,
  flags = lsp_flags,
}
require('lspconfig')['ansiblels'].setup{}
require('lspconfig')['bashls'].setup{}
require('lspconfig')['sumneko_lua'].setup{
  settings = {
    Lua = {
      diagnostics = {
        globals = { 'vim', 'on_attach', 'lsp_flags'}
      }
    }
  }
}
require('lspconfig')['yamlls'].setup{
  settings = {
    yaml = {
      customTags = { '!vault'}
    }
  }
}
require('lspconfig')['intelephense'].setup{}
require('lspconfig')['grammarly'].setup{}
require('lspconfig')['terraformls'].setup{}

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = '??',
              vsnip = '???',
              buffer = '??',
              path = '????',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})

-- treesitter 
require('nvim-treesitter.configs').setup {
  ensure_installed = { "lua", "toml", "python", "bash", "yaml" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  }
}

-- fterm
require'FTerm'.setup({
  auto_close = true,
  border = 'double',
  dimensions  = {
    height = 0.7,
    width = 0.7,
  },
})

-- autopairs
require('nvim-autopairs').setup{} -- Add this line

-- lualine
require('lualine').setup {
  options = {
    theme = 'onedark',
    icons_enabled = true,
  }
}

-- onedark
require('onedark').load()
