(fn config []
  (let [dap (require :dap)
        dapui (require :dapui)
        open (fn [] (dapui.open []))
        close (fn []
                (dapui.close [])
                (dap.repl.close))]
    (dapui.setup)
    (set dap.listeners.after.event_initialized.dapui_config open)
    (set dap.listeners.before.event_terminated.dapui_config close)
    (set dap.listeners.before.event_exited.dapui_config close)))

{:lazy true
 : config}
