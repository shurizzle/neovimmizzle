(local bindings
       {:db [:toggle_breakpoint "Toggle breakpoint"]
        :dp [:step_back "Step back"]
        :di [:step_into "Step into"]
        :do [:step_out "Step out"]
        :dd [:step_over "Step over"]})

(fn config []
  (let [dap (require :dap)]
    (each [k [f desc] (pairs bindings)]
      (vim.keymap.set :n (.. :<leader> k) (. dap f)
                      {:silent true :noremap true : desc}))))

{:lazy true
 :keys (icollect [k [_ desc] (pairs bindings)]
         {:mode :n : desc 1 (.. :<leader> k)})
 : config}

