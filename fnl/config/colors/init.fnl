(local path (require :config.path))

(local resources {:fg :#eeeeee
                  :bg :#282828
                  0   :#282828
                  1   :#c8213d
                  2   :#169C51
                  3   :#DAAF19
                  4   :#2F90FE
                  5   :#C14ABE
                  6   :#48C6DB
                  7   :#CBCBCB
                  8   :#505050
                  9   :#C7213D
                  10  :#1ef15f
                  11  :#FFE300
                  12  :#00aeff
                  13  :#FF40BE
                  14  :#48FFFF
                  15  :#FFFFFF})

(fn get-highlights []
  (let [theme (require :config.colors.bluesky)
        ->vim (require :config.colors.blush.transpile.vimscript)]
    (->vim theme)))

(fn compile-terminal-colors []
  (fn merge [res resources key]
    (let [value (. resources key)]
      (if value
          (let [value (.. "let g:terminal_color_" (tostring key)
                          " = \"" value "\"")]
            (if res
                (.. res "\n" value)
                value))
          res)))

  (faccumulate [res (accumulate [res nil _ k (ipairs [:fg :bg])]
                      (merge res resources k))
                i 0 15]
               (merge res resources i)))

(fn get-theme []
  (.. "set background=dark\nhi clear\n"
      "if exists(\"syntax\")\n  syntax reset\nendif\n"
      "let g:colors_name=\"bluesky\"\n\n"
      (or (-?> (get-highlights) (.. "\n")) "")
      (or (-?> (compile-terminal-colors) (.. "\n")) "")
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
