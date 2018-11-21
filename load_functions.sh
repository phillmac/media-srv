#!/bin/bash

export scripts_dir="$(dirname $(realpath ${BASH_SOURCE}))/scripts" 

for file in "${scripts_dir}"/*.sh
do
  source "${file}"
done

#source "${scripts_dir}/array_functions.sh"
#source "${scripts_dir}/ffmpeg_functions.sh"
#source "${scripts_dir}/mkv_server_functions.sh"
#source "${scripts_dir}/streamlink_functions.sh"
#source "${scripts_dir}/util_functions.sh"
