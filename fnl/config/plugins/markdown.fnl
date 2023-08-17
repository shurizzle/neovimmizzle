{:lazy true
 :ft :markdown
 :config (fn []
          (set vim.g.nvim_markdown_preview_theme :github)
          (if (not= 0 (or vim.g.started_by_firenvim 0)) 
              (set vim.g.instant_markdown_autostart 0)))}
