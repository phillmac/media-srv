#!/bin/bash

scripts_dir="$(dirname $(realpath ${BASH_SOURCE}))" 

source "${scripts_dir}/array_functions.sh"
source "${scripts_dir}/ffmpeg_functions.sh"
source "${scripts_dir}/media_functions.sh"
source "${scripts_dir}/mkv_server_functions.sh"
source "${scripts_dir}/streamlink_functions.sh"
source "${scripts_dir}/util_functions.sh"
