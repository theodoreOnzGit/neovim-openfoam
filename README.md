# neovim-openfoam
Neovim Setup for OpenFOAM

## Inspiration

Language Server Protocol (LSP) for OpenFOAM has proved a headache 
in the past. But there was a smart developer who 
[made it work](https://openfoamwiki.net/index.php/HowTo_Use_OpenFOAM_with_Visual_Studio_Code)
with vscode. 

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

Optional:

Tmux is super convenient to use for terminal users:
```bash
sudo pacman -S tmux
```
