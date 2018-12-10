#!/bin/bash

INPUT=$1
DIR=assignments
tempDir=temp

mkdir "$DIR" &> /dev/null
mkdir "$tempDir" &> /dev/null

tar xf $INPUT.tar.gz


for i in `find -name "*.txt"`; do
    while read line || [[ -n $line ]]
    do
        LINE="$(echo -e "${line}" | tr -d '[:space:]')"
        if [[ $LINE == "https"* ]]; then
            repo=$(echo $LINE | cut -d'-' -f 3)
            #echo $repo
            git clone "$LINE" "`pwd`/$tempDir/$repo" &> /dev/null && echo "$LINE: Cloning OK" && mv `pwd`/$tempDir/* &> /dev/null $DIR || echo "$LINE: Cloning FAILED"
            break
        fi
    done < "$i" 
done

rmdir "$tempDir" &> /dev/null


for j in `find ./$DIR/* -maxdepth 0 -type d`; do
    repo1=$(echo $j | cut -d'/' -f 3)
    echo "$repo1:"
    echo "Number of directories: $((`find $j/ -type d -printf '.' | wc -c`-1))"
    totalfiles=`find $j/ -type f -printf '.' | wc -c`
    txtfiles=`find $j/ -name "*.txt" -printf '.' | wc -c`
    echo "Number of txt files: $txtfiles"
    echo "Number of other files: $(($totalfiles - $txtfiles))"
    if [ ! -e $j/dataA.txt ]; then
        echo "Directory structure is NOT OK"
        continue
    elif [ ! -e $j/more/dataB.txt ]; then
        echo "Directory structure is NOT OK"
        continue
    elif [ ! -e $j/more/dataC.txt ]; then
        echo "Directory structure is NOT OK"
        continue
    elif [ `find $j/* -printf '.' | wc -c` != 4 ]; then
        #find $j/* -printf '.' | wc -c
        echo "Directory structure is NOT OK"
        continue
    fi
    echo "Directory structure is OK"
done


