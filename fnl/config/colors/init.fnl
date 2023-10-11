(local path (require :config.path))

(local resources {:foreground :#eeeeee
                  :background :#282828
                  :color0     :#282828
                  :color1     :#c8213d
                  :color2     :#169C51
                  :color3     :#DAAF19
                  :color4     :#2F90FE
                  :color5     :#C14ABE
                  :color6     :#48C6DB
                  :color7     :#CBCBCB
                  :color8     :#505050
                  :color9     :#C7213D
                  :color10    :#1ef15f
                  :color11    :#FFE300
                  :color12    :#00aeff
                  :color13    :#FF40BE
                  :color14    :#48FFFF
                  :color15    :#FFFFFF})

(fn get-highlights []
  (accumulate [res "" _ value (ipairs
                                ((require :shipwright.transform.lush.to_vimscript)
                                 (require :config.colors.bluesky)))]
    (.. res value "\n")))

(fn compile-terminal-colors []
  (faccumulate [res (.. "let g:terminal_color_fg = \""
                        resources.foreground
                        "\"\nlet g:terminal_color_bg = \""
                        resources.background
                        "\"\n")
                i 0 15]
               (.. res
                   "let g:terminal_color_"
                   (tostring i)
                   " = \""
                   (. resources (.. :color (tostring i)))
                   "\"\n")))

(fn get-theme []
  (.. "set background=dark\nhi clear\n"
      "if exists(\"syntax\")\n  syntax reset\nendif\n"
      "let g:colors_name=\"bluesky\"\n\n"
      (get-highlights)
      (compile-terminal-colors)
      "augroup set_highlight_colors\n"
      "  au!\n"
      "  autocmd VimEnter * lua require\"config.colors\"['set-highlight-colors']()\n"
      "  autocmd ColorScheme * lua require\"config.colors\"['set-highlight-colors']()\n"
      "augroup END"))

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
    (values key (tostring value))))

(fn generate-palette []
  (let [{: view} (require :fennel)
        (ok err) (write-file (path.join path.init-dir :fnl :config :colors :palette.fnl)
                             (view (get-palette)))]
    (if (not ok) (error err))))

(fn -sync []
  (let [theme (get-theme)
        (ok err) (write-file (get-colo-file) (get-theme))]
    (if (not ok) (error err))
    (generate-palette)
    (vim.api.nvim_exec theme false)
    (vim.cmd "doautocmd ColorScheme")))

(fn sync []
  (let [(ok err) (pcall -sync)]
    (if ok
        (vim.notify "colorscheme synchronized" :info {:title :Colors})
        (vim.notify err :error {:title :Colors}))))

(fn setup []
  (vim.cmd "command! ColoSync lua require'config.colors'.sync()<CR>")
  (vim.cmd.colorscheme :bluesky))

(fn set-highlight-colors []
  (vim.api.nvim_command "hi def link LspReferenceText CursorLine")
  (vim.api.nvim_command "hi def link LspReferenceWrite CursorLine")
  (vim.api.nvim_command "hi def link LspReferenceRead CursorLine")
  (vim.api.nvim_command "hi def link illuminatedWord CursorLine"))

{: sync
 : setup
 : set-highlight-colors}
