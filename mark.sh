#!/bin/bash

note=20
DOSSIER=$1

IFS='_' read -r -a tableau <<< "$DOSSIER"
nom=${tableau[0]}
prenom=${tableau[1]}


verifier_longueur_lignes() {
    fichier=$1
    too_long=0

    while IFS= read -r ligne; do
        length=${#ligne}
        if [ "$length" -gt 80 ]; then
            too_long=1
        fi
    done < "$fichier"

    if [ "$too_long" -eq 1 ]; then
        echo "Code de plus de 80 caractères détecté dans $fichier"
        note=$((note - 2))
    fi
}


verifier_espaces(){
    fichier=$1
    mal_indente=0

    while IFS= read -r ligne; do
        [ -z "$ligne" ] && continue #ignore le vide
        [[ "$ligne" == "}"* ]] && continue #ignore les {}

        espaces=$(echo "$ligne" | sed 's/[^ ].*//') #supprime tout sauf les espaces du début
        nb_espaces=${#espaces}
        
        if [ $nb_espaces -gt 0 ] && [ $((nb_espaces %2)) -ne 0 ]; then
            mal_indente=1
        fi

    done < "$fichier"

    if [ $mal_indente -eq 1 ]; then
        echo "Mauvaise indentation dans $fichier"
        note=$((note - 2))
    fi           
}

verifier_header(){
    fichier_h=$(find . -maxdepth 1 -name "*.h")

    if [ -z $fichier_h ]; then
        echo "Aucun fichier header trouvé"
        note=$((note - 2))
    else
        echo " Fichier header trouvé : $fichier_h"
    fi
}

verifier_make_clean() {
    make >/dev/null 2>&1

    if [ ! -f "./factorielle" ]; then
        echo "Compilation échouée ou exécutable absent"
        note=$((note - 2))
        return
    fi

    make clean >/dev/null 2>&1

    if [ -f "./factorielle" ]; then
        echo "make clean ne supprime pas l'exécutable"
        note=$((note - 2))
    else
        echo "make clean fonctionne correctement"
    fi
}

verifier_longueur_lignes "main.c"
verifier_longueur_lignes "header.h"
verifier_espaces "main.c"
verifier_espaces "header.h"
verifier_header
verifier_make_clean

echo "Note finale de $prenom $nom : $note/20"

if [ ! -f "note.csv" ]; then
    echo "Nom,Prénom,Note" > "note.csv"
fi
echo "'$nom','$prenom',$note" >> "note.csv"