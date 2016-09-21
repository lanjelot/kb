# gdb

# better ui
https://github.com/snarez/voltron

# connaître l'adresse de toutes les sections de tous les objets (librairies dynamiques comprises)
maint info sections ALLOBJ

# afficher des infos en mémoire
x/nfu addr
 # n => nombre d'occurences
 # f => format : x (hexa) / i (instructions / s (string)
 # u => unit   : b (bytes) / h (half-word) / w (word) / g (8bytes)

# PASS a received signal to the debugged programm
$ handle SIGSEGV pass
Signal        Stop      Print   Pass to program Description
SIGSEGV       Yes       Yes     Yes             Segmentation fault

