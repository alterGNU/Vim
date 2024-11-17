# README : vim

<!-- vim-markdown-toc GFM -->

* [Installation](#installation)
* [Mapping : ShortCuts](#mapping--shortcuts)
* [Plugins (plugin manager:plug.vim)](#plugins-plugin-managerplugvim)
* [Details](#details)

<!-- vim-markdown-toc -->

## Installation
- Make an archive of present ~/.vim to `~/vim_archive_<actualdate>` then install my configuration
```bash
if [ -d ~/.vim ];then mv ~/.vim ~/vim_archive_$(date +%Y%m%d%H%M%S);fi && git clone https://github.com/alterGNU/Vim.git ~/.vim && echo -e "\n" | vim -c "PlugInstall" -c "qa" > /dev/null 2>&1
```
## Mapping : ShortCuts
| ShortCuts     |       Commands         |                               Details-Comment                               |
| ------------- | ---------------------- | --------------------------------------------------------------------------- |
| [F1]          |   `:Header42`          | Insert header for 42 school project (see *config/header42.vim*)             |
| [F2]          |   `:Headerstd`         | Insert personnal header (see *config/headerstd.vim*) #TODO                  |
| [F3]          |   `:GenTocGFM`         | Insert TOC, where the cursor is, if in a Markdown file.                     |
| [F4]          |   `:Calendar`          | Calendar from itchyny                                                       |
| [F5]          |   `:Save&SourceFile`   | if not in vimrc file, save then source file (handy for vimscript dev)       |
| [Leader]+[1]  |   `:Titre1<CR>`        | Transform the line under the cursor to a title1                             |
| [Leader]+[2]  |   `:Titre2<CR>`        | Transform the line under the cursor to a title2                             |
| [Leader]+[3]  |   `:Titre2<CR>`        | Transform the line under the cursor to a title3                             |
| [t]+[h]       |   `:tab help<Space>`   | Open a new tab with help                                                    |
| [t]+[m]+'x'   |   `:tabm<Space>    `   | Move tab to 'x' (change tab order)                                          |
| [t]+[s]+'name'|   `:vsplit<Space>  `   | Open file 'name' in a new tab, splitting verticaly the actual tab           |
| [t]+[e]+'name'|   `:tabe<Space>    `   | Open file 'name' in a new tab                                               |
| [ctrl]+[s]    |   `:write`             | Save(write the buff to the file,even if buff empty:timestamp always update) |
| [ctrl]+[N]    |   `:nohl`              | No highlightning                                                            |
| [leader]+[t]  |   `:sort!<CR>`         | Sort selection                                                              |
| [leader]+[T]  |   `:sort<CR>`          | REVERSE Sort selection                                                      |
| [;]+[;]       |   `:%s:::gc`           | Launch Search & Replace with options:[(`g`,global), (`c`,ask B4 change)]    |
| [ctrl]+[t]    |   `:NERDTreeToggle`    | NERDTreeToggle                                                              |
| [ctrl]+[f]    |   `:NERDTreeFind`      | NERDTreeFind                                                                |
| [leader]+[m]  |   `:Vman<ss curseur>`  | Open a man help tab in Vsplit for the word under the cursor                 |
| [leader]+[M]  |   `:Vman<ss curseur>`  | Open a man help tab in Hsplit for the word under the cursor                 |
| [leader]+[CR] |   `:VimWikiVSplitLink` | Open vimwikileak in a VSplit new tab                                        |

## Plugins (plugin manager:plug.vim)
- **alexandregv/norminette-vim**    : norminette checking plugin 
- **itchyny/calendar.vim**          : Calendar Sync with google calendar and Tasks
- **morhetz/gruvbox**               : Theme & coloration retro groove
- **mzlogin/vim-markdown-toc**      : TOC for Markdown
- **scrooloose/nerdtree**           : File system explorer
- **scrooloose/syntastic**          : Syntax checking plugin
- **vim-utils/vim-man**             : View man pages in vim
- **vimwiki/vimwiki**               : Personal Wiki for Vim

## Details
```bash
.vim/
  ├── autoload/              # Delay loading of plugin's code until it's actually needed
  │   └── plug.vim           # Plugin Manager
  ├── config                 # Folder for homemade plugins/vim extensions (vimrc line 25)
  │   ├── header42.vim       # Create Header for 42 school projects
  │   ├── templateur.vim     # Insert templates/skeleton
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
