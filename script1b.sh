#!/bin/bash

INPUT=$1

checkUrl() {
    LINE="$(echo -e "$1" | tr -d '[:space:]')"
    if [[ $LINE == "#"* ]]; then
        continue
    fi
    tmp1=${LINE#*//}
    address=$(echo $tmp1 | cut -d'/' -f 1)
    if [ ! -e "$address".txt ]; then
        echo "$LINE INIT"
    fi
    wget -q -O "$address"_temp.txt $LINE || echo "$LINE FAILED"
    diff "$address"_temp.txt "$address".txt &> /dev/null
    if [ $? == 1 ]; then
        echo "$LINE"
    fi
    cp "$address"_temp.txt "$address".txt > /dev/null
    rm "$address"_temp.txt
}

while read line || [[ -n $line ]]
do
    checkUrl $line &
done < "$INPUT" 
wait
