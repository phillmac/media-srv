#!/bin/bash

function ffmpeg_hls_out () {
    ffmpeg_hls_in="${ffmpeg_hls_in:--}"
    ffmpeg_hls_in="${1:-${ffmpeg_hls_in}}"
    echo "ffmpeg hls input: ${ffmpeg_hls_in}"
    
    ffmpeg_hls_out="${2:-${ffmpeg_hls_out}}"
    echo "ffmpeg hls output: ${ffmpeg_hls_out}"
    
    ffmpeg_hls_list_size="${ffmpeg_hls_list_size:-10}"
    ffmpeg_hls_list_size="${3:-${ffmpeg_hls_list_size}}"
    echo "ffmpeg list size: ${ffmpeg_hls_list_size}"
    
    ffmpeg_hls_seg_leng="${ffmpeg_hls_seg_leng:-10}"
    ffmpeg_hls_seg_leng="${4:-${ffmpeg_hls_seg_leng}}"
    echo "ffmpeg segment length: ${ffmpeg_hls_seg_leng}"
    
    ffmpeg -re -i "${ffmpeg_hls_in}" \
        -c copy \
        -segment_list_size "${ffmpeg_hls_list_size}" \
        -hls_time "${ffmpeg_hls_seg_leng}" \
        -hls_flags temp_file+delete_segments \
        "${ffmpeg_hls_out}"
}

function ffmpeg_mp3_icecast_out () {
    
    ffmpeg_icecast_in="${ffmpeg_icecast_in:--}"
    ffmpeg_icecast_in="${1:-${ffmpeg_icecast_in}}"
    echo "ffmpeg icecast input: ${ffmpeg_icecast_in}"
    
    ffmpeg_icecast_out="${2:-${ffmpeg_icecast_out}}"
    echo "ffmpeg icecast output: ${ffmpeg_icecast_in}"
        
    ffmpeg -re -i "${ffmpeg_icecast_in}" \
        -vn \
        -c:a libmp3lame -b:a 192k -ar 44100 \
        -legacy_icecast     "${ffmpeg_legacy_icecast:-0}" \
        -ice_name           "${ffmpeg_ice_name}" \
        -ice_description    "${ffmpeg_ice_description}" \
        -ice_url            "${ffmpeg_ice_url}" \
        -ice_genre          "${ffmpeg_ice_genre}" \
        -content_type audio/mpeg \
        "${ffmpeg_icecast_out}"
}

export -f ffmpeg_hls_out
