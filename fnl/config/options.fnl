(local {: is} (require :config.platform))

(when (has :nvim-0.10.0)
  (vim.lsp.inlay_hint.enable))

(macro opt [& opts]
  (assert-compile (= (% (length opts) 2) 0) "Invalid options syntax" opts)
  (fcollect [i 1 (length opts) 2]
    `(tset vim.opt ,(tostring (. opts i)) ,(. opts (+ i 1)))))

;; fnlfmt: skip
(opt
  autoread true
  fileencoding :UTF-8
  mouse :a
  smartindent true
  swapfile false
  undofile false
  timeoutlen 300
  pumheight 10
  backup false
  writebackup false
  expandtab true
  shiftwidth 2
  tabstop 2
  number true
  relativenumber true
  wrap true
  clipboard :unnamedplus
  list true
  listchars "tab: ·,trail:×,nbsp:%,eol:·,extends:»,precedes:«"
  secure true
  window 53
  splitbelow true
  splitright true
  colorcolumn :80
  cursorline true
  omnifunc "v:lua.vim.lsp.omnifunc"
  guifont (.. "monospace:h" (if is.macos 11 10))
  laststatus 3
  showmode false
  spell true
  spelllang :en
  signcolumn :yes
  ignorecase true)

(set vim.g.neovide_cursor_vfx_mode :torpedo)
(if vim.g.neovide (set vim.opt.gfn "monospace:h9"))

(set vim.g.himalaya_mailbox_picker :telescope)
(set vim.g.himalaya_telescope_preview_enabled true)

;; fnlfmt: skip
(when is.windows
  (opt
    shell (if (executable :pwsh) :pwsh :powershell)
    shellcmdflag "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;"
    shellredir "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    shellpipe "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode"
    shellquote ""
    shellxquote ""))

(when (has :termguicolors) (opt termguicolors true))
(when (has :nvim-0.9.0)
  (opt exrc true)
  (set vim.g.editorconfig true))

(vim.cmd "set nocompatible")
(vim.cmd "set t_ut=")
(when (= (. vim.env :TERM) :xterm-kitty) (vim.cmd "set t_Co=256"))

(vim.opt.shortmess:append :c)
(vim.opt.fillchars:append "eob: ")

(when (has :nvim-0.10.0)
  (fn osc52 [clipboard contents]
    (let [base (string.format "\027]52;%s;%s\027\\" clipboard contents)]
      (if (os.getenv :TMUX)
          (string.format "\027Ptmux;\027%s\027\\" base)
          base)))

  (fn copy [reg]
    (local clipboard (if (= reg "+") :c :p))
    (fn [lines]
      (->> (table.concat lines "\n")
           (vim.base64.encode)
           (osc52 clipboard)
           (io.stdout:write))))

  (local {: paste} (require :vim.ui.clipboard.osc52))
  (set vim.g.clipboard {:name :osc52
                        :copy {:+ (copy "+") :* (copy "*")}
                        :paste {:+ #0 :* #0}}))

(when is.termux
  (set vim.g.clipboard {:name :termux
                        :copy {:+ [:termux-clipboard-set]
                               :* [:termux-clipboard-set]}
                        :paste {:+ [:termux-clipboard-get]
                                :* [:termux-clipboard-get]}
                        :cache_enabled true}))

;; Disable provides
(set vim.g.loaded_perl_provider 0)
(set vim.g.loaded_ruby_provider 0)

;; Disable spell in terminals
(vim.api.nvim_create_autocmd :TermOpen
                             {:pattern "term://*" :command "setlocal nospell"})

nil

