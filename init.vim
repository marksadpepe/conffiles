set mouse=a  " enable mouse
set encoding=utf-8
set spell
set number
set cursorline
set ignorecase
set noswapfile
set scrolloff=7
set relativenumber

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix
filetype indent on      " load filetype-specific indent files
filetype plugin on

" for tabulation
set smartindent
set tabstop=2
set expandtab
set shiftwidth=2

" horizontal split open below and right
set splitbelow
set splitright

inoremap jk <esc>

call plug#begin('~/.vim/plugged')

Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'saadparwaiz1/cmp_luasnip'
Plug 'L3MON4D3/LuaSnip'
Plug 'lewis6991/gitsigns.nvim'
Plug 'folke/todo-comments.nvim'
Plug 'nvim-lua/plenary.nvim'

" color schemas
Plug 'morhetz/gruvbox'  " colorscheme gruvbox
Plug 'mhartington/oceanic-next'  " colorscheme OceanicNext
Plug 'kaicataldo/material.vim', { 'branch': 'main' }
Plug 'ayu-theme/ayu-vim'
Plug 'tjdevries/colorbuddy.nvim'

Plug 'xiyaowong/nvim-transparent'

Plug 'Pocco81/auto-save.nvim'
Plug 'justinmk/vim-sneak'

" Swift
Plug 'swiftlang/sourcekit-lsp'

" Ruby
Plug 'Shopify/ruby-lsp'

" nerdcommenter
Plug 'preservim/nerdcommenter'

" JS/JSX/TS
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'peitalin/vim-jsx-typescript'
Plug 'maxmellon/vim-jsx-pretty'
" TS from here https://jose-elias-alvarez.medium.com/configuring-neovims-lsp-client-for-typescript-development-5789d58ea9c
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'prettier/vim-prettier', {
  \ 'do': 'npm install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'typescriptreact', 'javascriptreact', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

Plug 'bmatcuk/stylelint-lsp'

Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.5' }
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" Convenient floating terminal window
"Plug 'voldikss/vim-floaterm'

Plug 'ray-x/lsp_signature.nvim'

Plug 'lspcontainers/lspcontainers.nvim'

call plug#end()

" Leader bind to space
let mapleader = ","

" Netrw file explorer settings
let g:netrw_banner = 0 " hide banner above files
let g:netrw_liststyle = 3 " tree instead of plain view
let g:netrw_browse_split = 3 " vertical split window when Enter pressed on file

" Automatically format frontend files with prettier after file save
"let g:prettier#autoformat = 1
"let g:prettier#autoformat_require_pragma = 0

" Disable quickfix window for prettier
:let g:prettier#quickfix_enabled = 0

" Turn on vim-sneak
let g:sneak#label = 1

" ---- nerdcommenter ----
" Create default mappings
let g:NERDCreateDefaultMappings = 1

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not
let g:NERDToggleCheckAllLines = 1

colorscheme gruvbox
" colorscheme OceanicNext
" colorscheme ayu
" colorscheme material
"let g:material_terminal_italics = 1
" variants: default, palenight, ocean, lighter, darker, default-community,
"           palenight-community, ocean-community, lighter-community,
"           darker-community
"let g:material_theme_style = 'darker'
"colorscheme material
if (has('termguicolors'))
  set termguicolors
endif

" variants: mirage, dark, dark
" let ayucolor="mirage"
" colorscheme ayu

" turn off search highlight
nnoremap ,<space> :nohlsearch<CR>

lua << EOF
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
vim.fn.sign_define('TodoSignBUG', {text = '🐞', texthl = 'ErrorMsg'})

-- luasnip setup
local luasnip = require 'luasnip'
local async = require "plenary.async"

-- todo-comments setup
local todo_comments = require 'todo-comments'
todo_comments.setup{
  signs = true,
  sign_priority = 8,
  keywords = {
    BUG = {
      icon = '🐞',
      color = '#d90209',
      alt = {'FIX', 'FIXME', 'FIXIT'}
    },
    TODO = {icon = '🖊', color = '#2563EB'},
    HACK = {icon = '🩼', color = '#e06a1b'},
    WARN = {
      icon = '🚧',
      color = '#dbc21a',
      alt = {'WARNING', 'XXX'}
    },
    PERF = {
      icon = '🛠',
      color = '#8c1aff',
      alt = {'OPTIMIZE', 'PERFOMANCE'}
    },
    NOTE = {
      icon = '📄',
      color = '#00b33c',
      alt = {'INFO'}
    }
  },
  highlight = {
    multiline = true, -- enable multine todo comments
    multiline_pattern = '^.', -- lua pattern to match the next multiline from the start of the matched keyword
    multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
    before = '', -- 'fg' or 'bg' or empty
    keyword = 'wide', -- 'fg', 'bg', 'wide', 'wide_bg', 'wide_fg' or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
    after = 'fg', -- 'fg' or 'bg' or empty
    pattern = [[.*<(KEYWORDS)\s*:]], -- pattern or table of patterns, used for highlighting (vim regex)
    comments_only = true, -- uses treesitter to match keywords in comments only
    max_line_len = 400, -- ignore lines longer than this
    exclude = {},
  },
  colors = {
    error = { 'DiagnosticError', 'ErrorMsg', '#d90209' },
    warning = { 'DiagnosticWarn', 'WarningMsg', '#FBBF24' },
    info = { 'DiagnosticInfo', '#2563EB' },
    hint = { 'DiagnosticHint', '#10B981' },
    default = { 'Identifier', '#7C3AED' },
    test = { 'Identifier', '#FF00FF' }
  },
  search = {
    command = 'rg',
    args = {
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
    },
    pattern = [[\b(KEYWORDS):]]
  }
}

-- IlyasYOY colorscheme
-- local colorbuddy = require 'colorbuddy'
-- local Color = colorbuddy.Color
-- local Group = colorbuddy.Group
-- local c = colorbuddy.colors
-- local g = colorbuddy.groups
-- local s = colorbuddy.styles
--
-- -- setup colors
-- local palette = {
--     { keys = { "red_light" }, gui = "#722529" },
--     { keys = { "red" }, gui = "#d75f5f" },
--
--     { keys = { "orange" }, gui = "#d7875f" },
--     { keys = { "brown" }, gui = "#af875f" },
--     { keys = { "brown_deep" }, gui = "#875f5f" },
--
--     { keys = { "green_deep" }, gui = "#5f875f" },
--     { keys = { "green" }, gui = "#49503b" },
--     { keys = { "green_light" }, gui = "#87af87" },
--
--     { keys = { "blue" }, gui = "#5f87af" },
--     { keys = { "blue_dark" }, gui = "#3b4050" },
--
--     { keys = { "pink" }, gui = "#d787af" },
--     { keys = { "purple" }, gui = "#8787af" },
--
--     -- Grayscale
--     { keys = { "white" }, gui = "#bcbcbc" },
--     { keys = { "grey" }, gui = "#949494" },
--     { keys = { "dark" }, gui = "#767676" },
--     { keys = { "darker" }, gui = "#585858" },
--     { keys = { "darkest" }, gui = "#444444" },
--     { keys = { "base" }, gui = "#262626" },
--     { keys = { "black" }, gui = "#1c1c1c" },
-- }
--
-- for _, value in ipairs(palette) do
--     for _, key in ipairs(value.keys) do
--         Color.new(key, value.gui)
--     end
-- end
--
-- -- EDITOR BASICS
-- -- https://neovim.io/doc/user/syntax.html#group-name
--
-- -- Custom groups
-- Group.new("Noise", c.dark, c.none, s.none)
--
-- -- Basic groups
-- Group.new("Comment", c.dark, c.none, s.none)
-- Group.new("Normal", c.white, c.none, s.none)
--
-- Group.new("NonText", c.darkest, c.none, s.none)
-- Group.new("Error", c.red, c.none, s.none)
-- Group.new("Number", c.green_light, c.none, s.none)
-- Group.new("Special", c.purple, c.none, s.none)
-- Group.new("String", c.green_deep, c.none, s.none)
-- Group.new("Title", c.blue, c.none, s.none)
-- Group.new("Todo", c.pink, c.none, s.none)
-- Group.new("Warning", c.orange, c.none, s.none)
--
-- -- https://neovim.io/doc/user/syntax.html#hl-User1
-- Group.new("User1", c.brown, c.none, s.none)
-- Group.new("User2", c.blue, c.none, s.none)
-- Group.new("User3", c.brown_deep, c.none, s.none)
--
-- -- diff
-- Group.new("Added", g.Normal, c.green, s.none)
-- Group.new("Changed", g.Normal, c.blue_dark, s.none)
-- Group.new("Removed", g.Normal, c.red_light, s.none)
--
-- -- search and highlight stuff
-- Group.new("MatchParen", c.Normal, c.none, s.underline)
--
-- Group.new("CurSearch", c.pink, c.none, s.underline)
-- Group.new("IncSearch", c.pink, c.none, s.none)
-- Group.new("Search", c.pink, c.none, s.none)
--
-- Group.new("Pmenu", c.darker, c.black, s.none)
-- Group.new("PmenuSel", c.grey, c.black, s.none)
-- Group.new("PmenuThumb", c.brown, c.black, s.none) -- not sure what this is
-- Group.new("WildMenu", c.pink, c.base, s.none)
--
-- Group.new("StatusLine", c.none, c.base, s.none)
-- Group.new("StatusLineNC", c.black, c.black, s.none)
--
-- Group.new("Visual", c.blue, c.base, s.none)
-- Group.new("VisualNOS", c.blue, c.base, s.none)
--
-- Group.new("qffilename", g.Title, g.Title, g.Title)
--
-- -- spelling problesm are shown!
-- Group.new("SpellBad", c.red, c.none, s.undercurl)
-- Group.new("SpellCap", c.orange, c.none, s.undercurl)
-- Group.new("SpellLocal", c.brown, c.none, s.undercurl)
-- Group.new("SpellRare", c.blue, c.none, s.undercurl)
--
-- -- LINKS
-- Group.link("Constant", g.Normal)
-- Group.link("Boolean", g.Number)
-- Group.link("Character", g.Number)
-- Group.link("Conditional", g.Normal)
-- Group.link("Debug", g.Todo)
-- Group.link("Delimiter", g.Normal)
-- Group.link("Directory", g.String)
-- Group.link("Exception", g.Normal)
-- Group.link("Function", g.Special)
-- Group.link("Identifier", g.Normal)
-- Group.link("Include", g.Normal)
-- Group.link("Keyword", g.Noise)
-- Group.new("Label", g.Normal, g.Normal, g.Normal + s.bold)
-- Group.link("Macro", g.User2)
-- Group.link("Operator", g.Noise)
-- Group.link("PreProc", g.Normal)
-- Group.link("Repeat", g.Normal)
-- Group.link("SpecialChar", g.Special)
-- Group.link("SpecialKey", g.Special)
-- Group.link("Statement", g.Normal)
-- Group.link("StorageClass", g.Normal)
-- Group.link("Structure", g.Normal)
-- Group.link("Tag", g.Normal)
-- Group.link("Type", g.User3)
-- Group.link("TypeDef", g.User3)
--
-- -- Diagnostics
-- Group.new(
--     "DiagnosticUnderlineError",
--     c.none,
--     c.none,
--     s.underline,
--     c.red
-- )
-- Group.new(
--     "DiagnosticUnderlineWarn",
--     c.none,
--     c.none,
--     s.underline,
--     c.orange
-- )
-- Group.new("DiagnosticUnderlineHint", c.none, c.none, s.underline)
-- Group.new("DiagnosticUnderlineInfo", c.none, c.none, s.underline)
-- Group.link("DiagnosticError", g.Error)
-- Group.link("DiagnosticWarn", g.Warning)
-- Group.link("DiagnosticHint", g.Comment)
-- Group.link("DiagnosticInfo", g.Comment)
-- Group.link("DiagnosticOk", g.String)
--
-- -- GitSigns
-- Group.new("GitSignsAdd", c.green_light, c.none, s.none)
-- Group.new("GitSignsChange", c.orange, c.none, s.none)
-- Group.new("GitSignsDelete", c.red, c.none, s.none)
--
-- -- Telescope
-- Group.link("TelescopeBorder", g.Noise)
-- Group.link("TelescopeMatching", g.User1)
-- Group.link("TelescopePromptCounter", g.Noise)



-- gitsigns setup
local gitsigns = require 'gitsigns'
gitsigns.setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  --current_line_blame_formatter_opts = {
  --  relative_time = false,
  --},
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}

-- nvim-cmp setup
local cmp = require 'cmp'
cmp.setup {
  completion = {
    autocomplete = false
  },
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-n>', true, true, true), 'n')
      elseif luasnip.expand_or_jumpable() then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
      else
        fallback()
      end
    end,
    ['<S-Tab>'] = function(fallback)
      if vim.fn.pumvisible() == 1 then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-p>', true, true, true), 'n')
      elseif luasnip.jumpable(-1) then
        vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
      else
        fallback()
      end
    end,
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>tab split | lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>tab split | lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

  require "lsp_signature".on_attach({
      bind = true, -- This is mandatory, otherwise border config won't get registered.
      floating_window = true,
      floating_window_above_cur_line = true,
      floating_window_off_x = 20,
      doc_lines = 10,
      hint_prefix = '🤡 '
    }, bufnr)  -- Note: add in lsp client on-attach
end

-- Swift setup
nvim_lsp.sourcekit.setup({
  root_dir = function() return vim.loop.cwd() end
})

-- Golang setup
nvim_lsp.gopls.setup({})

-- C/C++ setup
nvim_lsp.clangd.setup({
  cmd = {'clangd-12', '--background-index', '--clang-tidy', '--log=verbose'},
  init_options = {
    fallbackFlags = { '-std=c++17', '-std=c11' },
  },
})

-- TS setup
local buf_map = function(bufnr, mode, lhs, rhs, opts)
    vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, opts or {
        silent = true,
    })
end

nvim_lsp.ts_ls.setup({
    on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = false
        client.server_capabilities.document_range_formatting = false

        buf_map(bufnr, "n", "<C-i>", "", {
          noremap = true,
          silent = true,
          callback = function()
            inlay_enabled = not inlay_enabled
            if inlay_enabled then
              vim.lsp.inlay_hint.enable(true)
            else
              vim.lsp.inlay_hint.enable(false)
            end
          end

        })

        local ts_utils = require("nvim-lsp-ts-utils")
        ts_utils.setup({})
        ts_utils.setup_client(client)
        buf_map(bufnr, "n", "gs", ":TSLspOrganize<CR>")
        buf_map(bufnr, "n", "gi", ":TSLspRenameFile<CR>")
        buf_map(bufnr, "n", "go", ":TSLspImportAll<CR>")
        on_attach(client, bufnr)
    end,
    init_options = {
      preferences = {
        includeInlayParameterNameHints = "all",  -- Показывать все подсказки
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
})

-- Ruby setup
--nvim_lsp.ruby_lsp.setup({
--    init_options = {
--        formatter = 'standard',
--        linters = { 'standard' },
--    },
--})

--local null_ls = require("null-ls")
--null_ls.setup({
--    sources = {
--        null_ls.builtins.diagnostics.eslint,
--        null_ls.builtins.code_actions.eslint,
--        null_ls.builtins.formatting.prettier
--    },
--    on_attach = on_attach
--})

-- Stylelint format after save
require'lspconfig'.stylelint_lsp.setup{
  settings = {
    stylelintplus = {
      --autoFixOnSave = true,
      --autoFixOnFormat = true,
    }
  }
}


-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF

" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
  finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
  let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
  if empty(a:buffer)
    let btarget = bufnr('%')
  elseif a:buffer =~ '^\d\+$'
    let btarget = bufnr(str2nr(a:buffer))
  else
    let btarget = bufnr(a:buffer)
  endif
  if btarget < 0
    call s:Warn('No matching buffer for '.a:buffer)
    return
  endif
  if empty(a:bang) && getbufvar(btarget, '&modified')
    call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
    return
  endif
  " Numbers of windows that view target buffer which we will delete.
  let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
  if !g:bclose_multiple && len(wnums) > 1
    call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
    return
  endif
  let wcurrent = winnr()
  for w in wnums
    execute w.'wincmd w'
    let prevbuf = bufnr('#')
    if prevbuf > 0 && buflisted(prevbuf) && prevbuf != btarget
      buffer #
    else
      bprevious
    endif
    if btarget == bufnr('%')
      " Numbers of listed buffers which are not the target to be deleted.
      let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val != btarget')
      " Listed, not target, and not displayed.
      let bhidden = filter(eopy(blisted), 'bufwinnr(v:val) < 0')
      " Take the first buffer, if any (could be more intelligent).
      let bjump = (bhidden + blisted + [-1])[0]
      if bjump > 0
        execute 'buffer '.bjump
      else
        execute 'enew'.a:bang
      endif
    endif
  endfor
  execute 'bdelete'.a:bang.' '.btarget
  execute wcurrent.'wincmd w'
endfunction
command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose(<q-bang>, <q-args>)
nnoremap <silent> <Leader>bd :Bclose<CR>

map gn :bn<cr>
map gp :bp<cr>
map gw :Bclose<cr>

" Run Python and C files by Ctrl+h
autocmd FileType python map <buffer> <C-h> :w<CR>:exec '!python3.11' shellescape(@%, 1)<CR>
autocmd FileType python imap <buffer> <C-h> <esc>:w<CR>:exec '!python3.11' shellescape(@%, 1)<CR>

autocmd FileType c map <buffer> <C-h> :w<CR>:exec '!gcc' shellescape(@%, 1) '-o out; ./out'<CR>
autocmd FileType c imap <buffer> <C-h> <esc>:w<CR>:exec '!gcc' shellescape(@%, 1) '-o out; ./out'<CR>

autocmd FileType go map <buffer> <C-h> :w<CR>:exec '!go run' shellescape(@%, 1)<CR>
autocmd FileType go imap <buffer> <C-h> <esc>:w<CR>:exec '!go run' shellescape(@%, 1)<CR>

autocmd FileType sh map <buffer> <C-h> :w<CR>:exec '!bash' shellescape(@%, 1)<CR>
autocmd FileType sh imap <buffer> <C-h> <esc>:w<CR>:exec '!bash' shellescape(@%, 1)<CR>

autocmd FileType python set colorcolumn=88

autocmd BufReadPost,BufWritePost *.json execute '%!jq .' | set filetype=json

" set relativenumber
" set rnu

let g:transparent_enabled = v:true

tnoremap <Esc> <C-\><C-n>

" Telescope bindings
" nnoremap ,f <cmd>Telescope find_files<cr>
nnoremap ,g <cmd>Telescope live_grep<cr>

" Go to next or prev tab by H and L accordingly
nnoremap H gT
nnoremap L gt

" Autosave plugin

lua << EOF
require("auto-save").setup(
    {
    }
)
EOF

" Telescope fzf plugin
lua << EOF
require('telescope').load_extension('fzf')
EOF

" Telescope create/open a file
lua << EOF
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values

function create_new_file(prompt_bufnr)
  local current_picker = action_state.get_current_picker(prompt_bufnr)
  local file_name = current_picker:_get_prompt()
  
  actions.close(prompt_bufnr)
  
  if not file_name or file_name == "" then
    print("File is not specified")
    return
  end
  
  local full_path = vim.fn.getcwd() .. "/" .. file_name
  
  if vim.fn.filereadable(full_path) == 0 then
    local create_command = "touch " .. vim.fn.shellescape(full_path)
    vim.fn.system(create_command)
    print("File created: " .. file_name)
  else
    print("File opened: " .. file_name)
  end
  
  vim.cmd("tabnew " .. vim.fn.fnameescape(full_path))
end

function FileCreationSelection(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  
  if selection then
    actions.close(prompt_bufnr)
    vim.cmd("tabnew " .. vim.fn.fnameescape(selection.value))
  else
    create_new_file(prompt_bufnr)
  end
end

function OpenTelescopeForFileCreation()
  pickers.new({}, {
    prompt_title = 'Create/open a file',
    finder = finders.new_table({
      results = vim.fn.glob('**/*', false, true),
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry,
          ordinal = entry
        }
      end
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      map('i', '<CR>', function()
        FileCreationSelection(prompt_bufnr)
      end)
      map('n', '<CR>', function()
        FileCreationSelection(prompt_bufnr)
      end)
      
      map('i', '<C-c>', function()
        create_new_file(prompt_bufnr)
      end)
      map('n', '<C-c>', function()
        create_new_file(prompt_bufnr)
      end)
      
      return true
    end
  }):find()
end
EOF

nnoremap <leader>f :lua OpenTelescopeForFileCreation()<CR>
" White colors for LSP messages in code
set termguicolors
hi DiagnosticError guifg=Red
hi DiagnosticWarn  guifg=White
hi DiagnosticInfo  guifg=White
hi DiagnosticHint  guifg=White

set colorcolumn=88
