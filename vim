# vim

# hex
:%!xxd
editing
:%!xxd -r
:wq

# hexadecimal editors
010editor (reset trial: rm "/home/seb/.config/SweetScape/010 Editor.ini")
hte
hexedit
hexinator https://hexinator.com/
HxD

# buffers
* horizontal
vim -oN
:new C-W C-N
:sp[lit]

* vertical
vim -ON
:vnew 
:vs[plit]
C-W C-V
C-W C-O (close)

# dictionnaire, spell, correction orthographe
setlocal spell spelllang=fr

]s goto next
z= show suggestions

# tabulation et espaces
set softtabstop=2 # pour que la touche TAB indente au lien d'inserer un TAB
set expandtab # pour que les tabulations soient converties en espaces
set tabstop=4 # pour que les tabulations soient affichés comme 4 espaces
set shiftwidth=2 # pour que la touche TAB indente de 2 espaces

# better than ctags+cscope
http://ruben2020.github.io/codequery/

# ctags
* Creation du fichier tags avec chemins absolus (--links pour suivre les liens symboliques)
$ ctags -R --languages=TCL --links=yes $PWD

# cscope
* Création du fichier cscope.out (-L pour suivre les liens symboliques)
find -L $PWD -name '*.tcl' | cscope -i- -b

* Ajouter la section suivante dans ~/.vimrc
if has("cscope")
  "set csprg=/usr/local/bin/cscope
  set csto=0
  set cst
  set nocsverb
  " add any database in current directory
  if filereadable("cscope.out")
      cs add cscope.out
  " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
  endif
  set csverb
endif

# Sans l'option -E, j'ai remarqué qu'il ignorait au moins un fichier .tcl, ce
# qui est très gênant (c'est peut-être parce qu'il était encodé en UTF-8 va
# savoir...)
$ glimpseindex -E -o $PWD
$ glimpse blah

# vimdiff
do -- Get changes from other window into the current window.
dp -- Put the changes from current window into the other window.
]c -- Jump to the next change.
[c -- Jump to the previous change.
