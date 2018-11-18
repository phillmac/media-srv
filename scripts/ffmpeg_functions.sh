#!/bin/bash

function ffmpeg_hls_out () {
    ffmpeg_hls_in="-"
    ffmpeg_hls_in="${1:-${ffmpeg_hls_in}}"
    echo "ffmpeg hls input: ${ffmpeg_hls_in}"
    
    ffmpeg_hls_out="${2:-${ffmpeg_hls_out}}"
    echo "ffmpeg hls output: ${ffmpeg_hls_out}"
    
    ffmpeg_hls_seg_leng="${ffmpeg_hls_seg_leng:-10}"
    ffmpeg_hls_seg_leng="${3:-${ffmpeg_hls_seg_leng}}"
    echo "ffmpeg segment length: ${ffmpeg_hls_seg_leng}"
    
    ffmpeg -re -i "${ffmpeg_hls_in}" -c copy -segment_list_size 10 -hls_time "${ffmpeg_hls_seg_leng}" -hls_flags delete_segments "${ffmpeg_hls_out}"
}

export -f ffmpeg_hls_out
