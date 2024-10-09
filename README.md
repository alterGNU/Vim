# README : vim

<!-- vim-markdown-toc GFM -->

* [Installation](#installation)
* [Mapping : ShortCuts](#mapping--shortcuts)
* [Plugins (plugin manager:plug.vim)](#plugins-plugin-managerplugvim)
* [Details](#details)

<!-- vim-markdown-toc -->

## Installation
- Pre-requis : no `${HOME}/.vim/`
```bash
git clone https://github.com/alterGNU42/.vim.git ~/.vim && echo -e "\n" | vim -c "ReloadVimrc" -c "qa" > /dev/null 2>&1
```
## Mapping : ShortCuts
| ShortCuts     |       Commands         |                               Details-Comment                               |
| ------------- | ---------------------- | --------------------------------------------------------------------------- |
| [F1]          |   `:Header42`          | Insert header for 42 school project (see *config/header42.vim*)             |
| [F2]          |   `:Headerstd`         | Insert personnal header (see *config/headerstd.vim*) #TODO                  |
| [F3]          |   `:GenTocGFM`         | Insert TOC, where the cursor is, if in a Markdown file.                     |
| [F5]          |   `:ReloadVimrc`       | `source vimrc`&&`PlugInstall`&&`PlugUpdate`(void *vimrc*)                   |
| [Leader]+[1]  |   `:Titre1<CR>`        | Transform the line under the cursor to a title1                             |
| [Leader]+[2]  |   `:Titre2<CR>`        | Transform the line under the cursor to a title2                             |
| [Leader]+[3]  |   `:Titre2<CR>`        | Transform the line under the cursor to a title3                             |
| [t]+[h]       |   `:tab help<Space>`   | Open a new tab with help                                                    |
| [t]+[m]+'x'   |   `:tabm<Space>    `   | Move tab to 'x' (change tab order)                                          |
| [t]+[s]+'name'|   `:vsplit<Space>  `   | Open file 'name' in a new tab, splitting verticaly the actual tab           |
| [t]+[e]+'name'|   `:tabe<Space>    `   | Open file 'name' in a new tab                                               |
| [ctrl]+[s]    |   `:write`             | Save(write the buff to the file,even if buff empty:timestamp always update) |
| [ctrl]+[n]    |   `:nohl`              | No highlightning                                                            |
| [leader]+[t]  |   `:sort!<CR>`         | Sort selection                                                              |
| [leader]+[T]  |   `:sort<CR>`          | REVERSE Sort selection                                                      |
| [;]+[;]       |   ` `                  | Launch Search & Replace with options:[(`g`,global), (`c`,ask B4 change)]    |

## Plugins (plugin manager:plug.vim)
- **morhetz/gruvbox**           : Theme & coloration retro groove
- **mzlogin/vim-markdown-toc**  : TOC for Markdown

## Details
```bash
.vim/
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
