(fn open []
  (let [(ok dapui) (pcall require :dapui)] (if ok (dapui.open [])))
  (let [(ok dapuiwin) (pcall require :dapui.windows)]
    (if ok
        (let [(ok state) (pcall require :bufferline.api)]
          (if ok
              (state.set_offset dapuiwin.sidebar.area_state.size :Debugger))))))

(fn close []
  (let [(ok dapui) (pcall require :dapui)] (if ok (dapui.close [])))
  (let [(ok state) (pcall require :bufferline.api)] (if ok (state.set_offset 0))))

(fn toggle []
  (let [(ok dapuiwin) (pcall require :dapui.windows)]
    (if ok
        (if (dapuiwin.sidebar:is_open)
            (close)
            (open)))))

{: open
 : close
 : toggle}
