(local *packages* [])

(fn use-package! [name & args]
  (assert (string? name) "Invalid package spec")
  (assert (= 0 (% (length args) 2)) "Invalid package spec")
  (local spec [name])
  (for [i 1 (length args) 2]
    (tset spec (. args i) (. args (inc i))))
  (table.insert *packages* spec)
  nil)

;; UI {{{
(use-package! :kyazdani42/nvim-web-devicons
              :name :devicons
              :lazy true
              :main :nvim-web-devicons
              :opts [])
(use-package! :rcarriga/nvim-notify
              :name :notify)
(use-package! :LunarVim/bigfile.nvim)
(use-package! :stevearc/dressing.nvim
              :lazy  true
              :event [:VeryLazy]
              :main  :dressing
              :opts  {:input {:insert_only false
                              :win_options {:winblend 20}}})
(use-package! :nvim-lualine/lualine.nvim
              :dependencies :devicons
              :name :lualine)
(use-package! :romgrk/barbar.nvim
              :dependencies :devicons
              :name :barbar)
(use-package! :folke/zen-mode.nvim
              :lazy true
              :cmd  [:ZenMode]
              :main :zen-mode
              :opts {:plugins {:options     {:enabled true
                                             :nu      false
                                             :rnu     false}
                               :gitsigns    {:enabled true}
                               :diagnostics {:enabled true}}})
(use-package! :norcalli/nvim-colorizer.lua
              :lazy  true
              :event :BufRead
              :main  :colorizer
              :opts  [:*])
(use-package! :lewis6991/gitsigns.nvim
              :lazy true
              :event :BufRead
              :dependencies [:nvim-lua/plenary.nvim]
              :main :gitsigns
              :opts [])
(use-package! :lukas-reineke/indent-blankline.nvim
              :lazy  true
              :event :BufRead
              :main  :ibl
              :opts  {:scope   {:enabled            true
                                :show_start         true
                                :show_end           false
                                :injected_languages true}
                      :exclude {:filetypes [:alpha :dashboard :NvimTree :help
                                            :packer :lsp-installer :mason
                                            :DressingInput :rfc :lazy]
                                :buftypes  [:terminal]}})
(use-package! :folke/todo-comments.nvim
              :dependencies :nvim-lua/plenary.nvim
              :lazy true
              :event :BufRead
              :main :todo-comments
              :opts [])
;; }}}


;; UX {{{
(use-package! :goolord/alpha-nvim
              :name :alpha)
(use-package! :folke/which-key.nvim
              :lazy  true
              :event :VeryLazy
              :main  :which-key
              :opts  [])
(use-package! :nvim-telescope/telescope-fzf-native.nvim
              :build (let [p (require :config.platform)]
                       (if (and p.is.bsd (not p.is.macos)) :gmake :make)))
(use-package! :nvim-telescope/telescope.nvim
              :name :telescope)
(use-package! :kyazdani42/nvim-tree.lua
              :dependencies :devicons
              :name :tree)
(use-package! :j-hui/fidget.nvim
              :name :fidget
              :branch :legacy
              :lazy true
              :event :VeryLazy
              :main :fidget
              :opts [])
(use-package! :lvimuser/lsp-inlayhints.nvim
              :lazy true
              :cond (not (has :nvim-0.10.0))
              :main :lsp-inlayhints
              :opts []
              :init (fn []
                      (fn callback [opts]
                        (-?> (vim.lsp.get_client_by_id opts.data.client_id)
                             ((. (require :lsp-inlayhints) :on_attach)
                              opts.buf false)))
                      (vim.api.nvim_create_autocmd :LspAttach {: callback})))
(use-package! :RRethy/vim-illuminate
              :lazy true
              :cmd [:IlluminatePause :IlluminateResume :IlluminateToggle
                    :IlluminatePauseBuf :IlluminateResumeBuf
                    :IlluminateToggleBuf]
              :event :BufRead
              :config (fn []
                        ((. (require :illuminate) :configure)
                         {:filetypes_denylist [:NvimTree :dashboard :alpha
                                               :TelescopePrompt
                                               :DressingInput]})))
(use-package! :akinsho/toggleterm.nvim
              :lazy true
              :keys [{:mode :n :desc "Toggle Terminal" 1 :<leader>t}]
              :cmd  [:TermSelect :TermExec :ToggleTerm :ToggleTermToggleAll
                     :ToggleTermSendVisualLines :ToggleTermSendCurrentLine
                     :ToggleTermSetName]
              :init #(vim.keymap.set
                       :n :<leader>ft
                       "<cmd>TermSelect<cr>"
                       {:noremap true :silent true :desc "Search terminal"})
              :main :toggleterm
              :opts {:open_mapping    :<leader>t
                     :insert_mappings false
                     :shade_terminals false
                     :winbar          {:enabled true}})
;; }}}

;; LSP {{{
(use-package! :neovim/nvim-lspconfig
              :lazy true
              :cmd  [:LspInfo :LspLog :LspRestart :LspStart :LspStop])
(use-package! :tamago324/nlsp-settings.nvim
              :dependencies [:neovim/nvim-lspconfig]
              :lazy true
              :cmd  [:LspSettings]
              :main :nlspsettings
              :opts {:config_home (let [{: join} (require :config.path)]
                                    (join (vim.fn.stdpath :config)
                                          :nlsp-settings))
                     :local_settings_dir :.nlsp-settings
                     :append_default_schemas true
                     :loader :json})
(use-package! :ray-x/lsp_signature.nvim
              :name :lsp-signature)
;; }}}

;; tools {{{
(use-package! :stevearc/conform.nvim
              :name :conform)
(use-package! :mfussenegger/nvim-lint
              :name :lint)
(use-package! :nvim-treesitter/playground
              :dependencies :treesitter
              :lazy true
              :cmd [:TSPlaygroundToggle :TSHighlightCapturesUnderCursor])
(use-package! :instant-markdown/vim-instant-markdown
              :lazy true
              :ft   :markdown
              :init (fn []
                      (set vim.g.nvim_markdown_preview_theme :github)
                      (if (not= 0 (or vim.g.started_by_firenvim 0))
                          (set vim.g.instant_markdown_autostart 0))))
(use-package! :rktjmp/paperplanes.nvim
              :lazy true
              :cmd :PP
              :main :paperplanes
              :opts {:register :+
                     :provider :paste.rs})
(use-package! :rafcamlet/nvim-luapad
              :name :luapad)
;; }}}

;; completion {{{
(use-package! :hrsh7th/cmp-nvim-lsp
              :dependencies [:neovim/nvim-lspconfig
                             :hrsh7th/nvim-cmp]
              :lazy true)
(use-package! :L3MON4D3/LuaSnip
              :name :luasnip)
(use-package! :hrsh7th/nvim-cmp
              :name :cmp
              :dependencies [:hrsh7th/cmp-nvim-lsp]
              :lazy true)
;; }}}

;; langs {{{
(use-package! :simrat39/rust-tools.nvim
              :name :rust-tools
              :dependencies [:nvim-lua/plenary.nvim :dap :neovim/nvim-lspconfig]
              :lazy true)
(use-package! :saecki/crates.nvim
              :name :crates)
(use-package! :mrcjkb/haskell-tools.nvim
              :dependencies [:nvim-lua/plenary.nvim]
              :name :haskell-tools)
(use-package! :mfussenegger/nvim-jdtls
              :name :jdtls)
(use-package! :pmizio/typescript-tools.nvim
              :dependencies [:nvim-lua/plenary.nvim :neovim/nvim-lspconfig]
              :name :typescript-tools
              :lazy true)
(use-package! :akinsho/flutter-tools.nvim
              :name :flutter-tools
              :lazy true)
(use-package! :folke/neodev.nvim
              :lazy true
              :main :neodev
              :opts [])
(use-package! :jwalton512/vim-blade
              :lazy true
              :ft   :blade)
(use-package! :b0o/SchemaStore.nvim
              :lazy true)
;; }}}

;; editor {{{
(use-package! :ahmedkhalf/project.nvim
              :main :project_nvim
              :opts [])
(use-package! :nvim-treesitter/nvim-treesitter
              :name :treesitter)
(use-package! :JoosepAlviste/nvim-ts-context-commentstring
              :lazy true
              :dependencies :treesitter
              :main :ts_context_commentstring
              :opts {:enable_autocmd false
                     :config {:fennel ";; %s"}})
(use-package! :numToStr/Comment.nvim
              :name :comment)
(use-package! :windwp/nvim-ts-autotag
              :dependencies :treesitter
              :lazy true
              :ft [:html :javascript :typescript :javascriptreact :xml :php
                   :typescriptreact :svelte :vue :tsx :jsx :rescript :markdown
                   :glimmer :handlebars :hbs]
              :main :nvim-ts-autotag
              :opts [])
(use-package! :windwp/nvim-autopairs
              :lazy true
              :event :InsertEnter
              :main :nvim-autopairs
              :opts [])
(use-package! :kylechui/nvim-surround
              :name :surround)
(use-package! :MarcWeber/vim-addon-local-vimrc
              :enabled (not (has :nvim-0.9.0)))
(use-package! :tpope/vim-repeat
              :lazy true
              :event :InsertEnter)
(use-package! :editorconfig/editorconfig-vim
              :enabled (not (has :nvim-0.9.0)))
(use-package! :ojroques/nvim-osc52
              :name :osc52)
;; }}}


;; debug {{{
(use-package! :mfussenegger/nvim-dap
              :name :dap)
;; TODO: dap-ui
;; }}}

*packages*
