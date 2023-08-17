{:dependencies :nvim-treesitter/nvim-treesitter
 :ft [:html
      :javascript
      :typescript
      :javascriptreact
      :typescriptreact
      :svelte
      :vue
      :tsx
      :jsx
      :rescript
      :xml
      :php
      :markdown
      :glimmer
      :handlebars
      :hbs]
 :config (fn [] ((. (require :nvim-ts-autotag) :setup)))}
