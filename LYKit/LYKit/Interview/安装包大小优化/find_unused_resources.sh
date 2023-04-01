#!/bin/bash

# Set your project path
project_path="/Users/zhouluyao/Desktop/冷冻库/完整项目/ios_studentServices"
maybeImageSentencePath="/Users/zhouluyao/Desktop/冷冻库/完整项目/ios_studentServices"
k_base_size=5000  # Adjust this value as needed

# Initialize variables
UnusedCount=0
MaybeUnusedCount=0
TotalSize=0
unusedImageFilePath="unused_images.txt"
maybeUnusedImageFilePath="maybe_unused_images.txt"
mayUnusedExceedPicPath="may_unused_exceed_images.txt"
usedContain3Pic="used_contain_3_images.txt"

# Clean up old files
rm -f $unusedImageFilePath $maybeUnusedImageFilePath $mayUnusedExceedPicPath $usedContain3Pic

echo "Starting the script..."

# Find all .imageset files in the project
imagesets=$(find "$project_path" -type d -name "*.imageset")

for imageset in $imagesets; do
    echo "Processing imageset: $imageset"

    # Extract the imageset name
    match_name=$(basename "$imageset" | awk -F '.imageset' '{print $1}')
    echo "Imageset name: $match_name"

    # Find all image files within the imageset
    image_files=$(find "$imageset" -type f -iname "*.png")

    for image_file in $image_files; do
        echo "Processing image file: $image_file"

        # Get image file size
        pic_size=$(wc -c "$image_file" | awk '{print $1}')
        echo "Image file size: $pic_size"

        # Determine whether the image name is referenced
        referenced=false
        if grep -q "$match_name" "$maybeImageSentencePath"; then
            referenced=true
        fi

        # Check if image has numbers (spliced)
        contaT=$(echo "$match_name" | grep "[0-9]")
        if [[ "$contaT" != "" ]]; then
            MaybeUnusedCount=$((MaybeUnusedCount + 1))
            echo "$image_file" >> $maybeUnusedImageFilePath
            echo "${image_file} image may not be used"
            if [ $pic_size -gt $k_base_size ]; then
                echo "greater than ${k_base_size}, write to file"
                img_kb_size=$(awk 'BEGIN{printf "%.2f\n",'$pic_size'/1024}')
                echo "$image_file ${img_kb_size}KB" >> $mayUnusedExceedPicPath
            fi
            continue
        fi

        # Image not in the assigned text
        if ! $referenced ; then
            UnusedCount=$((UnusedCount + 1))
            echo "$image_file" >> $unusedImageFilePath
            echo "${image_file} image not used"
            TotalSize=$((TotalSize + pic_size))
            if [ $pic_size -gt $k_base_size ]; then
                echo "greater than ${k_base_size}, write to file"
                img_kb_size=$(awk 'BEGIN{printf "%.2f\n",'$pic_size'/1024}')
                echo "$image_file ${img_kb_size}KB" >> $unusedExceedPicPath
            fi
            continue
        fi

        # Check if there are three images in the imageset
        if [[ $image_file =~ ".imageset" ]]; then
            path=$(echo $image_file | grep -Eo "/Users(.*).imageset")
            files=$(ls $path)
            count_flag=0
            for filename in $files; do
                            if [[ $filename =~ ".png" ]]; then
                count_flag=$((count_flag + 1))
            fi
            if [[ "$count_flag" == "3" ]]; then
                echo $image_file >> $usedContain3Pic
            fi
        done
    fi
done
done
echo "Finished processing all files."


