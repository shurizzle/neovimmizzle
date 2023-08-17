(include :config.bootstrap)

(let [{: global-mangling} (require :fennel.compiler)]
  (each [name f (pairs (require :config.stdlib))]
    (tset _G (global-mangling name) f)
    (tset _G name f)))

(let [fns {:inspect        (fn [what] (-> what (vim.inspect) (print)))
           :has            (fn [what] (not= (vim.fn.has what) 0))
           :executable     (fn [what] (not= (vim.fn.executable what) 0))
           :readonly-table (lambda [t] (setmetatable {} {:__index #(. t $2)}))}
      {: global-mangling}  (require :fennel.compiler)]
  (each [name f (pairs fns)]
    (tset _G (global-mangling name) f)
    (tset _G name f)))

(require :config.ft)
(require :config.utils)
(require :config.options)
((. (require :config.colors) :setup))
(require :config.keymaps)
((. (require :config.winbar) :setup))
(require :config.plugins)
(require :config.rust)
((. (require :config.lang) :config))
