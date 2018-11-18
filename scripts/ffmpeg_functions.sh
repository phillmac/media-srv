#!/bin/bash

function ffmpeg_hls_out () {
    stream_in="${1}"
    output_file="${2}"
    
    ffmpeg -re -i "${stream_in}" -c copy -segment_list_size 10 -hls_time 10 -hls_flags delete_segments "${output_file}"
}

export -f ffmpeg_hls_out
