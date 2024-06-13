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

;; fnlfmt: skip
(use-package! :kyazdani42/nvim-web-devicons
              :name :devicons
              :lazy true
              :main :nvim-web-devicons
              :opts [])

;; fnlfmt: skip
(use-package! :rcarriga/nvim-notify
              :name :notify)

(use-package! :LunarVim/bigfile.nvim)

;; fnlfmt: skip
(use-package! :nvim-lualine/lualine.nvim
              :name :lualine
              :deps :devicons)

;; fnlfmt: skip
(use-package! :romgrk/barbar.nvim
              :name :barbar
              :deps :devicons)

;; fnlfmt: skip
(use-package! :folke/zen-mode.nvim
              :lazy true
              :cmd [:ZenMode]
              :main :zen-mode
              :opts {:plugins {:options {:enabled true :nu false :rnu false}
                               :gitsigns {:enabled true}
                               :diagnostics {:enabled true}}})

;; fnlfmt: skip
(use-package! :norcalli/nvim-colorizer.lua
              :lazy true
              :event :BufRead
              :main :colorizer
              :opts ["*"])

;; fnlfmt: skip
(use-package! :lewis6991/gitsigns.nvim
              :lazy true
              :event :BufRead
              :deps [:plenary]
              :main :gitsigns
              :opts [])

;; fnlfmt: skip
(use-package! :lukas-reineke/indent-blankline.nvim
              :tag (when (not (has :nvim-0.10)) :v3.5.4)
              :lazy true
              :event :BufRead
              :main :ibl
              :opts {:scope {:enabled true
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

;; fnlfmt: skip
(use-package! :folke/todo-comments.nvim
              :deps :plenary
              :lazy true
              :event :BufRead
              :main :todo-comments
              :opts [])

;; fnlfmt: skip
(use-package! :MunifTanjim/nui.nvim
              :name :nui)

;; fnlfmt: skip
(use-package! :folke/noice.nvim
              :name :noice
              :event :VeryLazy
              :opts {:presets {:lsp_doc_border true}
                     :routes [{:filter {:event :msg_show :kind "" :find :written}
                               :opts {:skip true}}
                              {:filter {:event :msg_show
                               :kind [:echo :echomsg]
                               :find "[osc52]"}
                               :opts {:skip true}}]
                     :cmdline {:enabled true
                               :format {:fennel {:pattern "^:%s*Fnl%s+"
                                                 :icon ""
                                                 :lang :fennel}}}}
              :deps [:nui :notify])

;; fnlfmt: skip
(use-package! :NeogitOrg/neogit
              :name :neogit
              :tag (when (not (has :nvim-0.10)) :v0.0.1)
              :lazy true
              :main :neogit
              :deps [:telescope :plenary :sindrets/diffview.nvim]
              :cmd :Neogit
              :opts [])

;; fnlfmt: skip
(use-package! :NStefan002/screenkey.nvim
              :lazy true
              :cmd :Screenkey
              :config true)

;; }}}

;; UX {{{

;; fnlfmt: skip
(use-package! :goolord/alpha-nvim
              :name :alpha)

;; fnlfmt: skip
(use-package! :folke/which-key.nvim
              :lazy true
              :event :VeryLazy
              :main :which-key
              :opts [])

;; fnlfmt: skip
(use-package! :nvim-telescope/telescope-fzf-native.nvim
              :build (if (and is.bsd (not is.macos)) :gmake :make))

;; fnlfmt: skip
(use-package! :nvim-telescope/telescope.nvim
              :name :telescope)

;; fnlfmt: skip
(use-package! :kyazdani42/nvim-tree.lua
              :deps :devicons
              :name :tree)

;; fnlfmt: skip
(use-package! :lvimuser/lsp-inlayhints.nvim
              :lazy true
              :enabled (not (has :nvim-0.10.0))
              :main :lsp-inlayhints
              :opts []
              :init (fn []
                      (fn callback [opts]
                        (-?> (vim.lsp.get_client_by_id opts.data.client_id)
                             ((. (require :lsp-inlayhints) :on_attach)
                              opts.buf false)))
                      (vim.api.nvim_create_autocmd :LspAttach {: callback})))

;; fnlfmt: skip
(use-package! :RRethy/vim-illuminate
              :lazy true
              :cmd [:IlluminatePause
                    :IlluminateResume
                    :IlluminateToggle
                    :IlluminatePauseBuf
                    :IlluminateResumeBuf
                    :IlluminateToggleBuf]
              :event :BufRead
              :config (fn []
                        ((. (require :illuminate) :configure)
                         {:filetypes_denylist [:NvimTree
                                               :dashboard
                                               :alpha
                                               :TelescopePrompt
                                               :DressingInput]})))

;; fnlfmt: skip
(use-package! :akinsho/toggleterm.nvim
              :lazy true
              :keys [{:mode :n :desc "Toggle Terminal" 1 :<leader>t}]
              :cmd [:TermSelect
                    :TermExec
                    :ToggleTerm
                    :ToggleTermToggleAll
                    :ToggleTermSendVisualLines
                    :ToggleTermSendCurrentLine
                    :ToggleTermSetName]
              :init #(vim.keymap.set :n :<leader>ft :<cmd>TermSelect<cr>
                                     {:noremap true
                                      :silent true
                                      :desc "Search terminal"})
              :main :toggleterm
              :opts {:open_mapping :<leader>t
                     :insert_mappings false
                     :shade_terminals false
                     :winbar {:enabled true}})

;; fnlfmt: skip
(use-package! :kndndrj/nvim-dbee
              :name :dbee)

;; }}}

;; LSP {{{

;; fnlfmt: skip
(use-package! :neovim/nvim-lspconfig
              :lazy true
              :cmd [:LspInfo :LspLog :LspRestart :LspStart :LspStop])

;; fnlfmt: skip
(use-package! :tamago324/nlsp-settings.nvim
              :deps [:neovim/nvim-lspconfig]
              :lazy true
              :cmd [:LspSettings]
              :main :nlspsettings
              :opts {:config_home (let [{: join} (require :config.path)]
                                    (-> (vim.fn.stdpath :config)
                                        (join :nlsp-settings)))
                     :local_settings_dir :.nlsp-settings
                     :append_default_schemas true
                     :loader :json})

;; }}}

;; tools {{{

;; fnlfmt: skip
(use-package! :stevearc/conform.nvim
              :name :conform)

;; fnlfmt: skip
(use-package! :mfussenegger/nvim-lint
              :name :lint)

;; (use-package! :instant-markdown/vim-instant-markdown
;;               :lazy true
;;               :ft   :markdown
;;               :init (fn []
;;                       (set vim.g.nvim_markdown_preview_theme :github)
;;                       (if (not= 0 (or vim.g.started_by_firenvim 0))
;;                           (set vim.g.instant_markdown_autostart 0))))

;; fnlfmt: skip
(use-package! :rktjmp/paperplanes.nvim
              :lazy true
              :cmd :PP
              :main :paperplanes
              :opts {:register "+" :provider :paste.rs})

;; fnlfmt: skip
(use-package! :rafcamlet/nvim-luapad
              :name :luapad)

;; fnlfmt: skip
(use-package! :Joakker/lua-json5
              :name :json5
              :lazy true
              :build (if is.win ".\\install.ps1" :./install.sh))

;; fnlfmt: skip
(use-package! :EthanJWright/vs-tasks.nvim
              :lazy true
              :deps [:plenary :telescope :nvim-lua/popup.nvim :json5]
              :main :vstask
              :opts #{:terminal :toggleterm :json_parser (. (require :json5) :parse)})

;; }}}

;; completion {{{

;; fnlfmt: skip
(use-package! :hrsh7th/cmp-nvim-lsp
              :name :cmp-nvim-lsp)

;; fnlfmt: skip
(use-package! :L3MON4D3/LuaSnip
              :name :luasnip)

;; fnlfmt: skip
(use-package! :hrsh7th/nvim-cmp
              :name :cmp
              :deps [:hrsh7th/cmp-nvim-lsp]
              :lazy true)

;; }}}

;; langs {{{

;; fnlfmt: skip
(use-package! :mrcjkb/rustaceanvim
              :name :rustaceanvim
              :lazy true)

;; fnlfmt: skip
(use-package! :saecki/crates.nvim
              :name :crates)

;; fnlfmt: skip
(use-package! :mrcjkb/haskell-tools.nvim
              :name :haskell-tools
              :deps [:plenary])

;; fnlfmt: skip
(use-package! :mfussenegger/nvim-jdtls
              :name :jdtls)

;; fnlfmt: skip
(use-package! :pmizio/typescript-tools.nvim
              :name :typescript-tools
              :deps [:plenary :neovim/nvim-lspconfig]
              :lazy true)

;; fnlfmt: skip
(use-package! :akinsho/flutter-tools.nvim
              :name :flutter-tools
              :lazy true)

;; fnlfmt: skip
(use-package! :folke/neodev.nvim
              :main :neodev
              :lazy true
              :opts {:library {:plugins [:nvim-dap-ui] :types true}})

;; fnlfmt: skip
(use-package! :jwalton512/vim-blade
              :lazy true
              :ft :blade)

;; fnlfmt: skip
(use-package! :b0o/SchemaStore.nvim
              :lazy true)

;; }}}

;; editor {{{

;; fnlfmt: skip
(use-package! :ahmedkhalf/project.nvim
              :main :project_nvim
              :opts [])

;; fnlfmt: skip
(use-package! :nvim-treesitter/nvim-treesitter
              :name :treesitter)

;; fnlfmt: skip
(use-package! :JoosepAlviste/nvim-ts-context-commentstring
              :enabled (not (has :nvim-0.10))
              :lazy true
              :deps :treesitter
              :main :ts_context_commentstring
              :opts {:enable_autocmd false :config {:fennel ";; %s"}})

;; fnlfmt: skip
(use-package! :numToStr/Comment.nvim
              :name :comment)

;; fnlfmt: skip
(use-package! :windwp/nvim-ts-autotag
              :deps :treesitter
              :lazy true
              :ft [:html
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
                   :hbs]
              :main :nvim-ts-autotag
              :opts [])

;; fnlfmt: skip
(use-package! :windwp/nvim-autopairs
              :name :autopairs
              :lazy true
              :event :InsertEnter
              :main :nvim-autopairs
              :opts [])

;; fnlfmt: skip
(use-package! :kylechui/nvim-surround
              :name :surround)

;; fnlfmt: skip
(use-package! :MarcWeber/vim-addon-local-vimrc
              :enabled (not (has :nvim-0.9.0)))

;; fnlfmt: skip
(use-package! :tpope/vim-repeat
              :lazy true
              :event :InsertEnter)

;; fnlfmt: skip
(use-package! :editorconfig/editorconfig-vim
              :enabled (not (has :nvim-0.9.0)))

;; fnlfmt: skip
(use-package! :ojroques/nvim-osc52
              :name :osc52
              :enabled (not (has :nvim-0.10)))

;; fnlfmt: skip
(use-package! :julienvincent/nvim-paredit
              :name :paredit
              :lazy true
              :ft :clojure
              :main :nvim-paredit
              :deps [:treesitter]
              :opts [])

;; fnlfmt: skip
(use-package! :julienvincent/nvim-paredit-fennel
              :name :paredit-fennel
              :lazy true
              :ft :fennel
              :main :nvim-paredit-fennel
              :opts []
              :deps :paredit)

;; }}}

;; debug {{{

;; fnlfmt: skip
(use-package! :mfussenegger/nvim-dap
              :name :dap)

;; fnlfmt: skip
(use-package! :rcarriga/nvim-dap-ui
              :name :dapui)

;; }}}

*packages*

