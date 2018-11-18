#!/bin/bash

function ffmpeg_hls_out () {
    ffmpeg_hls_in="-"
    ffmpeg_hls_in="${1:-${ffmpeg_hls_in}}"
    echo "ffmpeg input: ${ffmpeg_hls_in}"
    
    ffmpeg_hls_out="${2:-${ffmpeg_hls_out}}"
    echo "ffmpeg output: ${ffmpeg_hls_out}"
    
    ffmpeg -re -i "${ffmpeg_hls_in}" -c copy -segment_list_size 10 -hls_time 10 -hls_flags delete_segments "${ffmpeg_hls_out}"
}

export -f ffmpeg_hls_out
