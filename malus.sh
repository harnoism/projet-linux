#!/bin/bash

set -euo pipefail

note=0

error() {
    echo "ERREUR: $*" >&2
}

# 1. Header.h manquant (-2)
if [ ! -f "header.h" ]; then
    error "Fichier header.h manquant"
    note=$((note - 2))
fi

# 2. Longueur lignes >80 (-2)
verifier_longueur() {
    local fichier=$1
    local too_long=0

    while IFS= read -r ligne; do

        if [ ${#ligne} -gt 80 ]; then
            too_long=1

        fi

    done < "$fichier"

    if [ $too_long -eq 1 ]; then

        error "Lignes >80 chars dans $fichier (-2 pts)"
        note=$((note - 2))

    fi
}

verifier_longueur "main.c" "header.h"

# 3. Indentation incorrecte (-2)
verifier_indent() {
    local fichier=$1
    local mal_indente=0

    while IFS= read -r ligne; do

        [[ -z "$ligne" || "$ligne" =~ ^[[:space:]]*"}"[[:space:]]*$ ]] && continue

        indent=$(echo "$ligne" | sed 's/^\([[:space:]]*\).*/\1/')

        if [ ${#indent} -gt 0 ] && [ $(( ${#indent} % 2 )) -ne 0 ]; then
            mal_indente=1

        fi

    done < "$fichier"

    if [ $mal_indente -eq 1 ]; then

        error "Indentation incorrecte dans $fichier (-2 pts)"
        note=$((note - 2))

    fi
}

verifier_indent "main.c"

[ -f "header.h" ] && verifier_indent "header.h"

# 4. Make clean échoué (-2)
make clean >/dev/null 2>&1

if [ -f "./factorielle" ]; then

    error "make clean échoué (-2 pts)"
    note=$((note - 2))

else
    echo "make clean OK" >&2
fi

echo $note