local devicons = 'kyazdani42/nvim-web-devicons'

return {
  { 'nvim-lua/plenary.nvim', module = { 'plenary', 'luassert', 'say' } },
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
    after = 'nvim-treesitter',
    requires = 'nvim-treesitter/nvim-treesitter',
  },
  {
    'nvim-orgmode/orgmode',
    mod = 'org',
    requires = 'nvim-treesitter/nvim-treesitter',
  },
  {
    'windwp/nvim-ts-autotag',
    mod = 'autotag',
    requires = 'nvim-treesitter/nvim-treesitter',
  },
  { 'RRethy/vim-illuminate', mod = 'illuminate' },
  {
    'tamago324/nlsp-settings.nvim',
    mod = 'nlsp-settings',
    opt = true,
  },
  {
    'simrat39/rust-tools.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'mfussenegger/nvim-dap',
    },
    opt = true,
  },
  {
    'MrcJkb/haskell-tools.nvim',
    requires = {
      'neovim/nvim-lspconfig',
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
    },
    opt = true,
  },
  { 'jose-elias-alvarez/typescript.nvim', opt = true },
  { 'ray-x/lsp_signature.nvim', mod = 'signature' },
  { 'jose-elias-alvarez/null-ls.nvim', mod = 'lsp.null' },
  {
    'neovim/nvim-lspconfig',
    mod = 'lsp.config',
    requires = {
      'tamago324/nlsp-settings.nvim',
      'ray-x/lsp_signature.nvim',
      'jose-elias-alvarez/null-ls.nvim',
      'hrsh7th/cmp-nvim-lsp',
    },
  },
  {
    'nvim-treesitter/playground',
    cmd = { 'TSPlaygroundToggle', 'TSHighlightCapturesUnderCursor' },
    requires = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'L3MON4D3/LuaSnip',
    mod = 'luasnip',
  },
  {
    'saecki/crates.nvim',
    mod = 'crates',
    tag = 'v0.3.0',
    requires = { 'nvim-lua/plenary.nvim', 'jose-elias-alvarez/null-ls.nvim' },
  },
  {
    'hrsh7th/nvim-cmp',
    mod = 'cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'nvim-treesitter/nvim-treesitter',
      'ray-x/cmp-treesitter',
      'saecki/crates.nvim',
      'lukas-reineke/cmp-rg',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'ahmedkhalf/project.nvim',
      'nvim-orgmode/orgmode',
    },
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    mod = 'telescope.fzf',
    opt = true,
  },
  { 'nvim-telescope/telescope-ui-select.nvim', opt = true },
  {
    'nvim-telescope/telescope.nvim',
    mod = 'telescope',
    requires = {
      'rcarriga/nvim-notify',
      'ahmedkhalf/project.nvim',
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    mod = 'lualine',
    requires = { devicons },
  },
  {
    'romgrk/barbar.nvim',
    mod = 'barbar',
    requires = devicons,
  },
  {
    'kyazdani42/nvim-tree.lua',
    mod = 'tree',
    requires = devicons,
  },
  { 'norcalli/nvim-colorizer.lua', mod = 'colorizer' },
  {
    'lewis6991/gitsigns.nvim',
    mod = 'gitsigns',
    requires = { 'nvim-lua/plenary.nvim' },
  },
  { 'lukas-reineke/indent-blankline.nvim', mod = 'indent-blankline' },
  { 'MarcWeber/vim-addon-local-vimrc' },
  { 'junegunn/goyo.vim', cmd = { 'Goyo' } },
  { 'windwp/nvim-autopairs', mod = 'autopairs' },
  { 'tpope/vim-repeat' },
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    mod = 'treesitter.context-commentstring',
  },
  {
    'numToStr/Comment.nvim',
    mod = 'comment',
    requires = 'JoosepAlviste/nvim-ts-context-commentstring',
  },
  { 'kylechui/nvim-surround', mod = 'surround' },
  { 'ahmedkhalf/project.nvim', mod = 'project' },
  { 'editorconfig/editorconfig-vim' },
  {
    'instant-markdown/vim-instant-markdown',
    mod = 'markdown',
  },
  { 'rktjmp/paperplanes.nvim', mod = 'paperplanes' },
  { 'jwalton512/vim-blade', ft = 'blade' },
  { 'mfussenegger/nvim-dap', mod = 'dap' },
  {
    'rcarriga/nvim-dap-ui',
    mod = 'dapui',
    requires = { 'mfussenegger/nvim-dap' },
  },
  {
    'folke/todo-comments.nvim',
    mod = 'todo-comments',
    requires = { 'nvim-lua/plenary.nvim' },
  },
  {
    'akinsho/flutter-tools.nvim',
    mod = 'flutter',
    requires = 'nvim-lua/plenary.nvim',
    opt = true,
  },
  { 'ojroques/nvim-osc52', mod = 'osc52' },
  { 'folke/neodev.nvim', mod = 'neodev', opt = true },
  { 'rafcamlet/nvim-luapad', mod = 'luapad' },
  { 'j-hui/fidget.nvim', mod = 'fidget' },
  { 'lvimuser/lsp-inlayhints.nvim', mod = 'inlayhints' },
}
