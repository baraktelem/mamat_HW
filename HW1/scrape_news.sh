#!/bin/bash


site="https://www.ynetnews.com/category/3082"

# all the articles ont the main page
data=$(wget --no-check-certificate -O - "$site" 2> /dev/null)

# articles is a sorted list of all the articles on ynet's main page
articles=$(echo "$data"  | grep -oP "https://(www.)?ynetnews.com/article/[a-zA-Z0-9]+" | sort | uniq)
 

for link in $articles; do
    # make a sorted list of all the time netanyahu or gantz appear in each link
    NG_list=$(wget --no-check-certificate -O - "$link" 2> /dev/null | grep -oP "Netanyahu|Gantz" | sort)
    G_number=$(grep -o "G" <<< "$NG_list" | wc -l) 
    N_number=$(grep -o "N" <<< "$NG_list" | wc -l)
    check=($N_number+$G_number)
    if [[ $check -eq 0 ]]; then
        echo "$link, -"
    else
        echo "$link, Netanyahu, $N_number, Gantz, $G_number"
    fi
done
