#!/bin/bash
while read file_name file_url
do
        wget -O ${file_name} -c ${file_url}
done < down.txt

