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

# Détruire le CSV existant avant de le recréer
rm -f note.csv
echo "Nom,Prénom,Note" > "note.csv"

echo "$nom,$prenom,$note" >> "note.csv"