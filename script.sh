#!/bin/bash

# previa

awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv

# pas 1

cut -d',' --complement -f12,16 supervivents.csv > supervivents1.csv

# pas 2

A=$(wc -l < supervivents1.csv)

awk '{FS=","} $14 != "True"' supervivents1.csv > supervivents2.csv

B=$(wc -l < supervivents2.csv)

dif=$((A-B))

echo "La diferència és" $dif

# pas 3
awk -F',' '
BEGIN {OFS=","}
{
    if (NR == 1) {
        print $0, "Ranking"
    } else if ($8 < 1000000) {
        print $0, "Bo"
    } else if ($8 >= 1000000 && $8 <= 10000000) {
        print $0, "Excel·lent"
    } else if ($8 > 10000000) {
        print $0, "Estrella"
    }
}' supervivents2.csv > supervivents3.csv

# pas 4

