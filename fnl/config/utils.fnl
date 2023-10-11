(autoload [{: global-mangling} :fennel.compiler])
(fn global-set [name what]
  (tset _G name what)
  (tset _G (global-mangling name) what))

(let [prefix (if (has :terminal)
                 "terminal "
                 "noautocmd new | terminal ")
      f (fn [cmd]
          (let [(ok tt) (pcall require :toggleterm.terminal)]
            (if ok
                (: (tt.Terminal:new {: cmd
                                     :close_on_exit false
                                     :on_open (fn [] (vim.cmd :stopinsert!))})
                   :toggle)
                (vim.api.nvim_command (.. prefix cmd)))))]
  (global-set :term-run f))

(global-set :exepath (fn [exe]
                       (let [path (vim.fn.exepath exe)]
                         (if
                           (= "" path) nil
                           path))))

(fn _G.colorscheme [...]
  (if (= (length [...]) 0)
      (vim.api.nvim_exec :colo true)
      (if (= 1 (length [...]))
          (not= (vim.api.nvim_exec (.. "try | colo " (select 1 ...) " | catch /E185/ | echo 'fail' | entry") true) :fail)
          (each [_ name (ipairs [...])]
            (if (colorscheme name) (lua "return true"))))))

(fn _G.tabnext []
  (vim.api.nvim_command (if (not= 0 (vim.fn.exists ::BufferNext)) :BufferNext :tabn)))

(fn _G.tabprev []
  (vim.api.nvim_command (if (not= 0 (vim.fn.exists ::BufferPrevious)) :BufferPrevious :tabp)))

(fn capitalize [str]
  (if (= 0 (length str)) 
      str
      (.. (string.upper (string.sub str 1 1)) (string.sub str 2))))

(fn uncapitalize [str]
  (if (= 0 (length str)) 
      str
      (.. (string.lower (string.sub str 1 1)) (string.sub str 2))))

(fn next-word [str]
  (when str
    (let [s (string.gsub str "^[%s-_]+" "")]
      (when (not= 0 (length s))
        (let [(start stop) (string.find s "^[^%a%s-_]*[^%l%s-_]*[^%u%s-_]*")]
          (when (> stop 0)
            (values
              (string.lower (string.sub s start stop))
              (if (<= (+ stop 1) (length s)) (string.sub s (+ stop 1))))))))))

(fn split-words [str]
  (when (and str (not= 0 (length str)))
    (match [(next-word str)]
      (where [word nil] (not= nil word)) word
      (where [nil rest] (not= nil rest)) (split-words rest)
      (where [nil nil]) nil
      [word rest] (values word (split-words rest)))))

(local FORMATTERS {:upper  (fn [str] (table.concat (vim.tbl_map string.upper [(split-words str)]) :_))
                   :snake  (fn [str] (table.concat [(split-words str)] :_))
                   :kebab  (fn [str] (table.concat [(split-words str)] :-))
                   :pascal (fn [str] (table.concat (vim.tbl_map capitalize [(split-words str)]) ""))})
(tset FORMATTERS   :camel  (fn [str] (uncapitalize (FORMATTERS.pascal str))))

(lambda _G.convertcase [fmt str]
  (if (and (= :string (type str)) (not= 0 (length str)))
      (do
        (vim.validate {:fmt [fmt :s]})
        (let [formatter (. FORMATTERS fmt)]
          (if (= :function (type formatter))
              (formatter str)
              (error (.. "Invalid formatter " fmt)))))
      str))

(set _G.operatorfunction nil)
(fn _G.operatorfunction_apply [vmode]
  (if (function? _G.operatorfunction)
      (let [f _G.operatorfunction]
        (set _G.operatorfunction nil)
        (f vmode))))

(fn _G.set_operatorfunc [f]
  (set _G.operatorfunction f)
  (set vim.o.operatorfunc "v:lua.operatorfunction_apply"))
(global-set :set-operatorfunc _G.set_operatorfunc)
nil
