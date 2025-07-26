# blitzsearch.nvim a NeoVim Extension for Blitz Search

If you don't know what Blitz Search is, it's a standalone Free-And-Open-Source tool located here:

https://github.com/Natestah/BlitzSearch

Extensions for IDE's such as NeoVim, are generally created to interop with the tool, in order to create a Dialogue like experience for each.

## ⚠️Work-in-progress⚠️

![2025-07-11_12-24-38](https://github.com/user-attachments/assets/ec2a8c7e-7ec2-4ec2-b814-223fc8283fb4)


This has been very my my most challenging update, so bear with me. 

If you are a neovim expert and want to see this through, please do hit me up on discord.. I could use some help!

[Join Nathan Silvers' Discord](https://discord.com/invite/UYPwQY9ngm)


The main problem with this Editor has been my unfamiliarity, the folks who use NeoVim exist on an alternate universe.  I don't even know if most will care to have a full GUI find-in-files dialogue attached to their terminal style editor. I have asked, and the answer is crazy, we have this things where we type in terminal commands and it's really advanced.

But it has been requested.. So I have to chase it now! 😊



## TODO's:
* 🔲 Editor Context
  * ❓ Does VM have workspace? or is it just working dir
  * 🔲 Automatically switch the Editor to Nvim with the context
  * ✅ Get Selected word
  * ✅ If not selected, word at caret
  * ✅ Write Context to shared Config folder ( poormansipc ) for Blitz Search to parse and act 
* ✅ Search This command uses Editor Context to send replace Search Signal to Blitz search
* ✅ Replace This command uses Editor Context to send replace signal to Blitz search

* ✅ Basic bootstrap for Blitz Search, Call out Blitz.Exe
* ✅ Respond to Goto Events from Blitz
  * 🔲 Work out / handle mode selection ( force mode on selecting results)
  * ⚠️ Mostly works but occasionally hit swap file warnings, may be resolved with Preview goto when simply selecting

## Setup

Add this to your local setup lua using Lazy or otherwise do the things you do with extensions and dependencies ( You know this stuff better than I do )


```lua
  { "natestah/blitzsearch.nvim" },
```

and this to your init to bind a key:

⚠️ Search This / Replace thiscommand, currently simply spawns Blitz.exe.

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
