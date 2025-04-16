(local path (require :config.path))

(fn dumptc [colors]
  (accumulate [res nil k v (pairs colors)]
    (let [value (.. "\tlet g:terminal_color_" (tostring k) " = \"" v "\"")]
      (if res (.. res "\n" value) value))))

(local dark-term-colors (dumptc {0 "#282828"
                                 1 "#c8213d"
                                 2 "#169C51"
                                 3 "#DAAF19"
                                 4 "#2F90FE"
                                 5 "#C14ABE"
                                 6 "#48C6DB"
                                 7 "#CBCBCB"
                                 8 "#505050"
                                 9 "#C7213D"
                                 10 "#1ef15f"
                                 11 "#FFE300"
                                 12 "#00aeff"
                                 13 "#FF40BE"
                                 14 "#48FFFF"
                                 15 "#FFFFFF"}))

(local light-term-colors (dumptc {0 "#282828"
                                  1 "#c8213d"
                                  2 "#169C51"
                                  3 "#DAAF19"
                                  4 "#2F90FE"
                                  5 "#C14ABE"
                                  6 "#48C6DB"
                                  7 "#CBCBCB"
                                  8 "#505050"
                                  9 "#C7213D"
                                  10 "#1ef15f"
                                  11 "#FFE300"
                                  12 "#00aeff"
                                  13 "#FF40BE"
                                  14 "#48FFFF"
                                  15 "#FFFFFF"}))

(fn get-highlights []
  (let [theme (require :config.colors.bluesky)
        ->vim (require :config.colors.blush.transpile.vimscript)]
    (.. "if &background ==# 'light'\n" (->vim theme.light "\t") "\n\n"
        light-term-colors "\nelse\n" (->vim theme.dark "\t") "\n\n"
        dark-term-colors "\nendif")))

(fn get-theme []
  (.. "highlight clear\n" "if exists(\"syntax\")\n  syntax reset\nendif\n" "let g:colors_name=\"bluesky\"

"
      (or (-?> (get-highlights) (.. "\n")) "") "
if has('terminal')
\thighlight! link StatusLineTerm StatusLine
\thighlight! link StatusLineTermNC StatusLineNC
\tlet g:terminal_ansi_colors = [
\t\t\\ g:terminal_color_0,
\t\t\\ g:terminal_color_1,
\t\t\\ g:terminal_color_2,
\t\t\\ g:terminal_color_3,
\t\t\\ g:terminal_color_4,
\t\t\\ g:terminal_color_5,
\t\t\\ g:terminal_color_6,
\t\t\\ g:terminal_color_7,
\t\t\\ g:terminal_color_8,
\t\t\\ g:terminal_color_9,
\t\t\\ g:terminal_color_10,
\t\t\\ g:terminal_color_11,
\t\t\\ g:terminal_color_12,
\t\t\\ g:terminal_color_13,
\t\t\\ g:terminal_color_14,
\t\t\\ g:terminal_color_15
\t\t\\ ]
endif"))

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
  (pcall #(vim.cmd.colorscheme :bluesky)))

{: sync : setup}

