---@brief
---
--- https://muon.build/
---
--- An implementation of the meson build system in c99

---@type vim.lsp.Config
return {
	cmd = { "muon", "analyze", "lsp" },
	filetypes = { "meson" },
	root_markers = { "meson.build" },
}
