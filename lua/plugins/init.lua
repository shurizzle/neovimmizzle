local install_path = join_paths(
  vim.fn.stdpath('data'),
  'site',
  'pack',
  'packer',
  'start',
  'packer.nvim'
)
vim.g.packer_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  vim.g.packer_bootstrap = vim.fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  print('Installing packer close and reopen Neovim...')
  vim.cmd([[packadd packer.nvim]])
end

local status_ok, packer = pcall(require, 'packer')
if not status_ok then
  return
end

require('plugins.firenvim').setup()
require('plugins.dashboard').setup()

packer.init({
  display = {
    open_fn = function()
      return require('packer.util').float({ border = 'rounded' })
    end,
  },
})
packer.startup(function()
  use('wbthomason/packer.nvim')
  use('nvim-lua/plenary.nvim')

  use({
    'neovim/nvim-lspconfig',
    config = function()
      require('plugins.lsp').setup()
    end,
  })

  use({
    'williamboman/nvim-lsp-installer',
    config = function()
      require('plugins.lsp.installer').setup()
    end,
  })

  use({
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require('plugins.lsp.null-ls').setup()
    end,
  })

  use({ 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' })

  use({ 'L3MON4D3/LuaSnip' })

  use({
    'saecki/crates.nvim',
    tag = 'v0.1.0',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('crates').setup()
    end,
  })

  use({ 'hrsh7th/cmp-nvim-lsp' })
  use({ 'hrsh7th/cmp-buffer' })
  use({ 'hrsh7th/cmp-path' })
  use({ 'hrsh7th/cmp-calc' })
  use({ 'hrsh7th/cmp-emoji' })
  use({ 'ray-x/cmp-treesitter' })
  use({ 'lukas-reineke/cmp-rg' })
  use({
    'hrsh7th/nvim-cmp',
    requires = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-calc',
      'hrsh7th/cmp-emoji',
      'ray-x/cmp-treesitter',
      'saecki/crates.nvim',
      'lukas-reineke/cmp-rg',
    },
    config = function()
      require('plugins.cmp').setup()
    end,
  })

  use({
    'nvim-telescope/telescope.nvim',
    requires = {
      'nvim-lua/plenary.nvim',
      'kyazdani42/nvim-web-devicons',
      'nvim-telescope/telescope-fzf-native.nvim',
    },
    config = function()
      require('plugins.telescope').setup()
    end,
  })

  use({
    'arcticicestudio/nord-vim',
    config = function()
      colorscheme('nord')
    end,
  })

  use('arkav/lualine-lsp-progress')

  use({
    'nvim-lualine/lualine.nvim',
    requires = {
      { 'kyazdani42/nvim-web-devicons', opt = true },
      { 'arkav/lualine-lsp-progress' },
    },
    config = function()
      require('plugins.lualine').setup()
    end,
  })

  use({
    'romgrk/barbar.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function()
      require('plugins.barbar').setup()
    end,
  })

  use({
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function()
      require('plugins.tree').setup()
    end,
  })

  use({
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('plugins.treesitter').setup()
    end,
    run = ':TSUpdate',
  })

  use({ 'MarcWeber/vim-addon-local-vimrc' })

  use({ 'junegunn/goyo.vim' })

  use({
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup()
    end,
  })
  use({ 'tpope/vim-repeat' })
  use({
    'numToStr/Comment.nvim',
    config = function()
      require('plugins.comment').setup()
    end,
  })
  use({ 'tpope/vim-surround' })
  use({
    'ahmedkhalf/project.nvim',
    config = function()
      require('project_nvim').setup({})
    end,
  })
  use({ 'editorconfig/editorconfig-vim' })

  use({
    'instant-markdown/vim-instant-markdown',
    disabled = (vim.g.started_by_firenvim or 0) == 0,
  })

  use({
    'glacambre/firenvim',
    run = function()
      vim.fn['firenvim#install'](0)
    end,
  })

  use({ 'glepnir/dashboard-nvim' })

  if vim.g.packer_bootstrap then
    require('packer').sync()
  end
end)
