(local add vim.filetype.add)

(add {:filename {:pezzo.conf :pezzo :pezzo.d/*.conf :pezzo}})

(add {:extension {:nu :nu}})

(add {:extension (collect [_ k (ipairs [:vert
                                        :tesc
                                        :tese
                                        :glsl
                                        :geom
                                        :frag
                                        :comp
                                        :rgen
                                        :rint
                                        :rchit
                                        :rahit
                                        :rmiss
                                        :rcall])]
                   (values k :glsl))})

(add {:extension {:zig :zig :zir :zir}})

(add {:extension {:wgsl :wgsl}})

(add {:extension {:roc :roc}})

(vim.api.nvim_create_autocmd :FileType
                             {:pattern :wgsl
                              :callback (fn [{: buf}]
                                          (tset (. vim.bo buf) :commentstring
                                                "/*%s*/"))})

(vim.api.nvim_create_autocmd :FileType
                             {:pattern :fennel
                              :callback (fn [{: buf}]
                                          (tset (. vim.bo buf) :commentstring
                                                ";;%s"))})

(vim.api.nvim_create_autocmd :FileType
                             {:desc "Force commentstring to include spaces"
                              :callback (fn [{: buf}]
                                          (tset (. vim.bo buf) :commentstring
                                                (-> (. vim.bo buf
                                                       :commentstring)
                                                    (: :gsub "(%S)%%s" "%1 %%s")
                                                    (: :gsub "%%s(%S)" "%%s %1"))))})

(vim.api.nvim_create_autocmd :FileType
                             {:pattern :rust
                              :callback (fn [{: buf}]
                                          (tset (. vim.b buf) :rustfmt_autosave
                                                false))})

(vim.api.nvim_create_autocmd :TermOpen
                             {:command "setlocal nonumber norelativenumber"})

(set vim.g.rustfmt_autosave false)

nil
