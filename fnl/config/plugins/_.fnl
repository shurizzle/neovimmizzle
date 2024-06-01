(local *packages* [])
(local {: is} (require :config.platform))

(fn use-package! [name & args]
  (assert (string? name) "Invalid package spec")
  (assert (= 0 (% (length args) 2)) "Invalid package spec")
  (local spec [name])
  (for [i 1 (length args) 2]
    (tset spec (. args i) (. args (inc i))))
  (table.insert *packages* spec)
  nil)

;; UI {{{
(use-package! :kyazdani42/nvim-web-devicons :name :devicons :lazy true :main
              :nvim-web-devicons :opts [])

(use-package! :rcarriga/nvim-notify :name :notify)

(use-package! :LunarVim/bigfile.nvim)
(use-package! :nvim-lualine/lualine.nvim :deps :devicons :name :lualine)

(use-package! :romgrk/barbar.nvim :deps :devicons :name :barbar)

(use-package! :folke/zen-mode.nvim :lazy true :cmd [:ZenMode] :main :zen-mode
              :opts {:plugins {:options {:enabled true :nu false :rnu false}
                              :gitsigns {:enabled true}
                              :diagnostics {:enabled true}}})

(use-package! :norcalli/nvim-colorizer.lua :lazy true :event :BufRead :main
              :colorizer :opts ["*"])

(use-package! :lewis6991/gitsigns.nvim :lazy true :event :BufRead :deps
              [:plenary] :main :gitsigns :opts [])

(use-package! :lukas-reineke/indent-blankline.nvim :tag
              (when (not (has :nvim-0.10)) :v3.5.4) :lazy true :event :BufRead
              :main :ibl :opts
              {:scope {:enabled true
                       :show_start true
                       :show_end false
                       :injected_languages true}
               :exclude {:filetypes [:alpha
                                     :dashboard
                                     :NvimTree
                                     :help
                                     :packer
                                     :lsp-installer
                                     :mason
                                     :DressingInput
                                     :rfc
                                     :lazy]
                         :buftypes [:terminal]}})

(use-package! :folke/todo-comments.nvim :deps :plenary :lazy true :event
              :BufRead :main :todo-comments :opts [])

(use-package! :MunifTanjim/nui.nvim :name :nui)

(use-package! :folke/noice.nvim :name :noice :event :VeryLazy :opts
              {:presets {:lsp_doc_border true}
               :routes [{:filter {:event :msg_show :kind "" :find :written}
                         :opts {:skip true}}
                        {:filter {:event :msg_show
                                  :kind [:echo :echomsg]
                                  :find "[osc52]"}
                         :opts {:skip true}}]
               :cmdline {:enabled true
                         :format {:fennel {:pattern "^:%s*Fnl%s+"
                                           :icon ""
                                           :lang :fennel}}}} :deps
              [:nui :notify])

(use-package! :NeogitOrg/neogit :name :neogit :tag
              (when (not (has :nvim-0.10)) :v0.0.1) :lazy true :main :neogit
              :deps [:telescope :plenary :sindrets/diffview.nvim] :cmd :Neogit
              :opts [])

;; }}}

;; UX {{{
(use-package! :goolord/alpha-nvim :name :alpha)

(use-package! :folke/which-key.nvim :lazy true :event :VeryLazy :main
              :which-key :opts [])

(use-package! :nvim-telescope/telescope-fzf-native.nvim :build
              (let [p (require :config.platform)]
                (if (and p.is.bsd (not p.is.macos)) :gmake :make)))

(use-package! :nvim-telescope/telescope.nvim :name :telescope)

(use-package! :kyazdani42/nvim-tree.lua :deps :devicons :name :tree)

(use-package! :lvimuser/lsp-inlayhints.nvim :lazy true :enabled
              (not (has :nvim-0.10.0)) :main :lsp-inlayhints :opts [] :init
              (fn []
                (fn callback [opts]
                  (-?> (vim.lsp.get_client_by_id opts.data.client_id)
                       ((. (require :lsp-inlayhints) :on_attach) opts.buf false)))

                (vim.api.nvim_create_autocmd :LspAttach {: callback})))

(use-package! :RRethy/vim-illuminate :lazy true :cmd
              [:IlluminatePause
               :IlluminateResume
               :IlluminateToggle
               :IlluminatePauseBuf
               :IlluminateResumeBuf
               :IlluminateToggleBuf] :event :BufRead :config
              (fn []
                ((. (require :illuminate) :configure) {:filetypes_denylist [:NvimTree
                                                                            :dashboard
                                                                            :alpha
                                                                            :TelescopePrompt
                                                                            :DressingInput]})))

(use-package! :akinsho/toggleterm.nvim :lazy true :keys
              [{:mode :n :desc "Toggle Terminal" 1 :<leader>t}] :cmd
              [:TermSelect
               :TermExec
               :ToggleTerm
               :ToggleTermToggleAll
               :ToggleTermSendVisualLines
               :ToggleTermSendCurrentLine
               :ToggleTermSetName] :init
              #(vim.keymap.set :n :<leader>ft :<cmd>TermSelect<cr>
                               {:noremap true
                                :silent true
                                :desc "Search terminal"}) :main
              :toggleterm :opts
              {:open_mapping :<leader>t
               :insert_mappings false
               :shade_terminals false
               :winbar {:enabled true}})

(use-package! :kndndrj/nvim-dbee :name :dbee)

;; }}}

;; LSP {{{
(use-package! :neovim/nvim-lspconfig :lazy true :cmd
              [:LspInfo :LspLog :LspRestart :LspStart :LspStop])

(use-package! :tamago324/nlsp-settings.nvim :deps [:neovim/nvim-lspconfig]
              :lazy true :cmd [:LspSettings] :main :nlspsettings :opts
              {:config_home (let [{: join} (require :config.path)]
                              (join (vim.fn.stdpath :config) :nlsp-settings))
               :local_settings_dir :.nlsp-settings
               :append_default_schemas true
               :loader :json})

;; }}}

;; tools {{{
(use-package! :stevearc/conform.nvim :name :conform)

(use-package! :mfussenegger/nvim-lint :name :lint)

;; (use-package! :instant-markdown/vim-instant-markdown
;;               :lazy true
;;               :ft   :markdown
;;               :init (fn []
;;                       (set vim.g.nvim_markdown_preview_theme :github)
;;                       (if (not= 0 (or vim.g.started_by_firenvim 0))
;;                           (set vim.g.instant_markdown_autostart 0))))
(use-package! :rktjmp/paperplanes.nvim :lazy true :cmd :PP :main :paperplanes
              :opts {:register "+" :provider :paste.rs})

(use-package! :rafcamlet/nvim-luapad :name :luapad)

(use-package! :Joakker/lua-json5 :name :json5 :lazy true :build (if is.win ".\\install.ps1" :./install.sh))

(use-package! :EthanJWright/vs-tasks.nvim :lazy true :deps
              [:plenary :telescope :nvim-lua/popup.nvim :json5] :main :vstask
              :opts
              #{:terminal :toggleterm :json_parser (. (require :json5) :parse)})

;; }}}

;; completion {{{
(use-package! :hrsh7th/cmp-nvim-lsp :name :cmp-nvim-lsp)

(use-package! :L3MON4D3/LuaSnip :name :luasnip)

(use-package! :hrsh7th/nvim-cmp :name :cmp :deps [:hrsh7th/cmp-nvim-lsp] :lazy
              true)

;; }}}

;; langs {{{
(use-package! :mrcjkb/rustaceanvim :name :rustaceanvim :lazy true)

(use-package! :saecki/crates.nvim :name :crates)

(use-package! :mrcjkb/haskell-tools.nvim :deps [:plenary] :name :haskell-tools)

(use-package! :mfussenegger/nvim-jdtls :name :jdtls)

(use-package! :pmizio/typescript-tools.nvim :deps
              [:plenary :neovim/nvim-lspconfig] :name :typescript-tools :lazy
              true)

(use-package! :akinsho/flutter-tools.nvim :name :flutter-tools :lazy true)

(use-package! :folke/neodev.nvim :lazy true :main :neodev :opts
              {:library {:plugins [:nvim-dap-ui] :types true}})

(use-package! :jwalton512/vim-blade :lazy true :ft :blade)

(use-package! :b0o/SchemaStore.nvim :lazy true)

;; }}}

;; editor {{{
(use-package! :ahmedkhalf/project.nvim :main :project_nvim :opts [])

(use-package! :nvim-treesitter/nvim-treesitter :name :treesitter)

(use-package! :JoosepAlviste/nvim-ts-context-commentstring :enabled
              (not (has :nvim-0.10)) :lazy true :deps :treesitter :main
              :ts_context_commentstring :opts
              {:enable_autocmd false :config {:fennel ";; %s"}})

(use-package! :numToStr/Comment.nvim :name :comment)

(use-package! :windwp/nvim-ts-autotag :deps :treesitter :lazy true :ft
              [:html
               :javascript
               :typescript
               :javascriptreact
               :xml
               :php
               :typescriptreact
               :svelte
               :vue
               :tsx
               :jsx
               :rescript
               :markdown
               :glimmer
               :handlebars
               :hbs] :main :nvim-ts-autotag :opts [])

(use-package! :windwp/nvim-autopairs :name :autopairs :lazy true :event
              :InsertEnter :main :nvim-autopairs :opts [])

(use-package! :kylechui/nvim-surround :name :surround)

(use-package! :MarcWeber/vim-addon-local-vimrc :enabled (not (has :nvim-0.9.0)))

(use-package! :tpope/vim-repeat :lazy true :event :InsertEnter)

(use-package! :editorconfig/editorconfig-vim :enabled (not (has :nvim-0.9.0)))

(use-package! :ojroques/nvim-osc52 :name :osc52 :enabled (not (has :nvim-0.10)))

(use-package! :julienvincent/nvim-paredit :lazy true :ft :clojure :name
              :paredit :main :nvim-paredit :deps [:treesitter] :opts [])

(use-package! :julienvincent/nvim-paredit-fennel :lazy true :ft :fennel :name
              :paredit-fennel :main :nvim-paredit-fennel :opts [] :deps :paredit)

;; }}}

;; debug {{{
(use-package! :mfussenegger/nvim-dap :name :dap)

(use-package! :rcarriga/nvim-dap-ui :name :dapui)

;; }}}

*packages*

