(local lualine-require (require :lualine_require))
(local modules (lualine-require.lazy_require {:highlight :lualine.highlight
                                              :utils :lualine.utils.utils}))
(var M (: (lualine-require.require :lualine.component) :extend))

(macro if-require [varname package then ?else]
    `(let [(ok# ,varname) (pcall require ,package)]
       (if ok# ,then ,?else)))

(local default-options {:colored true
                        :icon_only false})

(fn M.init [self options]
  (M.super.init self options)
  (set self.options (vim.tbl_deep_extend :keep (or self.options []) default-options))
  (set self.icon_hl_cache []))

(fn M.update_status []
  (modules.utils.stl_escape (or vim.bo.filetype "")))

(fn M.apply_icon [self]
  (fn current-icon []
    (if-require devicons :nvim-web-devicons
      (let [(icon0 icon-hl-group0) (devicons.get_icon_by_filetype vim.bo.filetype)
            (icon icon-hl-group) (if (and (= nil icon0) (= nil icon-hl-group0))
                                     (values : :DevIconDefault)
                                     (values icon0 icon-hl-group0))]
        (if self.options.colored
            (let [hl-color (modules.utils.extract_highlight_colors icon-hl-group :fg)]
              (if hl-color
                  (let [default-hl (self:get_default_hl)
                        icon-hl0 (. self.icon_hl_cache hl-color)
                        icon-hl (if (or (not icon-hl0)
                                        (not (modules.highlight.highlight_exists (.. icon-hl0.name :_normal))))
                                    (let [res (self:create_hl {:fg hl-color} icon-hl-group)]
                                      (tset self.icon_hl_cache hl-color res)
                                      res)
                                    icon-hl0)]
                    (.. (self:format_hl icon-hl) icon default-hl))
                  icon))
            icon))
      (if (not= 0 (vim.fn.exists :*WebDevIconsGetFileTypeSymbol))
        (vim.fn.WebDevIconsGetFileTypeSymbol))))
  (when self.options.icons_enabled
    (let [icon (current-icon)]
      (when icon
        (set self.status (if self.options.icon_only
                             icon
                         (if (and (= :table (type self.options.icon))
                                  (= :right self.options.icon.align))
                             (.. self.status " " icon)
                             (.. icon " " self.status))))))))

M
