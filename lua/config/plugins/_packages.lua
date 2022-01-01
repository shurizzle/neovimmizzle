return {
  { 'wbthomason/packer.nvim' },
  { 'lewis6991/impatient.nvim' },
  { 'nvim-lua/plenary.nvim' },
  { 'rcarriga/nvim-notify', name = 'notify' },
  { 'stevearc/dressing.nvim', name = 'dressing' },
  { 'shurizzle/inlay-hints.nvim', name = 'inlayhints' },
  { 'ray-x/lsp_signature.nvim' },
  { 'RRethy/vim-illuminate' },
  {
    'neovim/nvim-lspconfig',
    name = 'lsp',
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
    name = 'lsp.installer',
  },
  { 'jose-elias-alvarez/null-ls.nvim', name = 'lsp.null-ls' },
  { 'nvim-telescope/telescope-fzf-native.nvim', name = 'telescope.fzf' },
  { 'nvim-telescope/telescope-ui-select.nvim' },
  { 'nvim-treesitter/nvim-treesitter', name = 'treesitter' },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    requires = { 'nvim-treesitter/nvim-treesitter' },
  },
  { 'L3MON4D3/LuaSnip' },
  {
    'saecki/crates.nvim',
    name = 'crates',
    tag = 'v0.1.0',
    requires = { 'nvim-lua/plenary.nvim' },
  },
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
    name = 'cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'ray-x/cmp-treesitter',
      'saecki/crates.nvim',
      'lukas-reineke/cmp-rg',
      'L3MON4D3/LuaSnip',
    },
  },
  {
    'nvim-telescope/telescope.nvim',
    name = 'telescope',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-fzf-native.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
      'rcarriga/nvim-notify',
    },
  },
  { 'yashguptaz/calvera-dark.nvim', name = 'calvera' },
  { 'arkav/lualine-lsp-progress' },
  {
    'nvim-lualine/lualine.nvim',
    name = 'lualine',
    requires = {
      { 'kyazdani42/nvim-web-devicons', opt = true },
      { 'arkav/lualine-lsp-progress' },
    },
    opt = false,
  },
  {
    'romgrk/barbar.nvim',
    name = 'barbar',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
  },
  {
    'kyazdani42/nvim-tree.lua',
    name = 'tree',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
  },
  { 'norcalli/nvim-colorizer.lua', name = 'colorizer' },
  {
    'lewis6991/gitsigns.nvim',
    name = 'gitsigns',
    requires = { 'nvim-lua/plenary.nvim' },
  },
  { 'lukas-reineke/indent-blankline.nvim', name = 'indent-blankline' },
  { 'MarcWeber/vim-addon-local-vimrc' },
  { 'junegunn/goyo.vim' },
  { 'windwp/nvim-autopairs', name = 'autopairs' },
  { 'tpope/vim-repeat' },
  { 'numToStr/Comment.nvim', name = 'comment' },
  { 'tpope/vim-surround' },
  { 'ahmedkhalf/project.nvim', name = 'project' },
  { 'editorconfig/editorconfig-vim' },
  {
    'instant-markdown/vim-instant-markdown',
    name = 'markdown',
    ft = { 'markdown' },
  },
  { 'glacambre/firenvim', name = 'firenvim' },
  { 'rktjmp/paperplanes.nvim', name = 'paperplanes' },
  { 'glepnir/dashboard-nvim', name = 'dashboard' },
  { 'chrisbra/Colorizer' },
  { 'jwalton512/vim-blade' },
  {
    'rcarriga/nvim-dap-ui',
    name = 'dapui',
    requires = { 'mfussenegger/nvim-dap' },
  },
}
