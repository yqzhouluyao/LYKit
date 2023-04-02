#!/bin/bash

delete_path="$(pwd)"
filePath="$(pwd)/unused_images.txt"

cat $filePath | while read line
do
    if [[ "$line" =~ ".imageset" ]];then
        img_dir=`echo "$line" | grep -Eo "/Users(.*).imageset"`
        rm -fr $img_dir
    else
        rm "$line"
    fi
done
