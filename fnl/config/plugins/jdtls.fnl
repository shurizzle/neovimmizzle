(local {: bin-or-install : callback-memoize} (require :config.lang.util))

(local *config* [])
(var *installer* nil)

(fn config [bin]
  (if bin
      (set *config*.cmd [bin])
      (set *config*.cmd [:jdtls]))
  (set *config*.root_dir
       ((. (require :jdtls.setup) :find_root) [:.git :mvnw :gradlew])))

(fn install [cb]
  (bin-or-install :jdtls (fn [bin] (cb (config bin)))))

(fn installer []
  (if *installer*
      *installer*
      (let [inst (callback-memoize install)]
        (set *installer* inst)
        inst)))

(fn callback [{: buf}]
  ((installer) (fn []
                 (vim.api.nvim_buf_call buf
                                        #((. (require :jdtls) :start_or_attach) *config*)))))

(fn init []
  (vim.api.nvim_create_autocmd :FileType {:pattern :java : callback}))

{:lazy true : init}
