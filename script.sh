#!/bin/bash

# pas 5
fet=1

if [ ! -f "supervivents4.csv" ]; then
        fet=0
fi

if [[ $# -ne 0 && "$fet" -ne 0 ]]; then
    argument=$1
    echo $argument

    resultat=$(grep -i -n "$argument" supervivents4.csv)

    if [ -z "$resultat" ]; then
        echo "No s'ha trobat el video."

    else
        fet=1
        echo "$resultat" | while IFS=',' read -r video_id trending_date title channel_title category_id publish_time tags views likes dislikes comment_count comments_disabled ratings_disabled video_error_or_removed Ranking_Views p_likes p_dislikes; 
	do
	    echo "Title: $title"
            echo "Publish Time: $publish_time"
            echo "Views: $views"
            echo "Likes: $likes"
            echo "Dislikes: $dislikes"
            echo "Ranking Views: $Ranking_Views"
            echo "% Likes: $p_likes"
            echo "% Dislikes: $p_dislikes"
    	done
    fi

elif [ "$fet" -ne 0 ]; then
        echo "Has d'introduïr arguments."
        exit 1
fi

if [ ! -f "supervivents4.csv" ]; then
	echo "No exiteix el fitxer de sortida."
        fet=0
fi


if [ $fet -eq 0 ];
   then
	# previa

	awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv

	#pas 1

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
   fi
