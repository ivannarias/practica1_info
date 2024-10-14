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
        print $0, "Ranking_Views"
    } else if ($8 < 1000000) {
        print $0, "Bo"
    } else if ($8 >= 1000000 && $8 <= 10000000) {
        print $0, "Excel·lent"
    } else if ($8 > 10000000) {
        print $0, "Estrella"
    }
}' supervivents2.csv > supervivents3.csv

# pas 4
#!/bin/bash

linia=0

while IFS=',' read -r c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15; do
    linia=$((linia + 1))

    if [ $linia -eq 1 ]; then
        echo "$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$c10,$c11,$c12,$c13,$c14,$c15,%LIKES,%DISLIKES"
    else
        views=${c8}
        likes=${c9}
        dislikes=${c10}

        if [ "$views" -ne 0 ]; then
            resultat1=$(( (likes * 100) / views ))
            resultat2=$(( (dislikes * 100) / views ))
        else
            resultat1="N/A"
            resultat2="N/A"
        fi

        echo "$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$c10,$c11,$c12,$c13,$c14,$c15,$resultat1,$resultat2"
    fi
done < supervivents3.csv > supervivents4.csv


