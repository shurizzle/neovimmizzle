{:cmd [:IlluminatePause
       :IlluminateResume
       :IlluminateToggle
       :IlluminatePauseBuf
       :IlluminateResumeBuf
       :IlluminateToggleBuf]
 :lazy true
 :event :BufRead
 :config (fn []
           ((. (require :illuminate) :configure)
            {:filetypes_denylist [:NvimTree
                                  :dashboard
                                  :alpha
                                  :TelescopePrompt
                                  :DressingInput]}))}
