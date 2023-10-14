(autoload [{: is} :config.platform])

(macro opt [& opts]
  (assert-compile (= (% (length opts) 2) 0) "Invalid options syntax" opts)
  (fcollect [i 1 (length opts) 2]
            `(tset vim.opt ,(tostring (. opts i)) ,(. opts (+ i 1)))))

(opt autoread true
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
     guifont (.. :monospace:h (if is.macos 11 10))
     laststatus 3
     showmode false
     spell true
     spelllang :en)

(set vim.g.neovide_cursor_vfx_mode :torpedo)

(set vim.g.himalaya_mailbox_picker :telescope)
(set vim.g.himalaya_telescope_preview_enabled true)

(when is.windows
  (opt shell :powershell
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

(when (and (has :unix) (executable :lemonade) is.ssh)
  (set vim.g.clipboard {:name :lemonade
                        :copy  {:+ [:lemonade :copy]
                                :* [:lemonade :copy]}
                        :paste {:+ [:lemonade :paste]
                                :* [:lemonade :paste]}
                        :cache_enabled true}))

(when is.termux
  (set vim.g.clipboard {:name :termux
                        :copy  {:+ [:termux-clipboard-set]
                                :* [:termux-clipboard-set]}
                        :paste {:+ [:termux-clipboard-get]
                                :* [:termux-clipboard-get]}
                        :cache_enabled true}))

; Disable provides
(set vim.g.loaded_perl_provider 0)
(set vim.g.loaded_ruby_provider 0)
nil
