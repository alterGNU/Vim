# README : vim

<!-- vim-markdown-toc GFM -->

* [Installation](#installation)
* [Mapping : ShortCut/Raccourcis](#mapping--shortcutraccourcis)
* [Plugins (plugin manager:plug.vim)](#plugins-plugin-managerplugvim)
* [Details](#details)

<!-- vim-markdown-toc -->

## Installation
```bash
git clone https://github.com/alterGNU42/.vim.git
```
## Mapping : ShortCut/Raccourcis
- [F1]          ↦   `:Header42`         : Insert le header de 42. (void *config/header42.vim*)
- [F2]          ↦   `:Headerstd`        : Insert mon header std (void *config/headerstd.vim*) #TODO
- [F3]          ↦   `:GenTocGFM`        : Insert TOC, sous le curseur, dans fichier Markdown.
- [F5]          ↦   `:ReloadVimrc`      : `source vimrc`&&`PlugInstall`&&`PlugUpdate`(void *vimrc*)

- [Leader]+[1]  ↦   `:Titre1<CR>`       : Transforme la ligne en titre1
- [Leader]+[2]  ↦   `:Titre2<CR>`       : Transforme la ligne en titre2
- [Leader]+[3]  ↦   `:Titre2<CR>`       : Transforme la ligne en titre3

- [t]+[h]       ↦   `:tab help<Space>`  : Ouvre dans un nouvel onglet une page d'aide
- [t]+[m]       ↦   `:tabm<Space>    `  : Décalle vers la droite + et vers la gauche - l'onglet actuel
- [t]+[s]       ↦   `:vsplit<Space>  `  : Ouvre dans onglet actuel, avec separation vertical, un fichier existant
- [t]+[e]       ↦   `:tabe<Space>    `  : Ouvre dans un nouvel onglet un fichier existant

- [ctrl]+[s]    ↦   `:write`            : Save(write the buffer to the file,even if buff empty:timestamp always update)
- [ctrl]+[n]    ↦   `:nohl`             : Annule le surlignage (surlignage cause par `#` or `*`)
- [leader]+[t]  ↦   `:sort<CR>`         : Tri dans l'ordre alphanumerique la selection
- [;]+[;]       ↦   ` `                 : Lance Search and Replace avec option `g`:global `c`:ask B4 change

## Plugins (plugin manager:plug.vim)
- **morhetz/gruvbox**           : Theme et coloration retro groove
- **mzlogin/vim-markdown-toc**  : TOC for Markdown

## Details
```bash
.
├── autoload/              # Delay loading of plugin's code until it's actually needed
│   └── plug.vim           # ...
├── config                 # Folder for homemade plugins/vim extensions (vimrc line 25)
│   ├── header42.vim       # Create Header for 42 school projects
│   └── titres.vim         # Create title line
├── ftplugin/              # filetype config., overwrite vimrc global config.
│   ├── cpp.vim            # config_file for filetype=cpp
│   ├── c.vim              # config_file for filetype=c
│   ├── markdown.vim       # config_file for filetype=markdown
│   ├── python.vim         # config_file for filetype=python
│   ├── sh.vim             # config_file for filetype=sh
│   └── vim.vim            # config_file for filetype=vim
├── plugged/               # contains plugins folders
├── README.md             
└── vimrc
```
