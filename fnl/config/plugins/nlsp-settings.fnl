(fn config []
  (let [nlsp (require :nlspsettings)
        path (require :config.path)]
    (nlsp.setup {:config_home (path.join (vim.fn.stdpath :config) :nlsp-settings)
                 :local_settings_dir :.nlsp-settings
                 :append_default_schemas true
                 :loader :json})))

{:lazy true
 :cmd :LspSettings
 : config}
