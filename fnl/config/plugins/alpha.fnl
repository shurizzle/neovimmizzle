(local neovim
       ["                               __                "
        "  ___     ___    ___   __  __ /\\_\\    ___ ___    "
        " / _ `\\  / __`\\ / __`\\/\\ \\/\\ \\\\/\\ \\  / __` __`\\  "
        "/\\ \\/\\ \\/\\  __//\\ \\_\\ \\ \\ \\_/ |\\ \\ \\/\\ \\/\\ \\/\\ \\ "
        "\\ \\_\\ \\_\\ \\____\\ \\____/\\ \\___/  \\ \\_\\ \\_\\ \\_\\ \\_\\"
        " \\/_/\\/_/\\/____/\\/___/  \\/__/    \\/_/\\/_/\\/_/\\/_/"])

(local fireworks
       ["                                   .''.          "
        "       .''.      .        *''*    :_\\/_:     .   "
        "      :_\\/_:   _\\(/_  .:.*_\\/_*   : /\\ :  .'.:.'."
        "  .''.: /\\ :   ./)\\   ':'* /\\ * :  '..'.  -=:o:=-"
        " :_\\/_:'.:::.    ' *''*    * '.\\'/.' _\\(/_'.':'.'"
        " : /\\ : :::::     *_\\/_*     -= o =-  /)\\    '  *"
        "  '..'  ':::'     * /\\ *     .'/.\\'.   '         "
        "      *            *..*         :                "])

(local mistletoe
       ["⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣶⡿⠿⠿⣶⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠟⠉⠀⠀⠀⠀⠀⠙⣷⣄⣠⣤⣤⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⡏⠀⠀⠀⠀⠀⠀⠀⠀⢸⡏⠁⠀⠀⠈⠻⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠸⣿⠀⠀⠀⠀⠀⢹⣇⠀⠀⠀⣠⣴⣿⡀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⢀⣀⠀⠀⠀⠹⣷⡀⠀⠀⠀⠀⠀⠀⢀⣴⠆⠀⠀⠀⠀⠀⣸⣿⣤⣴⠿⠛⠉⠸⣷⣤⣶⠟⢿⣦⡀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠈⣿⠛⠿⠿⠿⠟⢿⣶⣤⣀⣀⣤⡶⠟⢧⣀⠀⠀⠀⣀⣴⣿⣁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢷⣶⣤⣤⣄⣀"
        "⠀⠀⠀⠀⠀⠀⠀⢀⣿⠀⠀⠀⠀⠀⣠⣼⣿⣏⠉⠁⠀⠀⠈⢹⡿⠿⠿⣿⡉⠙⠛⠿⢿⣶⣦⣤⣄⣀⣀⣀⣀⣠⡴⠀⠀⣀⣽⡿⠿⠛"
        "⠀⠀⠀⠀⠀⠀⢀⣾⠇⠀⠀⠀⣠⣾⡿⠋⠀⠻⣷⣤⣀⣀⣤⣿⣦⣄⡀⢹⣧⠀⠀⠀⠀⠀⠀⠉⠉⠉⠉⠉⠉⠀⢀⣴⡿⠛⠉⠀⠀⠀"
        "⠀⠀⠀⠀⣀⣴⠟⠁⠀⢀⣤⡾⠟⠁⠀⠀⠀⠀⠈⢿⣟⢻⣯⡀⠉⠛⠛⠿⣿⣀⣤⣴⣶⣶⣶⣤⣄⡀⠀⠀⣠⣾⠟⠁⠀⠀⠀⠀⠀⠀"
        "⠀⢶⡶⠟⠋⠁⠀⠀⣠⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⢈⣿⣦⡹⣿⣦⠀⠀⢸⣿⢿⡏⠁⠀⠀⠈⠉⠻⣿⣦⣴⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠈⢿⡄⠀⠀⢀⣾⠟⠀⠀⠀⠀⠀⢀⣤⣶⣾⡟⠛⠛⠛⠃⠈⠻⣷⣄⠀⠀⠈⢿⣦⡀⠀⠀⠀⠀⠈⠻⠟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠘⣧⠀⢠⡿⠁⠀⠀⠀⠀⢀⣶⡿⠋⣴⣿⣀⡀⠀⠀⠀⠀⠀⠈⢿⣷⣄⠀⠀⠙⠿⣷⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⢰⡏⠀⠙⠀⠀⠀⠀⠀⢠⣿⠏⠀⠸⠟⠛⠛⠻⣷⣦⡀⠀⠀⠀⠀⠙⢿⣦⠀⠀⠀⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⣠⣿⣀⣤⣴⣶⣶⢶⣦⣄⣾⡏⠀⠀⠀⠀⠀⠀⠀⠈⢻⣷⡀⠀⠀⠀⠀⠀⢻⣧⡀⠀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⣴⣿⠿⠛⠋⠉⠀⠀⠀⠈⠙⠿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡇⠀⠀⠀⠀⠀⠀⠻⣧⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠿⠿⠛⠛⠛⠿⢷⣦⣄⡀⢸⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣼⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
        "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"])

(local rip ["     ⣿⣿    "
            "   ⣿⣿⣿⣿⣿⣿  "
            "     ⣿⣿    "
            "     ⣿⣿    "
            "     ⣿⣿    "
            ""
            "1961 - 2023"])

(fn packer-message []
  (if (not (nil? _G.packer_plugins))
      (.. "🎉 neovim loaded "
          (vim.tbl_count (vim.tbl_filter #($1.loaded) _G.packer_plugins)) "/"
          (vim.tbl_count _G.packer_plugins) " plugins")))

(fn lazy-message []
  (let [(ok cfg) (pcall require :lazy.core.config)]
    (if ok
        (let [[total loaded] (accumulate [ps [0 0] _ p (pairs cfg.plugins)]
                               [(inc (. ps 1))
                                (+ (if p._.loaded 1 0) (. ps 2))])]
          (.. "🎉 neovim loaded " loaded "/" total " plugins")))))

(fn message []
  (or (packer-message) (lazy-message) "🎉 Have fun with neovim"))

(fn config []
  (local header {:type :text
                 :val (match (os.date "%d%m")
                        (where :0308) rip
                        (where (or :2412 :2512)) mistletoe
                        (where (or :3112 :0101)) fireworks
                        _ neovim)
                 :opts {:position :center :hl :Type}})
  (local buttons {:type :group
                  :val (let [{: button} (require :alpha.themes.dashboard)]
                         [(button :e "  New file" "<cmd>ene <CR>")
                          (button "COMMA f f" "󰈞  Find file")
                          (button "COMMA f g" "󰈬  Find word")
                          (button "COMMA f h" "󰡯  Help")])
                  :opts {:spacing 1}})
  (local footer {:type :text
                 :val (message)
                 :opts {:position :center :hl :Number}})
  ((. (require :alpha) :setup) {:layout [{:type :padding :val 2}
                                         header
                                         {:type :padding :val 2}
                                         buttons
                                         footer]
                                :opts {:margin 5}}))

{:lazy false : config}
