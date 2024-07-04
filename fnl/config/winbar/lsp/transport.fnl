(local SymbolKind
       (vim.tbl_add_reverse_lookup {:File 1
                                    :Module 2
                                    :Namespace 3
                                    :Package 4
                                    :Class 5
                                    :Method 6
                                    :Property 7
                                    :Field 8
                                    :Constructor 9
                                    :Enum 10
                                    :Interface 11
                                    :Function 12
                                    :Variable 13
                                    :Constant 14
                                    :String 15
                                    :Number 16
                                    :Boolean 17
                                    :Array 18
                                    :Object 19
                                    :Key 20
                                    :Null 21
                                    :EnumMember 22
                                    :Struct 23
                                    :Event 24
                                    :Operator 25
                                    :TypeParameter 26}))

(local SymbolTag {:Deprecated 1})
(local {: ensure-bufnr} (require :config.winbar.util))
(local {: get} (require :config.winbar.lsp.state))

(local METHOD :textDocument/documentSymbol)

(fn symbol-compare [{:selectionRange r1} {:selectionRange r2}]
  (if (or (< r2.end.line r1.start.line)
          (and (= r2.end.line r1.start.line)
               (<= r2.end.character r1.start.character)))
      :before
      (or (> r2.start.line r1.end.line)
          (and (= r2.start.line r1.end.line)
               (>= r2.start.character r1.end.character)))
      :after
      (and (or (< r2.start.line r1.start.line)
               (and (= r2.start.line r1.start.line)
                    (<= r2.start.character r1.start.character)))
           (or (> r2.end.line r1.end.line)
               (and (= r2.end.line r1.end.line)
                    (>= r2.end.character r1.end.character))))
      :around
      :within))

(fn insert [tree node]
  (if (empty? tree)
      (table.insert tree node)
      (do
        (var root tree)
        (while root
          (var last 1)
          (if (not (some (fn [n i]
                           (match (symbol-compare n node)
                             :within (do
                                       (when (not n.children)
                                         (set n.children []))
                                       (set root n.children)
                                       :break)
                             :around (do
                                       (when (not node.children)
                                         (set node.children []))
                                       (insert node.children
                                               (table.remove root i))
                                       :break)
                             :after (do
                                      (set last i)
                                      nil)
                             :before (do
                                       (table.insert root i node)
                                       :break))) root))
              (table.insert root (inc last) node)
              (set root nil))))))

(fn transform [data]
  (if (not data)
      nil
      (or (empty? data) (. data 1 :range))
      data
      (do
        (var tree [])
        (each [_ info (ipairs data)]
          (insert tree {:name info.name
                        :detail nil
                        :kind info.kind
                        :tags info.tags
                        :deprecated info.deprecated
                        :range info.location.range
                        :selectionRange info.location.range
                        :children nil}))
        tree)))

(fn request [?bufnr handler]
  (local bufnr (ensure-bufnr ?bufnr))
  (local state (get bufnr))
  (if (not state)
      false
      (do
        (local client (state:get-lsp-client))
        (if (not client)
            false
            (do
              (local params
                     {:textDocument (vim.lsp.util.make_text_document_params bufnr)})
              (client.request METHOD params
                              (fn [err data info]
                                (handler err (transform data) info))
                              bufnr))))))

{: request : SymbolKind : SymbolTag}
