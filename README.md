# README : vim

* [Installation](#installation)
* [Mapping : ShortCuts](#mapping--shortcuts)
* [Plugins (plugin manager:plug.vim)](#plugins-plugin-managerplugvim)
* [Details](#details)

## Installation
- Make an archive of present ~/.vim to `~/vim_archive_<actualdate>` then install my configuration

- 1: Save old install before
    ```bash
    [[ -d ~/.vim ]] && mv ~/.vim ~/vim_archive_$(date +%Y%m%d%H%M%S)
    ```
- 2: Simple install
    ```bash
    git clone --recurse-submodules -j8 https://github.com/alterGNU/Vim.git ~/.vim && echo -e "\n" | vim -c "PlugInstall" -c "qa" > /dev/null 2>&1
    ```

## Mapping : ShortCuts
| ShortCuts              | Commands                      | Details-Comment                                                                |
| ---------------------- | ----------------------------- | -----------------------------------------------------------------------------  |
| [F1]+Nmode             | `:Header42`                   | Insert header for 42 school project (see *config/header42.vim*)                |
| [F2]                   | `:Toggle`                     | Toggle all function in file by indentation                                     |
| [F3]+Imode             | `:ListMatches`                | Auto-completion function that display all matches availlable                   |
| [F4]                   | `:`                           |                                                                                |
| [F5]+Nmode             | `:call g:SaveAndSourceFile()` | If not in vimrc file, save then source file (handy when working on vim files)  |
| [F6]                   | `:`                           |                                                                                |
| [F7]                   | `:`                           |                                                                                |
| [F8]                   | `:TagbarToggle`               | Open the Tagbar window if it is closed, or close it if it is open.             |
| [F9]                   | `:`                           |                                                                                |
| [F10]                  | `:`                           |                                                                                |
| [F11]                  | `:`                           |                                                                                |
| [F12]                  | `:`                           |                                                                                |
| [Leader]+[1]           | `:Titre1<CR>`                 | Transform the line under the cursor to a title1                                |
| [Leader]+[2]           | `:Titre2<CR>`                 | Transform the line under the cursor to a title2                                |
| [Leader]+[3]           | `:Titre2<CR>`                 | Transform the line under the cursor to a title3                                |
| [t]+[h]                | `:tab help<Space>`            | Open a new tab with help                                                       |
| [t]+[m]+'x'            | `:tabm<Space>    `            | Move tab to 'x' (change tab order)                                             |
| [t]+[s]+'name'         | `:vsplit<Space>  `            | Open file 'name' in a new tab, splitting verticaly the actual tab              |
| [t]+[e]+'name'         | `:tabe<Space>    `            | Open file 'name' in a new tab                                                  |
| [ctrl]+[s]             | `:write`                      | Save(write the buff to the file,even if buff empty:timestamp always update)    |
| [ctrl]+[l]             | `:syn on+nohl+redraw+update`  | Active syntax-color, remove highlightning, redraw then update                  |
| [;]+[;]                | `:%s:::gc`                    | Launch Search & Replace with options:[(`g`,global), (`c`,ask B4 change)]       |
| [ctrl]+[t]+Nmode       | `:NERDTreeToggle`             | NERDTreeToggle                                                                 |
| [ctrl]+[t]+Imode       | `:`                           | Indent line                                                                    |
| [ctrl]+[f]             | `:NERDTreeFind`               | NERDTreeFind                                                                   |
| [Leader]+[m]           | `:Tman<ss curseur>`           | Display in a new tab the help/man page of the word under the cursor            |
| [Leader]+[v]+[m]       | `:Vman<ss curseur>`           | Display in a vertical split tab the help/man page of the word under the cursor |
| [Leader]+[Enter]       | `:VimwikiTabDropLink`         | Follow the vimwiki link under the cursor by opening it in a new tab            |
| [Leader]+[v]+[Enter]   | `:VimWikiVSplit`              | Follow the link under the cursor in a vertical split tab                       |

## Plugins (plugin manager:plug.vim)
- `alexandregv/norminette-vim    ` : Norminette checking
- `junegunn/vim-peekaboo         ` : Display the registers content on sidebar
- `majutsushi/tagbar             ` : Display tags in a windows (ordered by scope)
- `morhetz/gruvbox               ` : Theme & color retro groove
- `scrooloose/nerdtree           ` : File system explorer
- `scrooloose/syntastic          ` : Syntax checking
- `vim-utils/vim-man             ` : View man pages in vim
- `vimwiki/vimwiki               ` : Personnal Wiki

## Details
```bash
.vim/
  ├── aliases                   # Contains all vim related aliases use by shell (zsh->zshrc or bash->bashrc)
  ├── after/                    # Source at last, overwrite everything....
  │   └── ftplugin/             # filetype config., overwrite vimrc global config.
  ├── autoload/                 # Delay loading of plugin's code until it's actually needed
  │   └── plug.vim              # Plugin Manager
  ├── plugged/                  # contains plugins folders
  │   ├── gruvbox               # Theme & color retro groove
  │   ├── nerdtree              # File system explorer
  │   ├── norminette-vim        # Norminette checking
  │   ├── syntastic             # Syntax checking
  │   ├── vim-man               # View man pages in vim
  │   ├── vim-peekaboo          # Display the registers content on sidebar
  │   ├── vimwiki               # Personnal Wiki
  │   └── tagbar                # Display tags in a windows (ordered by scope)
  ├── plugin/                   # Folder for homemade plugins/vim extensions
  │   ├── cscopator.vim         # cscope configuration (settings and shortcuts)
  │   ├── customftdetector.vim  # Attempt to overwrite the default filetype detector
  │   ├── datediff.vim          # Fun, augroup & mapping use in vimwiki to insert duration (:InsertDuration)
  │   ├── donator.vim           # Fun, augroup & mapping use in vimwiki to set tickets as Done (:Done)
  │   ├── header42.vim          # Create Header for 42 school projects
  │   ├── insertor.vim          # Insert Templates/Skeleton-Matches-Emojis
  │   ├── titleator.vim         # Create title line
  │   └── updator.vim           # Fun, augroup & mapping use in vimwiki to update pages (:Update)
  ├── README.md                 # Readme page.
  ├── templates/                # Contains templates used by insertor.vim
  │   ├── diary.txt             # Template used for Wiki/diary/*.md entries
  │   ├── examples/             # Contains exemples of each type of templates
  │   ├── fix_it.txt            # Type of ticket used to keep track of how to solve an encountered bug or pb.
  │   ├── how_to.txt            # Type of ticket used to keep track of how to do a certain task (~tutos).
  │   ├── resume.txt            # Type of ticket used to resume a cours, video or article
  │   ├── tool_index.txt        # Autoload index page of Wiki/Notes/Tools/<tools_name>/index.md (#TODO)
  │   └── wiki_page.txt         # Autoload of any new page in Wiki/Notes/**/*.md which is not an index (#TODO)
  └── vimrc                     # Vim configuration file
```
