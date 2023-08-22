{:config (fn [] (: (. (require :config.lang.lsp) :taplo) :catch
                   (fn [] ((require :config.lang.fallback) :taplo))))}
