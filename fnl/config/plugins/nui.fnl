(fn get-prompt-text [prompt default-prompt]
  (let [prompt-text (or prompt default-prompt)]
    (if (= ":" (prompt-text:sub -1))
        (.. "[" (prompt-text:sub 1 -2) "]")
        prompt-text)))

(fn override-ui-input []
  (local Input (require :nui.input))
  (local ui-input (Input:extend :UIInput))

  (fn init [self opts on-done]
    (local border-top-text (get-prompt-text opts.prompt "[Input]"))
    (local default-value (tostring (or opts.default "")))
    (ui-input.super.init self
                         {:relative :cursor
                          :position {:row 1 :col 0}
                          :size {:width (math.max 20
                                                  (vim.api.nvim_strwidth default-value))}
                          :border {:style :rounded
                                   :text {:top border-top-text
                                          :top_align :left}}
                          :win_options {:winhighlight "NormalFloat:Normal,FloatBorder:Normal"}}
                         {:default_value default-value
                          :on_close #(on-done nil)
                          :on_submit #(on-done $1)})
    (local {: event} (require :nui.utils.autocmd))
    (self:on event.BufLeave #(on-done nil) {:once true})
    (self:map :n :<Esc> #(on-done nil) {:noremap true :nowait true}))

  (set ui-input.init init)
  (var input-ui nil)

  (fn input [opts on-confirm]
    (assert (function? on-confirm) "missing on-confirm function")
    (when input-ui
      (vim.api.nvim_err_writeln "busy: another input is pending!")
      (lua :return))
    (set input-ui (ui-input opts
                            (fn [value]
                              (when input-ui (input-ui:unmount))
                              (on-confirm value)
                              (set input-ui nil))))
    (input-ui:mount))

  (set vim.ui.input input))

(fn config []
  (override-ui-input))

{:lazy true : config}
