(local path (require :config.path))

(local base-colors ["#282828"
                    "#c8213d"
                    "#169C51"
                    "#DAAF19"
                    "#2F90FE"
                    "#C14ABE"
                    "#48C6DB"
                    "#CBCBCB"
                    "#505050"
                    "#C7213D"
                    "#1ef15f"
                    "#FFE300"
                    "#00aeff"
                    "#FF40BE"
                    "#48FFFF"
                    "#FFFFFF"])

(local resources (collect [k v (ipairs base-colors)] (values (- k 1) v)))
(set resources.fg "#eeeeee")
(set resources.bg (. base-colors 1))

(fn get-highlights []
  (let [theme (require :config.colors.bluesky)
        ->vim (require :config.colors.blush.transpile.vimscript)]
    (.. "if &background ==# 'light'\n" (->vim theme.light "\t") "\nelse\n"
        (->vim theme.dark "\t") "\nendif")))

(fn compile-terminal-colors []
  (fn merge [res resources key]
    (let [value (. resources key)]
      (if value
          (let [value (.. "let g:terminal_color_" (tostring key) " = \"" value
                          "\"")]
            (if res
                (.. res "\n" value)
                value))
          res)))

  (faccumulate [res (accumulate [res nil _ k (ipairs [:fg :bg])]
                      (merge res resources k)) i 0 15]
    (merge res resources i)))

(fn get-theme []
  (.. "hi clear\n" "if exists(\"syntax\")\n  syntax reset\nendif\n" "let g:colors_name=\"bluesky\"

"
      (or (-?> (get-highlights) (.. "\n")) "")
      (or (-?> (compile-terminal-colors) (.. "\n")) "")))

(fn write-file [file content]
  (let [(f err) (io.open file :w+b)]
    (if f
        (let [(ok err) (f:write content)]
          (if ok
              (do
                (f:close)
                (values true nil))
              (values false err)))
        (values false err))))

(fn get-colo-file []
  (path.join (vim.fn.stdpath :config) :colors :bluesky.vim))

(fn get-palette []
  (collect [key value (pairs (require :config.colors.bluesky.palette))]
    (values key (collect [k v (pairs value)]
                  (values k (tostring v))))))

(fn generate-palette []
  (let [{: view} (require :fennel)
        (ok err) (write-file (path.join path.init-dir :fnl :config :colors
                                        :palette.fnl)
                             (view (get-palette)))]
    (if (not ok) (error err))))

(fn -sync []
  (let [theme (get-theme)
        (ok err) (write-file (get-colo-file) (get-theme))]
    (if (not ok) (error err))
    (generate-palette)
    (vim.api.nvim_exec theme false)))

(fn sync []
  (let [(ok err) (pcall -sync)]
    (if ok
        (vim.notify "colorscheme synchronized" :info {:title :Colors})
        (vim.notify err :error {:title :Colors}))))

(fn setup []
  (vim.cmd "command! ColoSync lua require'config.colors'.sync()<CR>")
  (pcall #(vim.cmd.colorscheme :habamax))
  ;; (pcall #(vim.cmd.colorscheme :bluesky))
  )

{: sync : setup}

