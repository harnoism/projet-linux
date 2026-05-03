#!/bin/bash

note=20
DOSSIER=$1

IFS='_' read -r -a tableau <<< "$DOSSIER"
nom=${tableau[0]}
prenom=${tableau[1]}

malus=$(./malus.sh)
note=$((note + malus))

echo "Note finale de $prenom $nom : $note/20"

if [ ! -f "note.csv" ]; then
    echo "Nom,Prénom,Note" > "note.csv"
fi
echo "'$nom','$prenom',$note" >> "note.csv"