---
- Title     : How I take notes with vim, vimwiki, and github pages.
- Type      : 📺 Video
- Author    : SeniorMars
- Link      : [youtube](https://www.youtube.com/watch?v=C0OwhiCp2Hk)
- Duration  : 11:39
- Watch     : Mon Oct 14 05:39:44 AM CEST 2024
- Tags      : vim vimwiki github workflow website wiki github
- Value ⭐/5: ⭐⭐⭐⭐
---

## Resume :
- Bonnes decouvertes, mais necessite un peu plus de recherche pour appliquer a mon cas:
    - addon vim **neoclide/coc.nvim** d'autocompletion base sur dictionnaire.
    - github feature pages : permettant la mise en place d'un site internet static.(ideal pour notes/wiki perso)

## Details:
- Presentation de sa prise de note sous vim avec vimwiki permettant au final de faire un site de page static (github).

- Utilise autocompletion en combinant plusieurs plugins:
    - `Plug 'neoclide/coc.nvim', {'branch': 'release'}` Utilise avec **coc-word** regroupant 10000 mot anglais.

- Etape permettant de passer de sa prise de note a un site web:
    1. Sur github creer un nouveau repo. public nomme `username.github.io` puis cloner le repo.
    2. En parallele transformer son vim wiki en page HTML avec la commande `:VimWikiAll2HTML` (pour moi voir HUGO).
    3. Placer le contenue du dossier HTML obtenu dans le dossier github, commit puis push.
    4. done, allew sur le nom de domaine https://username.github.io

### Sources additionnelles
- [tuto github pages](https://pages.github.com/)
- [blog de SeniorMars](https://seniormars.com/)
