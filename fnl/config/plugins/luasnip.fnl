(fn config []
  ((. (require :luasnip) :config :set_config) {:history true
                                               :enable_autosnippets false})
  ((. (require :luasnip.loaders.from_vscode) :lazy_load)))

(fn winmake []
  (local {: which : dirname :join path-join :dirs path-dirs :sep path-sep}
         (require :config.path))
  (local git-bash (-?> (which :git)
                          (dirname)
                          (dirname)
                          (path-join :bin :bash.exe)))
  (when (not git-bash)
    (vim.api.nvim_err_writeln "Cannot find git cli")
    (lua "return nil"))
  (local vim-path (-?> (which :nvim) (dirname) (vim.fn.shellescape)))
  (when (not vim-path)
    (vim.api.nvim_err_writeln "Cannot find nvim")
    (lua "return nil"))

  (local esc vim.fn.shellescape)

  (.. "make install_jsregexp CC=gcc.exe SHELL="
      (esc git-bash)
      " LUA_LDLIBS="
      (esc (.. :-L vim-path " -l:lua51.dll"))
      " .SHELLFLAGS=-c"))

{:lazy true
 :build (let [p (require :config.platform)]
          (if
            (and p.is.bsd (not p.is.macos)) "gmake install_jsregexp"
            p.is.win (winmake)
            "make install_jsregexp"))
 :deps [:rafamadriz/friendly-snippets :plenary]
 : config}
