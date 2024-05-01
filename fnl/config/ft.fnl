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

nil
