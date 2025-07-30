# blitzsearch.nvim a NeoVim Extension for Blitz Search

If you don't know what Blitz Search is, it's a standalone Free-And-Open-Source tool located here:

https://github.com/Natestah/BlitzSearch

Extensions for IDE's such as NeoVim, are generally created to interop with the tool, in order to create a Dialogue like experience for each.

![2025-07-30_10-46-07](https://github.com/user-attachments/assets/e9c97ecb-aef7-4090-9155-62d7a1c4f4f2)

# Help Make NVIM + Blitz Search Better

If you are a neovim expert and want to see improvements to Blitz Search and its integration please do drop by and chat about it.  I don't know a whole lot about NVIM myself so I'm very open to suggestions and IDEA's, especially simple things like how to make Blitz Search a more hands off the mouse type of experience.

[Join Nathan Silvers' Discord](https://discord.com/invite/UYPwQY9ngm)


## Setup

1) Install Blitz Search Standalone tool ( Windows Only ), get it here: 
    * https://github.com/Natestah/BlitzSearch

2) Add this to your local setup lua using Lazy Nvim config located here:
    * %localappdata%\nvim\lua\plugins\blitzsearch.lua


```lua
  return { "natestah/blitzsearch.nvim" }
```

3) Bind Keys
    * %localappdata%\nvim\init.lua


```lua
-- Search This
vim.api.nvim_set_keymap( "n", '<F8>', "<cmd>lua require('blitzsearch/searchthis').searchthis()<CR>", { noremap = false, silent = true })
vim.api.nvim_set_keymap( "v", '<F8>', "<cmd>lua require('blitzsearch/searchthis').searchthis()<CR>", { noremap = true, silent = true })

-- Replace This
vim.api.nvim_set_keymap( "n", '<F9>', "<cmd>lua require('blitzsearch/searchthis').replacethis()<CR>", { noremap = false, silent = true })
vim.api.nvim_set_keymap( "v", '<F9>', "<cmd>lua require('blitzsearch/searchthis').replacethis()<CR>", { noremap = true, silent = true })
```

❓ I've seen it suggested that you could beind multiple modes with a table instead of a single string for the Key mappings, but I couldn't get that working ( {"n", "v" }) 





## License MIT
