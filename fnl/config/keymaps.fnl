(set vim.g.mapleader ",")
(set vim.g.maplocalleader ",")
(local {:set kset} vim.keymap)

(kset :n "<leader>," "," {:noremap true :silent true})

; Just use vim.
(each [_ key (ipairs [:Left :Right :Up :Down :PageUp :PageDown :End :Home :Del])]
  (let [name (if (= key :Del) :Delete key)]
    (each [mode prefix (pairs {:n "<cmd>" :v "<cmd><C-u>" :i "<C-o><cmd>"})]
      (kset mode (.. :< key :>) (.. prefix "echo \"No " name " for you!<CR>\"") {:noremap false :silent true}))))

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
                       :<leader>ca [vim.lsp.buf.code_action
                                    "Show available code actions"]})]
  (kset :v k f {:silent true :noremap true :desc d}))

(vim.cmd "
function! ExecuteMacroOverVisualRange()
  echo \"@\".getcmdline()
  execute \":'<,'>normal @\".nr2char(getchar())
endfunction
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
endfun
nnoremap gm <cmd>call SynGroup()<CR>
")

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

(each [k [f d] (pairs {:<C-n> [_G.tabnext "Go to next tab"]
                       :<C-p> [_G.tabprev "Go to previous tab"]
                       ; Make Y behave like the other capitals
                       :Y [:y$ "Yank untill the end of the line"]
                       :<leader>cD  [vim.lsp.buf.declaration
                                     "Show under-cursor declaration"]
                       :<leader>cd  [vim.lsp.buf.definition
                                     "Show under-cursor definition"]
                       :<leader>ci  [vim.lsp.buf.implementation
                                     "Show under-cursor implementation"]
                       :<leader>cwa [vim.lsp.buf.add_workspace_folder
                                     "Add workspace folder"]
                       :<leader>cwr [vim.lsp.buf.remove_workspace_folder
                                     "Remove workspace folder"]
                       :<leader>cwl [#(print (vim.inspect (vim.lsp.buf.list_workspace_folders)))
                                     "List workspace folders"]
                       :<leader>ct  [vim.lsp.buf.type_definition
                                     "Show under-cursor type definition"]
                       :<leader>cr  [vim.lsp.buf.rename
                                     "Rename under-cursor word"]
                       :<leader>ca  [vim.lsp.buf.code_action
                                     "Show available code actions"]
                       :<leader>cR  [vim.lsp.buf.references
                                     "Show under-cursor references"]
                       :<leader>ce  [vim.diagnostic.open_float
                                    "Show under-cursor diagnostics"]
                       :<leader>s   [switch-case
                                     "Switch case of under-cursor word"]
                       :K [vim.lsp.buf.hover "Show under-cursor help"]
                       "[c" [vim.diagnostic.goto_prev "Go to previous diagnostic"]
                       "]c" [vim.diagnostic.goto_next "Go to next diagnostic"]
                       :<space>d [(. (require :config.debug) :toggle)
                                  "Toggle dap-ui"]
                       :ZZ ["<cmd>BufferClose<CR>" "Close current buffer"]
                       :ZQ ["<cmd>BufferClose!<CR>"
                            "Close current buffer without saving"]
                       :Y ["y$" "Yank untill the end of the line"]
                       ; Make Y behave like the other capitals
                       :<leader>ca [vim.lsp.buf.code_action
                                    "Show available code actions"] })]
  (kset :n k f {:silent true :noremap true :desc d}))

(each [k [f d] (pairs {:<C-h> ["<cmd>wincmd h<CR>"]
                       :<C-j> ["<cmd>wincmd j<CR>"]
                       :<C-k> ["<cmd>wincmd k<CR>"]
                       :<C-l> ["<cmd>wincmd l<CR>"]})]
  (kset :t k f {:silent true :noremap true :desc d})
  (kset :n k f {:silent true :noremap true :desc d}))

(kset :t "<C-,>" "<cmd>stopinsert!<cr>" {:silent true :noremap true})

(each [k [f d] (pairs {:<leader>ca [vim.lsp.buf.code_action
                                    "Show available code actions"]})]
  (kset :x k f {:silent true :noremap true :desc d}))

; floating temporary windows
(do
  (local float (require :config.float))

  (var lazygit nil)
  (set lazygit (float.make-term
                 {:cmd :lazygit
                  :behaviour :restart
                  :on-open (fn [{:bufnr buffer}]
                             (vim.keymap.set
                               :n :q (fn [] (lazygit:close))
                               {:noremap true :silent true : buffer}))}))
  (kset :n :<space>g #(lazygit:toggle)
        {:noremap true :silent true :desc "Toggle floating lazygit."})

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
