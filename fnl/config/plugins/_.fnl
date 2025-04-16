
;; fnlfmt: skip
(let [*packages* []
      {: is} (require :config.platform)]
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

  (use-package! :nvim-lualine/lualine.nvim
                :name :lualine
                :deps :devicons)

  (use-package! :romgrk/barbar.nvim
                :name :barbar
                :deps :devicons)

  (use-package! :folke/zen-mode.nvim
                :lazy true
                :cmd [:ZenMode]
                :main :zen-mode
                :opts {:plugins {:options {:enabled true :nu false :rnu false}
                                 :gitsigns {:enabled true}
                                 :diagnostics {:enabled true}}})

  (use-package! :norcalli/nvim-colorizer.lua
                :lazy true
                :event :BufRead
                :main :colorizer
                :opts ["*"])

  (use-package! :lewis6991/gitsigns.nvim
                :lazy true
                :event :BufRead
                :deps [:plenary]
                :main :gitsigns
                :opts [])

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

  (use-package! :folke/todo-comments.nvim
                :deps :plenary
                :lazy true
                :event :BufRead
                :main :todo-comments
                :opts [])

  (use-package! :MunifTanjim/nui.nvim
                :name :nui)

  (use-package! :folke/noice.nvim
                :name :noice
                :event :VeryLazy
                :deps [:nui :notify]
                :opts {:presets {:lsp_doc_border true}
                       :routes [{:filter {:event :msg_show
                                          :kind ""
                                          :find :written}
                                 :opts {:skip true}}
                                {:filter {:event :msg_show
                                 :kind [:echo :echomsg]
                                 :find "[osc52]"}
                                 :opts {:skip true}}]
                       :cmdline {:enabled true
                                 :format {:fennel {:pattern "^:%s*Fnl%s+"
                                                   :icon ""
                                                   :lang :fennel}}}})

  (use-package! :NeogitOrg/neogit
                :name :neogit
                :tag (when (not (has :nvim-0.10)) :v0.0.1)
                :lazy true
                :main :neogit
                :deps [:telescope :plenary :sindrets/diffview.nvim]
                :cmd :Neogit
                :opts [])

  (use-package! :NStefan002/screenkey.nvim
                :lazy true
                :cmd :Screenkey
                :config true)

  ;; }}}

  ;; UX {{{

  (use-package! :goolord/alpha-nvim
                :name :alpha)

  (use-package! :folke/which-key.nvim
                :lazy true
                :event :VeryLazy
                :main :which-key
                :opts [])

  (use-package! :nvim-telescope/telescope-fzf-native.nvim
                :lazy true
                :build (if (and is.bsd (not is.macos)) :gmake :make))

  (use-package! :nvim-telescope/telescope.nvim
                :name :telescope)

  (use-package! :kyazdani42/nvim-tree.lua
                :deps :devicons
                :name :tree)

  (use-package! :lvimuser/lsp-inlayhints.nvim
                :lazy true
                :enabled (not (has :nvim-0.10.0))
                :main :lsp-inlayhints
                :opts []
                :init #((fn callback [opts]
                          (-?> (vim.lsp.get_client_by_id opts.data.client_id)
                               ((. (require :lsp-inlayhints) :on_attach)
                                opts.buf false)))
                        (vim.api.nvim_create_autocmd :LspAttach {: callback})))

  (use-package! :chrisgrieser/nvim-lsp-endhints
                :lazy true
                :cmd [:EnableEndInlayHints :DisableEndInlayHints]
                :enabled (has :nvim-0.10.0)
                :init #(let [callback #(do (require :lsp-endhints) nil)]
                        (vim.api.nvim_create_autocmd :LspAttach {: callback}))
                :config #(let [h (require :lsp-endhints)]
                          (vim.api.nvim_create_user_command :EnableEndInlayHints
                                                            h.enable [])
                          (vim.api.nvim_create_user_command :DisableEndInlayHints
                                                            h.disable [])
                          (h.setup {:autoEnableHints false})))

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

  (use-package! :kndndrj/nvim-dbee
                :name :dbee)

  (use-package! :f-person/auto-dark-mode.nvim
                :lazy true
                :event :VeryLazy
                :opts [])

  ;; }}}

  ;; LSP {{{

  (use-package! :neovim/nvim-lspconfig
                :lazy true
                :cmd [:LspInfo :LspLog :LspRestart :LspStart :LspStop])

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

  (use-package! :stevearc/conform.nvim
                :name :conform)

  (use-package! :mfussenegger/nvim-lint
                :name :lint)

  ;; (use-package! :instant-markdown/vim-instant-markdown
  ;;               :lazy true
  ;;               :ft   :markdown
  ;;               :init (fn []
  ;;                       (set vim.g.nvim_markdown_preview_theme :github)
  ;;                       (if (not= 0 (or vim.g.started_by_firenvim 0))
  ;;                           (set vim.g.instant_markdown_autostart 0))))

  (use-package! :rktjmp/paperplanes.nvim
                :lazy true
                :cmd :PP
                :main :paperplanes
                :opts {:register "+" :provider :paste.rs})

  (use-package! :rafcamlet/nvim-luapad
                :name :luapad)

  (use-package! :Joakker/lua-json5
                :name :json5
                :lazy true
                :build (if is.win ".\\install.ps1" :./install.sh))

  (use-package! :stevearc/overseer.nvim
                :lazy true
                :cmd (icollect [_ cmd (ipairs [:Run :Info :Open :Build :Close
                                               :RunCmd :Toggle :ClearCache
                                               :LoadBundle :SaveBundle
                                               :TaskAction :QuickAction
                                               :DeleteBundle])]
                       (.. :Overseer cmd))
                :deps [:telescope :notify]
                :init (fn []
                        (vim.api.nvim_create_user_command
                          :OverseerRestartLast
                          (fn []
                            (let [overseer (require :overseer)
                                  tasks (overseer.list_tasks {:recent_first true})]
                              (if (vim.tbl_isempty tasks)
                                  (vim.notify "No tasks found" vim.log.levels.WARN)
                                  (overseer.run_action (. tasks 1) :restart))))
                          [])
                        (vim.keymap.set :n :<leader>cc :<cmd>OverseerRun<CR>
                                        {:noremap false :silent true})
                        (vim.keymap.set :n :<leader>cl :<cmd>OverseerRestartLast<CR>
                                        {:noremap false :silent true}))
                :main :overseer
                :opts {:strategy {1 :toggleterm :use_shell false :auto_scroll true :open_on_start false}
                       :dap false})

  (use-package! :shurizzle/vim-rfc
                :lazy true
                :cmd :Rfc
                :ft  :rfc)

  ;; }}}

  ;; completion {{{

  (use-package! :hrsh7th/cmp-nvim-lsp
                :name :cmp-nvim-lsp)

  (use-package! :L3MON4D3/LuaSnip
                :name :luasnip)

  (use-package! :hrsh7th/nvim-cmp
                :name :cmp
                :deps [:hrsh7th/cmp-nvim-lsp]
                :lazy true)

  ;; }}}

  ;; langs {{{

  (use-package! :mrcjkb/rustaceanvim
                :name :rustaceanvim
                :lazy true)

  (use-package! :saecki/crates.nvim
                :name :crates)

  (use-package! :mrcjkb/haskell-tools.nvim
                :name :haskell-tools
                :deps [:plenary])

  (use-package! :mfussenegger/nvim-jdtls
                :name :jdtls)

  (use-package! :pmizio/typescript-tools.nvim
                :name :typescript-tools
                :deps [:plenary :neovim/nvim-lspconfig]
                :lazy true)

  (use-package! :akinsho/flutter-tools.nvim
                :name :flutter-tools
                :lazy true)

  (use-package! :folke/neodev.nvim
                :main :neodev
                :lazy true
                :opts {:library {:plugins [:nvim-dap-ui] :types true}})

  (use-package! :jwalton512/vim-blade
                :lazy true
                :ft :blade)

  (use-package! :b0o/SchemaStore.nvim
                :lazy true)

  (use-package! :https://gitlab.com/HiPhish/jinja.vim
                :lazy false
                :config (fn []
                          (vim.api.nvim_create_autocmd
                            [:BufRead :BufNewFile]
                            {:pattern :*.html
                             :callback (. vim.fn "jinja#AdjustFiletype")})))

  (use-package! "https://git.sr.ht/~maxgyver83/hare-jump.vim"
                :lazy true
                :cmd :HareJumpToDefinition
                :init (fn []
                        (vim.api.nvim_create_autocmd
                          :FileType
                          {:pattern :hare
                           :callback (fn [{:buf buffer}]
                                       (vim.keymap.set
                                         :n :<leader>cd
                                         "<cmd>HareJumpToDefinition<CR>"
                                         {:silent true
                                          :noremap true
                                          : buffer}))}))
                :config (fn []
                          (set vim.g.hare_jump_use_ripgrep
                               (vim.fn.executable :rg))))

  ;; }}}

  ;; editor {{{

  (use-package! :ahmedkhalf/project.nvim
                :main :project_nvim
                :opts [])

  (use-package! :nvim-treesitter/nvim-treesitter
                :name :treesitter)

  (use-package! :JoosepAlviste/nvim-ts-context-commentstring
                :enabled (not (has :nvim-0.10))
                :lazy true
                :deps :treesitter
                :main :ts_context_commentstring
                :opts {:enable_autocmd false :config {:fennel ";; %s"}})

  (use-package! :numToStr/Comment.nvim
                :name :comment
                :enabled (not (has :nvim-0.10)))

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

  (use-package! :windwp/nvim-autopairs
                :name :autopairs
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
                :name :osc52
                :enabled (not (has :nvim-0.10)))

  (use-package! :julienvincent/nvim-paredit
                :name :paredit
                :lazy true
                :ft :clojure
                :main :nvim-paredit
                :deps [:treesitter]
                :opts [])

  ;; }}}

  ;; debug {{{

  (use-package! :mfussenegger/nvim-dap
                :name :dap)

  (use-package! :rcarriga/nvim-dap-ui
                :name :dapui)

  ;; }}}

  *packages*)

