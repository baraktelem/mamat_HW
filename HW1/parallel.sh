#!/bin/bash

site="https://www.ynetnews.com/category/3082"

# Fetch all the articles on the main page
data=$(wget --no-check-certificate -O - "$site" 2> /dev/null)

# Extract unique article links
articles=$(echo "$data" | grep -oP "https://(www.)?ynetnews.com/article/[a-zA-Z0-9]+" | sort | uniq)

# Function to process each article
process_article() {
    link=$1
    NG_list=$(wget --no-check-certificate -O - "$link" 2> /dev/null | grep -oP "Netanyahu|Gantz")
    N_number=$(echo "$NG_list" | grep -o "Netanyahu" | wc -l)
    G_number=$(echo "$NG_list" | grep -o "Gantz" | wc -l)
    check=$((N_number + G_number))
    if [[ $check -eq 0 ]]; then
        echo "$link, -"
    else
        echo "$link, Netanyahu, $N_number, Gantz, $G_number"
    fi
}

export -f process_article

# Process articles in parallel using GNU parallel
echo "$articles" | parallel -j 8 process_article
