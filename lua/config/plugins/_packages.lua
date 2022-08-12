return {
  { 'wbthomason/packer.nvim' },
  { 'lewis6991/impatient.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'rcarriga/nvim-notify', mod = 'notify' },
  { 'stevearc/dressing.nvim', mod = 'dressing' },
  {
    'shurizzle/inlay-hints.nvim',
    requires = { 'nvim-treesitter/nvim-treesitter' },
    ft = { 'rust', 'typescript' },
    mod = 'inlayhints',
  },
  { 'ray-x/lsp_signature.nvim' },
  { 'RRethy/vim-illuminate', mod = 'illuminate' },
  {
    'neovim/nvim-lspconfig',
    mod = 'lsp',
  },
  { 'mfussenegger/nvim-dap' },
  {
    'simrat39/rust-tools.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
    },
  },
  {
    'williamboman/nvim-lsp-installer',
    requires = {
      'neovim/nvim-lspconfig',
      'simrat39/rust-tools.nvim',
      'shurizzle/inlay-hints.nvim',
      'ray-x/lsp_signature.nvim',
      'RRethy/vim-illuminate',
    },
    mod = 'lsp.installer',
  },
  { 'jose-elias-alvarez/null-ls.nvim', mod = 'lsp.null-ls' },
  { 'nvim-telescope/telescope-fzf-native.nvim', mod = 'telescope.fzf' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'nvim-treesitter/nvim-treesitter', mod = 'treesitter' },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  },
  {
    'nvim-treesitter/playground',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  },
  { 'rafamadriz/friendly-snippets' },
  {
    'L3MON4D3/LuaSnip',
    mod = 'luasnip',
    requires = { 'rafamadriz/friendly-snippets' },
  },
  {
    'saecki/crates.nvim',
    mod = 'crates',
    event = { 'BufRead Cargo.toml' },
    tag = 'v0.2.1',
    requires = { 'nvim-lua/plenary.nvim', 'jose-elias-alvarez/null-ls.nvim' },
  },
  { 'saadparwaiz1/cmp_luasnip', requires = { 'L3MON4D3/LuaSnip' } },
  { 'hrsh7th/cmp-nvim-lsp' },
  { 'hrsh7th/cmp-buffer' },
  { 'hrsh7th/cmp-path' },
  { 'hrsh7th/cmp-calc' },
  { 'hrsh7th/cmp-emoji' },
  {
    'ray-x/cmp-treesitter',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  },
  { 'lukas-reineke/cmp-rg' },
  {
    'hrsh7th/nvim-cmp',
    mod = 'cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'ray-x/cmp-treesitter',
      'saecki/crates.nvim',
      'lukas-reineke/cmp-rg',
      'saadparwaiz1/cmp_luasnip',
      'L3MON4D3/LuaSnip',
      'ahmedkhalf/project.nvim',
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    mod = 'telescope',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'rcarriga/nvim-notify',
      'ahmedkhalf/project.nvim',
    },
  },
  { 'arkav/lualine-lsp-progress' },
  {
    'nvim-lualine/lualine.nvim',
    mod = 'lualine',
    requires = {
      { 'kyazdani42/nvim-web-devicons', opt = true },
      { 'arkav/lualine-lsp-progress' },
    },
    opt = false,
  },
  {
    'romgrk/barbar.nvim',
    mod = 'barbar',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  },
  {
    'kyazdani42/nvim-tree.lua',
    mod = 'tree',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
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
  { 'numToStr/Comment.nvim', mod = 'comment' },
  { 'tpope/vim-surround' },
  { 'ahmedkhalf/project.nvim', mod = 'project' },
  { 'editorconfig/editorconfig-vim' },
  {
    'instant-markdown/vim-instant-markdown',
    mod = 'markdown',
    ft = { 'markdown' },
  },
  { 'glacambre/firenvim', mod = 'firenvim' },
  { 'rktjmp/paperplanes.nvim', mod = 'paperplanes' },
  { 'glepnir/dashboard-nvim', mod = 'dashboard' },
  { 'jwalton512/vim-blade' },
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
}
