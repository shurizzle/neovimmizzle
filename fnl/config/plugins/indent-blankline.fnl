{:lazy  true
 :event :BufRead
 :main  :ibl
 :opts  {:scope   {:enabled            true
                   :show_start         true
                   :show_end           false
                   :injected_languages true}
         :exclude {:filetypes [:alpha
                               :dashboard
                               :NvimTree
                               :help
                               :packer
                               :lsp-installer
                               :rfc
                               :DressingInput
                               :mason
                               :lazy]
                   :buftypes  [:terminal]}}}
