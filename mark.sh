#!/bin/bash

note=$(./note.sh)
malus=$(./malus.sh)
note=$((note + malus))

if [ ! -f readme.txt ]; then
    echo "Fichier readme.txt manquant (format: Prenom Nom)"
    exit 1
fi

read prenom nom < readme.txt

echo "Note finale de $prenom $nom : $note/20"

if [ ! -f "note.csv" ]; then
    echo "Nom,Prénom,Note" > "note.csv"
fi

echo "$nom,$prenom,$note" >> "note.csv"