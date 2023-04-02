#!/bin/bash

input_dir="$(pwd)"
zip_bundle="compressed_images"
cannot_zip_dir="larger_after_compression"

# Create output directories if they don't exist
mkdir -p $zip_bundle
mkdir -p $cannot_zip_dir

# Find all .png files
check_files=`find $input_dir -name '*.png'`

# Compress images using pngquant
for line in $check_files; do
    pngquant --quality=20-30 $line
    pre_name=`echo $line | awk -F '.png' '{print $1}'`
    pre_name="${pre_name}-fs8.png"
    pic_size1=`wc -c $line | awk '{print $1}'`
    pic_size2=`wc -c $pre_name | awk '{print $1}'`

    if [[ $pic_size2 -lt $pic_size1 ]]; then
        mv $pre_name $line
    else
        echo "Original image ${line}, compressed image $pre_name"
        echo $pic_size1
        echo $pic_size2
        echo "After compression, the size of the image becomes larger, so give up this compression"
        cp -fr $line $cannot_zip_dir
        rm $pre_name
    fi
done

# Copy the compressed images to the output directory
echo "Copy the compressed image..."
check_files=`find $input_dir -name '*.png'`
for line in $check_files; do
    cp $line "${zip_bundle}/"
done

echo "Execution completed!!!"
