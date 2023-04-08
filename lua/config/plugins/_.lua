local devicons = 'kyazdani42/nvim-web-devicons'

return {
  { 'nvim-lua/plenary.nvim', lazy = true },
  { 'goolord/alpha-nvim', mod = 'alpha' },
  { devicons, mod = 'devicons' },
  { 'folke/which-key.nvim', mod = 'which-key' },
  { 'rcarriga/nvim-notify', mod = 'notify' },
  { 'stevearc/dressing.nvim', mod = 'dressing' },
  {
    'nvim-treesitter/nvim-treesitter',
    mod = 'treesitter',
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    mod = 'treesitter.textobjects',
  },
  {
    'nvim-orgmode/orgmode',
    mod = 'org',
  },
  {
    'windwp/nvim-ts-autotag',
    mod = 'autotag',
  },
  { 'RRethy/vim-illuminate', mod = 'illuminate' },
  {
    'tamago324/nlsp-settings.nvim',
    mod = 'nlsp-settings',
  },
  {
    'simrat39/rust-tools.nvim',
    lazy = true,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
  },
  {
    'MrcJkb/haskell-tools.nvim',
    lazy = true,
    dependencies = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
  },
  { 'jose-elias-alvarez/typescript.nvim', mod = 'typescript' },
  { 'ray-x/lsp_signature.nvim', mod = 'signature' },
  { 'jose-elias-alvarez/null-ls.nvim', mod = 'lsp.null' },
  {
    'neovim/nvim-lspconfig',
    mod = 'lsp.config',
    dependencies = {
      'tamago324/nlsp-settings.nvim',
      'ray-x/lsp_signature.nvim',
      'jose-elias-alvarez/null-ls.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
  },
  {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'L3MON4D3/LuaSnip',
    mod = 'luasnip',
  },
  {
    'saecki/crates.nvim',
    mod = 'crates',
    tag = 'v0.3.0',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'jose-elias-alvarez/null-ls.nvim',
    },
  },
  {
    'hrsh7th/nvim-cmp',
    mod = 'cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'nvim-treesitter/nvim-treesitter',
      'ray-x/cmp-treesitter',
      'lukas-reineke/cmp-rg',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'ahmedkhalf/project.nvim',
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    mod = 'telescope',
  },
  {
    'nvim-lualine/lualine.nvim',
    mod = 'lualine',
    dependencies = { devicons },
  },
  {
    'romgrk/barbar.nvim',
    mod = 'barbar',
    dependencies = devicons,
  },
  {
    'kyazdani42/nvim-tree.lua',
    mod = 'tree',
    dependencies = devicons,
  },
  { 'norcalli/nvim-colorizer.lua', mod = 'colorizer' },
  {
    'lewis6991/gitsigns.nvim',
    mod = 'gitsigns',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'lukas-reineke/indent-blankline.nvim', mod = 'indent-blankline' },
  {
    'MarcWeber/vim-addon-local-vimrc',
    enabled = vim.fn.has('nvim-0.9.0') == 0,
  },
  { 'junegunn/goyo.vim', lazy = true, cmd = { 'Goyo' } },
  { 'windwp/nvim-autopairs', mod = 'autopairs' },
  { 'tpope/vim-repeat', lazy = true, event = 'InsertEnter' },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    mod = 'treesitter.context-commentstring',
  },
  {
    'numToStr/Comment.nvim',
    mod = 'comment',
    dependencies = 'JoosepAlviste/nvim-ts-context-commentstring',
  },
  { 'kylechui/nvim-surround', mod = 'surround' },
  { 'ahmedkhalf/project.nvim', mod = 'project' },
  { 'editorconfig/editorconfig-vim', enabled = vim.fn.has('nvim-0.9.0') == 0 },
  {
    'instant-markdown/vim-instant-markdown',
    mod = 'markdown',
  },
  { 'rktjmp/paperplanes.nvim', mod = 'paperplanes' },
  { 'jwalton512/vim-blade', lazy = true, ft = 'blade' },
  { 'mfussenegger/nvim-dap', mod = 'dap' },
  {
    'rcarriga/nvim-dap-ui',
    mod = 'dapui',
    dependencies = { 'mfussenegger/nvim-dap' },
  },
  {
    'folke/todo-comments.nvim',
    mod = 'todo-comments',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  {
    'akinsho/flutter-tools.nvim',
    mod = 'flutter',
    dependencies = 'nvim-lua/plenary.nvim',
  },
  { 'ojroques/nvim-osc52', mod = 'osc52' },
  { 'folke/neodev.nvim', mod = 'neodev' },
  { 'rafcamlet/nvim-luapad', mod = 'luapad' },
  { 'j-hui/fidget.nvim', mod = 'fidget' },
  { 'lvimuser/lsp-inlayhints.nvim', mod = 'inlayhints' },
  { 'LhKipp/nvim-nu', mod = 'nu' },
}
