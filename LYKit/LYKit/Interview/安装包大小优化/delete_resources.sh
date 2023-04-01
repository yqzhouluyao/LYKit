#!/bin/bash

delete_path="/Users/zhouluyao/Desktop/冷冻库/完整项目/ios_studentServices/"
filePath="/Users/zhouluyao/Desktop/冷冻库/完整项目/ios_studentServices/unused_images.txt"

cat $filePath | while read line
do
    if [[ "$line" =~ ".imageset" ]];then
        img_dir=`echo "$line" | grep -Eo "/Users(.*).imageset"`
        rm -fr $img_dir
    else
        rm "$line"
    fi
done
