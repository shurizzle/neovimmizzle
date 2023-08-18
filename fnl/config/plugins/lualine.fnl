(local DEFAULT_OPTS {:nerdfont true})

(fn fixed-text [text ?fts]
  (local filetypes (if (string? ?fts) [?fts] ?fts))
  {:sections          {:lualine_a [(const text)]}
   :inactive_sections {:lualine_c [(const text)]}
   : filetypes})

(fn config []
  (local opts DEFAULT_OPTS)

  (var symbols {:fileformat           []
                :line                 :LN
                :component_separators {:left "" :right ""}
                :section_separators   {:left "" :right ""}
                :filename             {:modified "[+]"
                                       :readonly "[-]"
                                       :unnamed  "[No Name]"}
                :diagnostics          {:error "E:"
                                       :warn  "W:"
                                       :info  "I:"
                                       :hint  "H:"}})

  (when opts.nerdfont
      (set symbols.fileformat         {:unix ""
                                       :dos  ""
                                       :mac  ""})
      (set symbols.line               "")
      (set symbols.section_separators {:left "" :right ""})
      (set symbols.filename           {:modified ""
                                       :readonly ""
                                       :unnamed ""})
      (set symbols.diagnostics        {:error " "
                                       :warn  " "
                                       :info  " "
                                       :hint  " "}))

  (fn fmt-enc []
    (local f vim.bo.fileformat)
    (.. (vim.opt.fileencoding:get)
        " "
        (or (. symbols.fileformat f) (.. "[" f "]"))))

  (fn file-status []
    (table.concat [(if vim.bo.modified symbols.filename.modified "")
                   (if (or (= false vim.bo.modifiable) vim.bo.readonly)
                       symbols.filename.readonly
                       "")]
                  " "))

  (fn pos [] (.. symbols.line ":%l:%v/%L %p%%"))

  (local space {1 (fn [] (if opts.nerdfont " " ""))
                :padding false})

  ((. (require :lualine) :setup)
   {:options           {:icons_enabled        opts.nerdfont
                        :theme                :bluesky
                        :component_separators symbols.component_separators
                        :section_separators   symbols.section_separators
                        :always_divide_middle true}
    :sections          {:lualine_a [:mode]
                        :lualine_b [:branch {1 :diagnostics
                                             :symbols symbols.diagnostics}]
                        :lualine_c [file-status]
                        :lualine_x [:file_type]
                        :lualine_y [fmt-enc]
                        :lualine_z [pos]}
    :inactive_sections {:lualine_a []
                        :lualine_b []
                        :lualine_c [file-status]
                        :lualine_x [:file_type]
                        :lualine_y [fmt-enc space pos]
                        :lualine_z []}
    :tabline []
    :extensions [(fixed-text "Telescope" "TelescopePrompt")
                 (fixed-text "Explorer" "NvimTree")
                 (fixed-text "Input" "DressingInput")
                 (fixed-text "Dashboard" "alpha")
                 (fixed-text "Scopes" "dapui_scopes")
                 (fixed-text "Breakpoints" "dapui_breakpoints")
                 (fixed-text "Stacks" "dapui_stacks")
                 (fixed-text "Watches" "dapui_watches")]}))


{:lazy false
 : config}
