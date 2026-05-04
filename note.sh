#!/bin/bash

fact() {
    n=$1
    r=1
    for ((k=2; k<=n; k++)); do
        r=$((r * k))
    done
    echo "$r"
}

note=0

# 1) Compilation
make >/dev/null 2>&1
if [ ! -f factorielle ]; then
    echo "Compilation echouee -> note = 0"
    exit 0
fi
note=$((note+2))

# 2) Signature exacte : int factorielle( int number )
if grep -Rqx 'int factorielle( int number )' *.c 2>/dev/null; then
    note=$((note+2))
fi

# 3) Message mauvais nombre de parametres
output=$(./factorielle 2>&1)
if echo "$output" | grep -qx 'Erreur: Mauvais nombre de parametres'; then
    note=$((note+4))
fi

# 4) Message nombre negatif
output=$(./factorielle -5 2>&1)
if echo "$output" | grep -qx 'Erreur: nombre negatif'; then
    note=$((note+4))
fi

# 5) Cas general 1 a 10
correct=true
for i in $(seq 1 10); do
    expected=$(fact $i)
    result=$(./factorielle $i 2>/dev/null)
    if [ "$result" != "$expected" ]; then
        correct=false
        break
    fi
done

if $correct; then
    note=$((note+5))
fi

# 6) Cas particulier 0
result=$(./factorielle 0 2>/dev/null)
if [ "$result" = "1" ]; then
    note=$((note+3))
fi

echo "$note"