#!/bin/bash

A=$(wc -w < supervivents.csv)

awk 'BEGIN {NS=","} $15 != "True" {print$0}' supervivents.csv > arxiuprova.csv

B=$(wc -w < arxiuprova,csv)

dif=$((A-B))

echo "La diferència és $dif" >> arxiuprova.csv
