(local {: bin-or-install : lint} (require :config.lang.util))

(set vim.env.ESLINT_D_PPID (vim.fn.getpid))

(fn [cb]
  (bin-or-install :eslint_d (lint :eslint_d
                                  [:--format
                                   :json
                                   :--stdin
                                   :--stdin-filename
                                   #(vim.api.nvim_buf_get_name 0)]
                                  cb)))
