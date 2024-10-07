#!/bin/bash

awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv

cut -d',' --complement -f12,16 supervivents.csv > arxiuprova.csv

A=$(wc -l < supervivents.csv)

awk '{F=","} $14 != "True"' supervivents.csv > arxiuprova.csv

B=$(wc -l < arxiuprova.csv)

dif=$((A-B))

echo "La diferència és" $dif

awk '{F=","} {if($8 < 1000000) print"Bo"}; {if($8 >= 1000000 and $8 < 10000000) print"Excel·lent"}; {if($8 >= 10000000) print"Estrella"}'
