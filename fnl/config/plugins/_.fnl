(let [_ 1 devicons :kyazdani42/nvim-web-devicons]
  [{_ :rcarriga/nvim-notify :mod :notify}
   {_ :nvim-lua/plenary.nvim :lazy true}
   {_ :goolord/alpha-nvim :mod :alpha}
   {_ devicons :mod :devicons}
   {_ :folke/which-key.nvim :mod :which-key}
   {_ :stevearc/dressing.nvim :mod :dressing}
   {_ :nvim-treesitter/nvim-treesitter :mod :treesitter}
   {_ :nvim-treesitter/nvim-treesitter-textobjects :mod :treesitter.textobjects}
   {_ :nvim-orgmode/orgmode :mod :org}
   {_ :windwp/nvim-ts-autotag :mod :autotag}
   {_ :RRethy/vim-illuminate :mod :illuminate}
   {_ :tamago324/nlsp-settings.nvim :mod :nlsp-settings}
   {_ :simrat39/rust-tools.nvim
    :lazy true
    :dependencies [:nvim-lua/plenary.nvim :mfussenegger/nvim-dap]}
   {_ :MrcJkb/haskell-tools.nvim
    :lazy true
    :dependencies [:neovim/nvim-lspconfig
                   :nvim-lua/plenary.nvim
                   :nvim-telescope/telescope.nvim]}
   {_ :jose-elias-alvarez/typescript.nvim :mod :typescript}
   {_ :ray-x/lsp_signature.nvim :mod :signature}
   {_ :jose-elias-alvarez/null-ls.nvim :mod :lsp.null}
   {_ :neovim/nvim-lspconfig :mod :lsp.config}
   {_ :nvim-treesitter/playground
    :cmd [:TSPlaygroundToggle :TSHighlightCapturesUnderCursor]
    :dependencies [:nvim-treesitter/nvim-treesitter]}
   {_ :L3MON4D3/LuaSnip :mod :luasnip}
   {_ :saecki/crates.nvim
    :mod :crates
    :tag :v0.3.0
    :dependencies [:nvim-lua/plenary.nvim :jose-elias-alvarez/null-ls.nvim]}
   {_ :hrsh7th/nvim-cmp :mod :cmp}
   {_ :nvim-telescope/telescope.nvim :mod :telescope}
   {_ :nvim-lualine/lualine.nvim :mod :lualine :dependencies devicons}
   {_ :romgrk/barbar.nvim :mod :barbar :dependencies devicons}
   {_ :kyazdani42/nvim-tree.lua :mod :tree :dependencies devicons}
   {_ :norcalli/nvim-colorizer.lua :mod :colorizer}
   {_ :lewis6991/gitsigns.nvim :mod :gitsigns}
   {_ :lukas-reineke/indent-blankline.nvim :mod :indent-blankline}
   {_ :MarcWeber/vim-addon-local-vimrc :enabled (not (has :nvim-0.9.0))}
   {_ :folke/zen-mode.nvim
    :lazy true
    :cmd [:ZenMode]
    :main :zen-mode
    :opts {:plugins {:options     {:enabled true
                                   :nu      false
                                   :rnu     false}
                     :gitsigns    {:enabled true}
                     :diagnostics {:enabled true}}}}
   {_ :windwp/nvim-autopairs :mod :autopairs}
   {_ :tpope/vim-repeat :lazy true :event :InsertEnter}
   {_ :JoosepAlviste/nvim-ts-context-commentstring
    :mod :treesitter.context-commentstring}
   {_ :numToStr/Comment.nvim
    :mod :comment
    :dependencies :JoosepAlviste/nvim-ts-context-commentstring}
   {_ :kylechui/nvim-surround :mod :surround}
   {_ :ahmedkhalf/project.nvim :mod :project}
   {_ :editorconfig/editorconfig-vim :enabled (not (has :nvim-0.9.0))}
   {_ :instant-markdown/vim-instant-markdown :mod :markdown}
   {_ :rktjmp/paperplanes.nvim :mod :paperplanes}
   {_ :jwalton512/vim-blade :lazy true :ft :blade}
   {_ :mfussenegger/nvim-dap :mod :dap}
   {_ :rcarriga/nvim-dap-ui :mod :dapui :dependencies :mfussenegger/nvim-dap}
   {_ :folke/todo-comments.nvim
    :mod :todo-comments
    :dependencies :nvim-lua/plenary.nvim}
   {_ :akinsho/flutter-tools.nvim
    :mod :flutter
    :dependencies :nvim-lua/plenary.nvim}
   {_ :ojroques/nvim-osc52 :mod :osc52}
   {_ :folke/neodev.nvim
    :lazy true
    :config (fn [] ((. (require :neodev) :setup)))}
   {_ :rafcamlet/nvim-luapad :mod :luapad}
   {_ :j-hui/fidget.nvim :branch :legacy :mod :fidget}
   {_ :lvimuser/lsp-inlayhints.nvim :mod :inlayhints}
   {_ :LhKipp/nvim-nu :mod :nu}
   {_ :b0o/schemastore.nvim :lazy :true}
   {_ :mfussenegger/nvim-jdtls :lazy :true}
   {_ :akinsho/toggleterm.nvim :mod :toggleterm}
   {_ :LunarVim/bigfile.nvim}])
