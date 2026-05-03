#!/bin/bash

note=0

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
        echo "Code de plus de 80 caractères détecté dans $fichier" >&2
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
        echo "Mauvaise indentation dans $fichier" >&2
        note=$((note - 2))
    fi           
}

verifier_header(){
    fichier_h=$(find . -maxdepth 1 -name "*.h")

    if [ -z $fichier_h ]; then
        echo "Aucun fichier header trouvé" >&2
        note=$((note - 2))
    else
        echo " Fichier header trouvé : $fichier_h" >&2
    fi
}

verifier_make_clean() {
    make >/dev/null 2>&1

    if [ ! -f "./factorielle" ]; then
        echo "Compilation échouée ou exécutable absent" >&2
        note=$((note - 2))
        return
    fi

    make clean >/dev/null 2>&1

    if [ -f "./factorielle" ]; then
        echo "make clean ne supprime pas l'exécutable" >&2
        note=$((note - 2))
    else
        echo "make clean fonctionne correctement" >&2
    fi
}

verifier_longueur_lignes "main.c"
verifier_longueur_lignes "header.h"
verifier_espaces "main.c"
verifier_espaces "header.h"
verifier_header
verifier_make_clean

echo $note