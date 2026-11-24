(local version :v0.1.1)
(local repo :shurizzle/fim-lsp)

(fn asset [target triple]
  (let [windows? (not= nil (triple:find :windows))]
    {: target
     :file (.. :fim-lsp- triple (if windows? :.zip :.tar.gz))
     :bin (if windows? :fim-lsp.exe :fim-lsp)}))

(local assets [(asset :darwin_arm64 :aarch64-apple-darwin)
               (asset :linux_x64 :x86_64-unknown-linux-musl)
               (asset :linux_arm64 :aarch64-unknown-linux-musl)
               (asset :win_x64 :x86_64-pc-windows-msvc)
               (asset :win_arm64 :aarch64-pc-windows-msvc)])

;; Mason has no BSD targets: pick the asset here and match it as plain `unix`.
(let [{: sysname : machine} (vim.uv.os_uname)
      arch (case machine
             :amd64 :x86_64
             :x86_64 :x86_64
             :arm64 :aarch64
             :aarch64 :aarch64)]
  (when (and (= sysname :FreeBSD) arch)
    (table.insert assets (asset :unix (.. arch :-unknown-freebsd)))))

(local platform (require :mason-core.platform))
(local prebuilt? (accumulate [found false _ a (ipairs assets)]
                   (or found (. platform.is a.target))))

{:name :fim-lsp
 :description "Fill-in-the-middle inline completions over LSP."
 :homepage (.. "https://github.com/" repo)
 :licenses [:MIT]
 :languages []
 :categories [:LSP]
 :source (if prebuilt?
             {:id (.. "pkg:github/" repo "@" version) :asset assets}
             ;; No prebuilt binary for this platform: build from the tag.
             {:id (.. "pkg:cargo/fim-lsp@" version
                      "?repository_url=https://github.com/" repo)})
 :bin {:fim-lsp (if prebuilt? "{{source.asset.bin}}" "cargo:fim-lsp")}}
