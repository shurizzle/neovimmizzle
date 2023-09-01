(fn add-parsers []
  (let [config ((. (require :nvim-treesitter.parsers) :get_parser_configs))]
    (set config.prolog
         {:install_info {:url "https://github.com/Rukiza/tree-sitter-prolog"
                         :files ["src/parser.c"]
                         :revision :ee1c64cc15e96430c51914dfee7ca205159b0586}
          :filetype :prolog})
    (set config.pezzo
         {:install_info {:url "https://github.com/shurizzle/tree-sitter-pezzo"
                         :files ["src/parser.c"]
                         :revision :782d4b528ed5b8d21909ff2c174c595f8dd02d09}
          :filetype :pezzo})))

(fn build []
  (add-parsers)
  (((. (require :nvim-treesitter.install) :update)
    {:with_sync (. (require :config.platform) :is :headless)})))

(fn config []
  (add-parsers)
  ((. (require :nvim-treesitter.configs) :setup)
   {:ensure_installed []
    :sync_install (. (require :config.platform) :is :headless)
    :ignore_install [:comment]
    :autopairs {:enable true}
    :highlight {:enable true
                :disable []
                :additional_vim_regex_highlighting [:org]}
    :indent {:enable true :disable [:yaml]}
    :context_commentstring {:enable true :enable_autocmd false}})

  (set vim.o.foldenable false)
  (set vim.o.foldmethod :expr)
  (set vim.o.foldexpr "nvim_treesitter#foldexpr()")

  (vim.api.nvim_create_autocmd
    [:FileType]
    {:pattern :prolog
     :command "setlocal foldenable foldmethod=marker"}))

{:lazy  true
 :event :BufReadPre
 :cmd   [:TSInstall
         :TSUninstall
         :TSUpdate
         :TSUpdateSync
         :TSInstallInfo
         :TSInstallSync
         :TSInstallFromGrammar]
 :dependencies :nvim-treesitter/nvim-treesitter-textobjects
 : build
 : config}
