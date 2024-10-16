#!/bin/bash

# pas 5
fet=1

if [ ! -f "supervivents4.csv" ]; then #Perquè, en cas que l'arxiu no existeixi, vagi directament a crear-lo.
        fet=0
fi

if [[ $# -ne 0 && "$fet" -ne 0 ]]; then #Si existeix l'arxiu, comprovem que hi hagi un input.
    argument=$1
    echo $argument

    resultat=$(grep -i -n "$argument" supervivents4.csv)

    if [ -z "$resultat" ]; then	#Si no trobem el vídeo demanat, ho informem.
        echo "No s'ha trobat el video."

    else #Però, si l'hem trobat, ensenyem els resultats trobats.
        fet=1
        echo "$resultat" | while IFS=',' read -r video_id trending_date title channel_title category_id publish_time tags views likes dislikes comment_count comments_disabled ratings_disabled video_error_or_removed Ranking_Views p_likes p_dislikes; #Mentre que hi hagi comes com a delimitador (per saber que no ens hem sortit de les columnes) llegim valors i els assignem a variables.
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

elif [ "$fet" -ne 0 ]; then #Si no hi ha inputs, i la variable fet NO és igual a 0 (que vol dir que l'arxiu existeix), diem que s'han d'introduir arguments.
        echo "Has d'introduïr arguments."
        exit 1
fi

if [ ! -f "supervivents4.csv" ]; then #Si no existeix l'arxiu, ho diem i assignem 0 a la variable fet.
	echo "No exiteix el fitxer de sortida."
        fet=0
fi


if [ $fet -eq 0 ]; #Si fet=0, no existeix l'arxiu, així que correm el programa sencer per crear-lo.
   then
	# previa

	awk -F',' '{ if (NF == 16) print $0 }' CAvideos.csv > supervivents.csv

	#pas 1

	cut -d',' --complement -f12,16 supervivents.csv > supervivents1.csv #Eliminem les files 12 i 16, seleccionant només les seves complementàries (contraries).

	# pas 2

	A=$(wc -l < supervivents1.csv) #Assignem amb wc un valor per saber el número de linies prèvies a l'eliminació de files.

	awk '{FS=","} $14 != "True"' supervivents1.csv > supervivents2.csv #Eliminem les files que tenen True com a valor a la fila 14.

	B=$(wc -l < supervivents2.csv) #Assignem amb wc un altre valor per saber el número de linies després de l'eliminació de files.

	dif=$((A-B)) #Calculem la diferència.

	echo "La diferència és" $dif #Ensenyem la diferència.

	# pas 3

	awk -F',' ' #Delimitadors = comes.
	BEGIN {OFS=","}
	{
	    if (NR == 1) { #Si ens trobem a la primera fila, creem la columna nova.
	        print $0, "Ranking_Views"
	    } else if ($8 < 1000000) { #Si no, per cada fila, depenent del seu nombre de views (valor de la columna 8), assignem un valor Bo, Excel·lent o Estrella.
	        print $0, "Bo"
	    } else if ($8 >= 1000000 && $8 <= 10000000) {
	        print $0, "Excel·lent"
	    } else if ($8 > 10000000) {
	        print $0, "Estrella"
	    }
	}' supervivents2.csv > supervivents3.csv #Conduim output a un nou arxiu.

	# pas 4

	linia=0 #Creem una variable per recórrer les línies.

	while IFS=',' read -r c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11 c12 c13 c14 c15; do #Llegim tots els valors de les columnes i els assignem a unes variables.
	    linia=$((linia + 1)) #Actualitzem la linia a la que ens trobem.

	    if [ $linia -eq 1 ]; then #A la primera linia, creem les noves columnes.
	        echo "$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$c10,$c11,$c12,$c13,$c14,$c15,%LIKES,%DISLIKES"
	    else
	        views=${c8} #Per les altres, afegim els valors depenent dels valors de cada fila.
	        likes=${c9}
	        dislikes=${c10}

	        if [ "$views" -ne 0 ]; then
	            resultat1=$(( (likes * 100) / views ))
	            resultat2=$(( (dislikes * 100) / views ))
	        else
	            resultat1="N/A" #En cas d'intentar dividir per 0, per si de cas, fem un if per ajudar-nos a detectar-ho.
	            resultat2="N/A"
	        fi

	        echo "$c1,$c2,$c3,$c4,$c5,$c6,$c7,$c8,$c9,$c10,$c11,$c12,$c13,$c14,$c15,$resultat1,$resultat2" #Al final, fem print de tota la linia amb els seus valors corresponents a cada columna.
	    fi
	done < supervivents3.csv > supervivents4.csv #Finalment, l'output és conduït a un últim fitxer.
   fi
