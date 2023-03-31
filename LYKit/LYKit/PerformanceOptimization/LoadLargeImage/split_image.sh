#!/bin/bash

input_file=$1
output_directory=$2

columns=$(identify -format "%[fx:ceil(w/512)]" "${input_file}")
rows=$(identify -format "%[fx:ceil(h/512)]" "${input_file}")

do_work() {
  x=$1
  y=$2
  convert "${input_file}" -crop 512x512+$(($x*512))+$(($y*512)) +repage "${output_directory}/large_image_${x}_${y}.jpg"
}

export -f do_work
export input_file
export output_directory

cpu_cores=$(sysctl -n hw.logicalcpu)
parallel -j "${cpu_cores}" do_work ::: $(seq 0 $((columns - 1))) ::: $(seq 0 $((rows - 1)))
