(: (. (require :config.lang.installer) :solidity-ls) :and-then
   (fn []
     ((. (require :lspconfig) :solidity_ls :setup)
      {:cmd [:solidity-ls :--stdio]
       :bin :solidity-ls})))
