# neovim-openfoam
Neovim Setup for OpenFOAM

## Inspiration

Language Server Protocol (LSP) for OpenFOAM has proved a headache 
in the past. This is when browsing the C and C++ codebase within 
OpenFOAM. But there was a smart developer who 
[made it work](https://openfoamwiki.net/index.php/HowTo_Use_OpenFOAM_with_Visual_Studio_Code)
with vscode. (do note that the hyperlinks are provided 
as is, click AT YOUR OWN RISK, if you do not agree to this, 
DO NOT CLICK ANY HYPERLINK)

Though, I saw no one do the same for neovim and OpenFOAM, so I decided 
to do one up myself since I use neovim so often.


## Dependencies 

You will of course, need neovim along with a suite of plugins for this 
to work. Also, if you are a neovim user, I assume you already are 
familiar with the terminal.

You will need:

1. bear
2. ccls
3. OpenFOAM from source

Assuming you already have OpenFOAM installed, these are the other 
dependencies. So far, I've done this on Arch Linux:
```bash
sudo pacman -S neovim
sudo pacman -S bear ccls
```
You'll have to do an equivalent install for ubuntu based systems. 
(TBC)

Optional:

Tmux is super convenient to use for terminal users:
```bash
sudo pacman -S tmux
```

## tl;dr

If you just want neovim openfoam set up as is, run in this 
directory:

```bash
nvim -u ./foam-init.lua
```

## Setting Up Neovim with Two or More Config Files

For regular neovim users, I assume you already have an init.lua file 
and your own language server protocol (LSP) config. Using OpenFOAM with 
neovim (likely) needs a separate LSP configuration if you use clang. This 
is because ccls may [clash](https://github.com/ranjithshegde/ccls.nvim)
with other LSP server-client interfaces in neovim such as clang. 

I don't want to mess with your config files, so I wish to use a different 
config file altogether. Another smart user on
[reddit](https://www.reddit.com/r/neovim/comments/wk3r2s/question_keeping_multiple_configs_of_neovim/)
showed how to use a new config file without messing up the old one.

Basically, in the new "init.lua", we tell neovim not to bother reading 
the usual config files and plugins:

```lua
vim.opt.runtimepath:remove(vim.fn.expand('~/.config/nvim'))
vim.opt.packpath:remove(vim.fn.expand('~/.local/share/nvim/site'))
```

And then tell neovim to use the new config file and plugins directory.
When I provide the nvim file, I use it in this directory:

```lua
vim.opt.runtimepath:append(vim.fn.expand('./nvim-config'))
vim.opt.packpath:append(vim.fn.expand('./nvim-config/packpath'))
```

Then, for package managers add lazy:

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
```

Then set up neovim as per normal. Instructions for step 1 are 
[here](./step_1_basic_setup).
