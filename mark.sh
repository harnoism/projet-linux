#!/bin/bash

note=$(./note.sh)
malus=$(./malus.sh)
note=$((note + malus))

# Lecture readme.txt
if [ ! -f "readme.txt" ]; then
    echo "ERREUR: readme.txt manquant" >&2
    nom="Inconnu"
    prenom="Inconnu"
else
    read -r prenom nom <<< "$(head -n1 readme.txt)"
fi

# Note finale
[ $note -lt 0 ] && note=0
echo "Note finale de $prenom $nom : $note/20" >&2

# Détruire le fichier CSV avant de le recréer
rm -f note.csv
echo "Nom,Prénom,Note" > note.csv
echo "'$nom','$prenom',$note" >> note.csv