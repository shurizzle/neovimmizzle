(local bindings
       {:db [:toggle_breakpoint "Toggle breakpoint"]
        :dp [:step_back "Step back"]
        :di [:step_into "Step into"]
        :do [:step_out "Step out"]
        :dd [:step_over "Step over"]})

(fn config []
  (fn dapui [name ...]
    (let [(ok dapui) (pcall #(require :dapui))]
      (when ok
        (: dapui name ...))))

  (let [dap (require :dap)]
    (each [k [f desc] (pairs bindings)]
      (vim.keymap.set :n (.. :<leader> k) (. dap f)
                      {:silent true :noremap true : desc}))
    (set dap.listeners.before.attach.dapui_config #(dapui :open))
    (set dap.listeners.before.launch.dapui_config #(dapui :open))
    (set dap.listeners.before.event_terminated.dapui_config #(dapui :close))
    (set dap.listeners.before.event_exited.dapui_config #(dapui :close))
    (set dap.json_decode (. (require :json5) :parse))))

{:lazy true
 :deps [:json5]
 :keys (icollect [k [_ desc] (pairs bindings)]
         {:mode :n : desc 1 (.. :<leader> k)})
 : config}

