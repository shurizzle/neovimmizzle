(fn has-words-before []
  (let [[line col] (vim.api.nvim_win_get_cursor 0)]
    (and (not= 0 col)
         (nil? (-> (vim.api.nvim_buf_get_lines 0 (dec line) line true)
                   (. 1)
                   (: :sub col col)
                   (: :match "%s"))))))

(fn config []
  (local cmp (require :cmp))
  (local luasnip (require :luasnip))
  (local kind_icons {:Text ""
                     :Method ""
                     :Function ""
                     :Constructor ""
                     :Field ""
                     :Variable ""
                     :Class ""
                     :Interface ""
                     :Module ""
                     :Property ""
                     :Unit ""
                     :Value ""
                     :Enum ""
                     :Keyword ""
                     :Snippet ""
                     :Color ""
                     :File ""
                     :Reference ""
                     :Folder ""
                     :EnumMember ""
                     :Constant ""
                     :Struct ""
                     :Event ""
                     :Operator ""
                     :TypeParameter ""})
  (local source_names {:nvim_lsp "[Lsp]"
                      :treesitter "[Tre]"
                      :luasnip "[Snp]"
                      :buffer "[Buf]"
                      :nvim_lua "[Lua]"
                      :path "[Pat]"
                      :calc "[Clc]"
                      :emoji "[Emj]"
                      :rg1 "[Rg]"
                      :orgmode "[Org]"
                      :crates "[Crg]"})
  (local duplicates {:buffer 1
                     :path 1
                     :nvim_lsp nil
                     :luasnip 1})
  (local duplicates_default nil)
  (set vim.opt.completeopt [:menu :menuone :noselect])

  (cmp.setup
    {:completion {:keyword_length 1}
     :experimental {:native_menu false}
     :formatting {:fields [:kind :abbr :menu]
                  :format (fn [entry vim_item]
                            (set vim_item.kind
                                 (. kind_icons vim_item.kind))
                            (set vim_item.menu
                                 (. source_names entry.source.name))
                            (set vim_item.dup
                                 (or (. duplicates entry.source.name)
                                     duplicates_default))
                            vim_item)}
     :window {:documentation {:border ["╭" "─" "╮" "│" "╯" "─" "╰" "│"]}}
     :sources [{:name "nvim_lsp"}
               {:name "luasnip"}
               {:name "treesitter"}
               {:name "buffer"}
               {:name "async_path"}
               {:name "calc"}
               {:name "emoji"}
               {:name "orgmode"}]
     :snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}
     :preselect :None
     :mapping {:<C-u> (cmp.mapping (cmp.mapping.scroll_docs -4) [:i :c])
               :<C-f> (cmp.mapping (cmp.mapping.scroll_docs  4) [:i :c])
               :<C-y> cmp.config.disable
               :<C-n> cmp.config.disable
               :<C-Space> (cmp.mapping (cmp.mapping.complete []) [:i :c])
               :<Tab> (cmp.mapping
                        (fn [fallback]
                          (if
                            (cmp.visible) (cmp.select_next_item)
                            (luasnip.expand_or_jumpable) (luasnip.expand_or_jump)
                            (has-words-before) (cmp.complete)
                            (fallback)))
                        [:i :s])
               :<S-Tab> (cmp.mapping
                          (fn [fallback]
                            (if
                              (cmp.visible) (cmp.select_prev_item)
                              (luasnip.jumpable -1) (luasnip.jump -1)
                              (fallback)))
                          [:i :s])
               :<Esc> {:c (cmp.mapping.abort)}
               :<CR> (cmp.mapping
                       {:i (fn [fallback]
                             (if (cmp.visible)
                                 (if (cmp.get_selected_entry)
                                     (cmp.confirm)
                                     (cmp.confirm
                                       {:behaviour cmp.ConfirmBehavior.Replace
                                        :select false}))
                                 (fallback)))
                        :s (cmp.mapping.confirm {:select true})
                        :c (cmp.mapping.confirm
                             {:behaviour cmp.ConfirmBehavior.Replace
                              :select true})
                       })}})
  (cmp.setup.filetype :gitcommit
                      {:sources (cmp.config.sources [] [{:name :buffer}])}))
{:lazy true
 :dependencies [:hrsh7th/cmp-nvim-lsp
                :hrsh7th/cmp-buffer
                :FelipeLema/cmp-async-path
                ; :hrsh7th/cmp-path
                :hrsh7th/cmp-calc
                :hrsh7th/cmp-emoji
                :nvim-treesitter/nvim-treesitter
                :ray-x/cmp-treesitter
                :saadparwaiz1/cmp_luasnip
                :hrsh7th/cmp-cmdline
                :L3MON4D3/LuaSnip
                :ahmedkhalf/project.nvim]
 :event :InsertEnter
 : config}