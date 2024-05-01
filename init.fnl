(include :config.bootstrap)

(let [fns {:inspect (fn [what] (-> what (vim.inspect) (print)))
           :has (fn [what] (not= (vim.fn.has what) 0))
           :executable (fn [what] (not= (vim.fn.executable what) 0))
           :readonly-table (fn [t]
                             (setmetatable {}
                                           {:__index #(. t $2)
                                            :__newindex #nil}))}
      {: global-mangling} (require :fennel.compiler)]
  (each [name f (pairs (require :config.stdlib))]
    (tset _G (global-mangling name) f)
    (tset _G name f))
  (each [name f (pairs fns)]
    (tset _G (global-mangling name) f)
    (tset _G name f)))

(require :config.ft)
(require :config.utils)
(require :config.options)
((. (require :config.colors) :setup))
(require :config.keymaps)
((. (require :config.winbar) :setup))
(vim.api.nvim_create_autocmd :User
                             {:pattern :LazyDone
                              :callback #((. (require :config.lang) :config))})

(require :config.plugins)
