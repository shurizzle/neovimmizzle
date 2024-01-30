(set vim.g.mapleader ",")
(set vim.g.maplocalleader ",")
(local {:set kset} vim.keymap)

(kset :n "<leader>," "," {:noremap true :silent true})

; Just use vim.
(each [_ key (ipairs [:Left :Right :Up :Down :PageUp :PageDown :End :Home :Del])]
  (let [name (if (= key :Del) :Delete key)]
    (each [mode prefix (pairs {:n "<cmd>" :v "<cmd><C-u>" :i "<C-o><cmd>"})]
      (kset mode (.. :< key :>) (.. prefix "echo \"No " name " for you!\"<CR>") {:noremap false :silent true}))))

(fn lsp-code-action [...]
  (vim.lsp.buf.code_action ...))
(fn lsp-declaration [...]
  (vim.lsp.buf.declaration ...))
(fn lsp-definition [...]
  (vim.lsp.buf.definition ...))
(fn lsp-hover [...]
  (vim.lsp.buf.hover ...))
(fn lsp-implementation [...]
  (vim.lsp.buf.implementation ...))
(fn lsp-add-workspace-folder [...]
  (vim.lsp.buf.add_workspace_folder ...))
(fn lsp-remove-workspace-folder [...]
  (vim.lsp.buf.remove_workspace_folder ...))
(fn lsp-type-definition [...]
  (vim.lsp.buf.type_definition ...))
(fn lsp-rename [...]
  (vim.lsp.buf.rename ...))
(fn lsp-references [...]
  (vim.lsp.buf.references ...))
(fn diagnostic-open-float [...]
  (vim.diagnostic.open_float ...))

(each [k [f d] (pairs {; Reselect visual selection after indenting
                       :< [:<gv "Indent back"]
                       :> [:>gv "Indent"]
                       ; Maintain the cursor position when yanking a visual selection
                       ; http://ddrscott.github.io/blog/2016/yank-without-jank/
                       :y ["myy`y" "yank text"]
                       :Y ["myY`y" "yank text until the end of the line"]
                       ; Paste replace visual selection without copying it
                       :<leader>p ["\"_dP" "Replace visual selection"]
                       ; Search for text in visual selection
                       :* ["\"zy/\\<\\V<C-r>=escape(@z, '/\\')<CR>\\><CR>"
                           "Search for selected text"]
                       :<leader>ca [lsp-code-action
                                    "Show available code actions"]})]
  (kset :v k f {:silent true :noremap true :desc d}))

(kset :x "@"
      (fn []
        (..  ":<C-u>'<,'>normal @"
             (vim.fn.nr2char (vim.fn.getchar))
             "<CR>"))
      {:silent true
       :noremap true
       :desc "Execute macro on multiple lines"
       :expr true})

(kset :n :gm
      (fn []
        (let [s (vim.fn.synID (vim.fn.line :.) (vim.fn.col :.) 1)]
          (vim.notify (.. (vim.fn.synIDattr s :name)
                           " -> "
                           (vim.fn.synIDattr (vim.fn.synIDtrans s) :name)))))
      {:silent true
       :noremap true
       :desc "Execute macro on multiple lines"
       :expr true})

(fn switch-case []
  (vim.api.nvim_echo [[" [u]pper [s]nake [k]ebab [p]ascal [c]amel" :Normal]] false [])
  (local map {:u :upper
              :s :snake
              :k :kebab
              :p :pascal
              :c :camel})
  (let [choice-c (match (vim.fn.getchar)
                  27 27
                  other (string.char other))
        choice (if (= choice-c 27) 27 (. map choice-c))]
    (match choice
      27 (vim.api.nvim_echo [["" :Normal]] false [])
      nil (vim.api.nvim_echo [["Invalid choice" :Error]] false [])
      _ (vim.fn.feedkeys (.. :ciw (string.char 18) "=v:lua.convertcase('" choice
                             "', getreg('\"'))" (string.char 10)
                             (string.char 27) ::echo (string.char 10))))))

(fn show-doc []
  (let [ft vim.bo.filetype]
    (if
      (or (= :vim ft) (= :help ft))
        (vim.cmd (.. "h " (vim.fn.expand "<cword>")))
      (= :man ft)
        (vim.cmd (.. "Man " (vim.fn.expand "<cword>")))
      (and (= :Cargo.toml (vim.fn.expand "%:t"))
           ((. (require :crates) :popup_available)))
        ((. (require :crates) :show_popup))
      (lsp-hover))))

(each [k [f d] (pairs {:<C-n> [_G.bufnext "Go to next tab"]
                       :<C-p> [_G.bufprev "Go to previous tab"]
                       ; Make Y behave like the other capitals
                       :Y [:y$ "Yank untill the end of the line"]
                       :<leader>cD  [lsp-declaration
                                     "Show under-cursor declaration"]
                       :<leader>cd  [lsp-definition
                                     "Show under-cursor definition"]
                       :<leader>ci  [lsp-implementation
                                     "Show under-cursor implementation"]
                       :<leader>cwa [lsp-add-workspace-folder
                                     "Add workspace folder"]
                       :<leader>cwr [lsp-remove-workspace-folder
                                     "Remove workspace folder"]
                       :<leader>cwl [#(print (vim.inspect (vim.lsp.buf.list_workspace_folders)))
                                     "List workspace folders"]
                       :<leader>ct  [lsp-type-definition
                                     "Show under-cursor type definition"]
                       :<leader>cr  [lsp-rename
                                     "Rename under-cursor word"]
                       :<leader>ca  [lsp-code-action
                                     "Show available code actions"]
                       :<leader>cR  [lsp-references
                                     "Show under-cursor references"]
                       :<leader>ce  [diagnostic-open-float
                                    "Show under-cursor diagnostics"]
                       :<leader>s   [switch-case
                                     "Switch case of under-cursor word"]
                       :K [show-doc "Show under-cursor help"]
                       "[c" [vim.diagnostic.goto_prev "Go to previous diagnostic"]
                       "]c" [vim.diagnostic.goto_next "Go to next diagnostic"]
                       ; :<space>d [(. (require :config.debug) :toggle)
                       ;            "Toggle dap-ui"]
                       :ZZ ["<cmd>BufferClose<CR>" "Close current buffer"]
                       :ZQ ["<cmd>BufferClose!<CR>"
                            "Close current buffer without saving"]
                       ; Make Y behave like the other capitals
                       :Y ["y$" "Yank untill the end of the line"]})]
  (kset :n k f {:silent true :noremap true :desc d}))

(each [k [f d] (pairs {:<C-h> ["<cmd>wincmd h<CR>"]
                       :<C-j> ["<cmd>wincmd j<CR>"]
                       :<C-k> ["<cmd>wincmd k<CR>"]
                       :<C-l> ["<cmd>wincmd l<CR>"]})]
  (kset :t k f {:silent true :noremap true :desc d})
  (kset :n k f {:silent true :noremap true :desc d}))

(kset :t "<C-,>" "<cmd>stopinsert!<cr>" {:silent true :noremap true})

(each [k [f d] (pairs {:<leader>ca [lsp-code-action
                                    "Show available code actions"]})]
  (kset :x k f {:silent true :noremap true :desc d}))

; floating temporary windows
(do
  (local float (require :config.float))

  (var gitui nil)
  (set gitui (float.make-term
                 {:cmd       :gitui
                  :behaviour :restart
                  :on-open   (fn [{:bufnr buffer}]
                               (vim.keymap.set
                                 :n :q (fn [] (gitui:close))
                                 {:noremap true :silent true : buffer}))}))
  (kset :n :<space>g #(gitui:toggle)
        {:noremap true :silent true :desc "Toggle floating gitui."})

  (var temp nil)
  (set temp (float.make-term {:behaviour :restart}))
  (kset :n :<space>t #(temp:toggle)
        {:noremap true :silent true :desc "Toggle floating term."})

  (var elinks nil)
  (set elinks
         (float.make-term
           {:cmd :elinks
            :on-open (fn [{:bufnr buffer}]
                       (vim.keymap.set
                         :n :q (fn [] (elinks:close))
                         {:noremap true :silent true : buffer}))}))
  (vim.keymap.set :n :<space>b
                  #(elinks:toggle)
                  {:noremap true :silent true :desc "Toggle tui browser."}))
