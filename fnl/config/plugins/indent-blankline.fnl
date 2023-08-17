{:lazy true
 :event :BufRead
 :config (fn []
           ((. (require :indent_blankline) :setup)
            {:show_current_context true
             :show_current_context_start true
             :filetype_exclude [:alpha
                                :dashboard
                                :NvimTree
                                :help
                                :packer
                                :lsp-installer
                                :rfc
                                :DressingInput
                                :mason
                                :lazy]
             :buftype_exclude [:terminal]}))}
