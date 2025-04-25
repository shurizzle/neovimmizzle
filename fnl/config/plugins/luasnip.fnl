(fn config []
  ((. (require :luasnip) :config :set_config) {:history true
                                               :enable_autosnippets false})
  ((. (require :luasnip.loaders.from_vscode) :lazy_load)))

(fn winmake []
  (local {: which : dirname :join path-join} (require :config.path))
  (local git-bash (-?> (which :git)
                       (dirname)
                       (dirname)
                       (path-join :bin :bash.exe)))
  (when (not git-bash)
    (vim.api.nvim_err_writeln "Cannot find git cli")
    (lua "return nil"))
  (local esc vim.fn.shellescape)
  (local vim-path (-?> (which :nvim) (dirname) (esc)))
  (when (not vim-path)
    (vim.api.nvim_err_writeln "Cannot find nvim")
    (lua "return nil"))
  (.. "make install_jsregexp CC=gcc.exe SHELL=" (esc git-bash) " LUA_LDLIBS="
      (esc (.. :-L vim-path " -l:lua51.dll")) " .SHELLFLAGS=-c"))

{:lazy true
 :build (let [{: is} (require :config.platform)]
          (if (and is.bsd (not is.macos)) "gmake install_jsregexp"
              is.win (winmake)
              "make install_jsregexp"))
 :deps [:rafamadriz/friendly-snippets]
 : config}
