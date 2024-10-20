local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function (client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the avaible actions
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

require('mason').setup({
  ui = {
    border = 'rounded'
  }
})

require('mason-lspconfig').setup({
  ensure_installed = {},
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup({})
    end,

    jdtls = lsp_zero.noop,
  }
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    -- `Enter` key to confirm completion
    ['<Cr>'] = cmp.mapping.confirm({ select = false }),

    -- `Ctrl+Space` to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  }
})

vim.diagnostic.config({
  float = {
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    source = 'if_many',
    header = '',
    prefix = '',
  }
})

local signs = {
  Error = '\u{f057} ',
  Warn = '\u{f071} ',
  Hint = '\u{f06a} ',
  Info = '\u{f05a} '
}

for type, icon in pairs(signs) do
  local hl = 'DiagnosticSign' .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = '' })
end

