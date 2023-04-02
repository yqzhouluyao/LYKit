#!/bin/bash

# 设置项目目录
#project_path 和 maybeImageSentencePath 要改成项目的实际目录，如果是拷贝到与.xcproject文件同级目录，则无需修改
project_path= "$(pwd)"
maybeImageSentencePath= "$(pwd)"
k_base_size=5000  # Adjust this value as needed

# 初始化变量
UnusedCount=0
MaybeUnusedCount=0
TotalSize=0
unusedImageFilePath="unused_images.txt"
maybeUnusedImageFilePath="maybe_unused_images.txt"
mayUnusedExceedPicPath="may_unused_exceed_images.txt"
usedContain3Pic="used_contain_3_images.txt"

# 清除老文件
rm -f $unusedImageFilePath $maybeUnusedImageFilePath $mayUnusedExceedPicPath $usedContain3Pic

echo "Starting the script..."

# 查找所有在项目中的.imageset文件
imagesets=$(find "$project_path" -type d -name "*.imageset")

for imageset in $imagesets; do
    echo "Processing imageset: $imageset"

    # 提取 imageset 名
    match_name=$(basename "$imageset" | awk -F '.imageset' '{print $1}')
    echo "Imageset name: $match_name"

    #查找所有在 imageset 下的image 文件
    image_files=$(find "$imageset" -type f -iname "*.png")

    for image_file in $image_files; do
        echo "Processing image file: $image_file"

        # 获得图片的大小
        pic_size=$(wc -c "$image_file" | awk '{print $1}')
        echo "Image file size: $pic_size"

        # 判断图片是否被引用
        referenced=false
        if grep -q "$match_name" "$maybeImageSentencePath"; then
            referenced=true
        fi

       # 如果图片是带有数字的，就判断为可能是拼接的图片
        contaT=$(echo "$match_name" | grep "[0-9]")
        if [[ "$contaT" != "" ]]; then
            MaybeUnusedCount=$((MaybeUnusedCount + 1))
            echo "$image_file" >> $maybeUnusedImageFilePath
            echo "${image_file} image may not be used"
            #将使用到的图片，超过阀值写入文件
            if [ $pic_size -gt $k_base_size ]; then
                echo "greater than ${k_base_size}, write to file"
                img_kb_size=$(awk 'BEGIN{printf "%.2f\n",'$pic_size'/1024}')
                echo "$image_file ${img_kb_size}KB" >> $mayUnusedExceedPicPath
            fi
            continue
        fi

        #  将使用到的图片，超过阀值写入文件
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

        # 图片用到了，在imageset目录下，有三张png图片，则需要去掉1x图片
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


