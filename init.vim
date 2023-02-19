"_  _ _   _    _  _ _  _ _ _  _  _  _ _ _  _ 
"|\/|  \_/     |\ | |  | | |\/|  |  | | |\/| 
"|  |   |      | \|  \/  | |  | . \/  | |  | 



" {{{ config

set cursorline
set number
set mouse=a
syntax enable
set encoding=UTF-8
set relativenumber
set wildmenu
set showmode
set ignorecase
set shiftwidth=4
set tabstop=4
set expandtab
set termguicolors
" }}}



" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')

"Plug 'sainnhe/gruvbox-material' "temas
Plug 'ayu-theme/ayu-vim'

Plug 'neovim/nvim-lspconfig' "LSP

Plug 'hrsh7th/cmp-nvim-lsp' "Autocomplete
Plug 'hrsh7th/cmp-buffer'   "Autocomplete
Plug 'hrsh7th/cmp-path'     "Autocomplete
Plug 'hrsh7th/cmp-cmdline'  "Autocomplete
Plug 'hrsh7th/nvim-cmp'     "Autocomplete


Plug 'pangloss/vim-javascript' "jsScript
Plug 'maxmellon/vim-jsx-pretty' "html
Plug 'mattn/emmet-vim' "emmet

Plug 'SirVer/ultisnips'         "jsSippets
Plug 'mlaursen/vim-react-snippets' "jsSippets
Plug 'quangnguyen30192/cmp-nvim-ultisnips' "jsSippets

"prettier
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'svelte', 'yaml', 'html'] }

Plug 'tpope/vim-commentary' "comentarios
Plug 'Yggdroot/indentLine'  "indentLine

"Plug 'vim-airline/vim-airline' "status bar
"Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-lualine/lualine.nvim'

Plug 'nvim-tree/nvim-web-devicons' "ptional, for file icons
Plug 'nvim-tree/nvim-tree.lua'      "gestorArchivos
call plug#end()


" }}}

" MAPPINGS --------------------------------------------------------------- {{{

inoremap jj <esc>
" comments
nnoremap <space>/ :Commentary<CR>
vnoremap <space>/ :Commentary<CR>

"nerdtree config"
nnoremap <silent> Z :NvimTreeToggle<CR>
nnoremap <silent> X :NvimTreeClose<CR>

"snippet configuracion
let g:UtilSnipsExpandTriggerr="<tab>"
" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{

" gruvbox configuracion
set background=dark
let ayucolor="dark"
colorscheme ayu

"emmet config
let g:user_emmet_mode='n'
let g:user_emmet_leader_key=','
let g:user_emmet_settings={'javascript':{'extends': 'jsx'}}
set completeopt=menu,menuone,noselect

"lsp config
lua << EOF
require'lspconfig'.tsserver.setup{}
EOF

lua << EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
--        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
	vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
       completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      --{ name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      { name = 'ultisnips' }, -- For ultisnips users.
       --{ name = 'snippy' }, -- For snippy users.

    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['tsserver'].setup {
	   on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
  }

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
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
  },
})


EOF

" when running at every change you may want to disable quickfix
let g:prettier#quickfix_enabled = 0

autocmd TextChanged,InsertLeave *.js,*.jsx,*.mjs,*.ts,*.tsx,*.css,*.less,*.scss,*.json,*.graphql,*.md,*.vue,*.svelte,*.yaml,*.html PrettierAsync

" Max line length that prettier will wrap on: a number or 'auto' (use
" textwidth).
" default: 'auto'
let g:prettier#config#print_width = 'auto'

" number of spaces per indentation level: a number or 'auto' (use
" softtabstop)
" default: 'auto'
let g:prettier#config#tab_width = '2'

" use tabs instead of spaces: true, false, or auto (use the expandtab setting).
" default: 'auto'
let g:prettier#config#use_tabs = 'false'

" flow|babylon|typescript|css|less|scss|json|graphql|markdown or empty string
" (let prettier choose).
" default: ''
let g:prettier#config#parser = ''

" cli-override|file-override|prefer-file
" default: 'file-override'
let g:prettier#config#config_precedence = 'file-override'

" always|never|preserve
" default: 'preserve'
let g:prettier#config#prose_wrap = 'preserve'

" css|strict|ignore
" default: 'css'
let g:prettier#config#html_whitespace_sensitivity = 'css'

" false|true
" default: 'false'
let g:prettier#config#require_pragma = 'false'

" Define the flavor of line endings
" lf|crlf|cr|all
" defaut: 'lf'
let g:prettier#config#end_of_line = get(g:, 'prettier#config#end_of_line', 'lf')


" indentLine config"
let g:indentLine_color_term = 239
let g:indentLine_char = '|'

"airline tabs"
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1

"lualine config
lua << END

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {}
}
END
" }}}



