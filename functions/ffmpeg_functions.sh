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
        -hls_list_size "${ffmpeg_hls_list_size}" \
        -hls_time "${ffmpeg_hls_seg_leng}" \
        -hls_flags temp_file+delete_segments \
        "${ffmpeg_hls_out}"
}

# Strip any video and stream any audio as mp3
function ffmpeg_mp3_icecast_out () {
    
    ffmpeg_icecast_in="${ffmpeg_icecast_in:--}"
    ffmpeg_icecast_in="${1:-${ffmpeg_icecast_in}}"
    echo "ffmpeg icecast input: ${ffmpeg_icecast_in}"
    
    ffmpeg_icecast_out="${2:-${ffmpeg_icecast_out}}"
    echo "ffmpeg icecast output: ${ffmpeg_icecast_out}"
    
    ffmpeg_icecast_br="${ffmpeg_icecast_br:--b:a 192k}"     
    ffmpeg_icecast_ar="${ffmpeg_icecast_ar:--ar 44100}"
   
        
    ffmpeg -re -i "${ffmpeg_icecast_in}" \
        -vn \
        -c:a libmp3lame ${ffmpeg_icecast_br} ${ffmpeg_icecast_ar} \
        -f mp3 \
        -legacy_icecast     "${ffmpeg_legacy_icecast:-0}" \
        -ice_name           "${ffmpeg_ice_name}" \
        -ice_description    "${ffmpeg_ice_description}" \
        -ice_url            "${ffmpeg_ice_url}" \
        -ice_genre          "${ffmpeg_ice_genre}" \
        -content_type audio/mpeg \
        "${ffmpeg_icecast_out}"
}

function ffmpeg_mpegts_av_icecast_out () {
    
    ffmpeg_av_icecast_in="${ffmpeg_av_icecast_in:--}"
    ffmpeg_av_icecast_in="${1:-${ffmpeg_av_icecast_in}}"
    echo "ffmpeg av icecast input: ${ffmpeg_av_icecast_in}"
    
    ffmpeg_av_icecast_out="${2:-${ffmpeg_av_icecast_out}}"
    echo "ffmpeg av icecast output: ${ffmpeg_av_icecast_out}"
    
    ffmpeg_av_icecast_br="${ffmpeg_icecast_br:--b:a 192k}"     
    ffmpeg_icecast_ar="${ffmpeg_icecast_ar:--ar 44100}"
        
    ffmpeg -re -i "${ffmpeg_av_icecast_in}" \
        -c:v copy \
        -c:a libmp3lame "${ffmpeg_av_icecast_br}" "${ffmpeg_av_icecast_ar}" \
        -f mpegts \
        -legacy_icecast     "${ffmpeg_av_legacy_icecast:-0}" \
        -ice_name           "${ffmpeg_av_ice_name}" \
        -ice_description    "${ffmpeg_av_ice_description}" \
        -ice_url            "${ffmpeg_av_ice_url}" \
        -ice_genre          "${ffmpeg_av_ice_genre}" \
        -content_type audio/mpeg \
        "${ffmpeg_av_icecast_out}"
}

function ffmpeg_mpegts_av_mp3_icecast_out () {
    
    ffmpeg_icecast_in="${ffmpeg_icecast_in:--}"
    ffmpeg_icecast_in="${1:-${ffmpeg_icecast_in}}"
    echo "ffmpeg icecast input: ${ffmpeg_icecast_in}"
    
    ffmpeg_icecast_out="${2:-${ffmpeg_icecast_out}}"
    echo "ffmpeg icecast output: ${ffmpeg_icecast_out}"
    
    ffmpeg_av_icecast_out="${3:-${ffmpeg_av_icecast_out}}"
    echo "ffmpeg av icecast output: ${ffmpeg_av_icecast_out}"
    
    ffmpeg_icecast_br="${ffmpeg_icecast_br:--b:a 192k}"     
    ffmpeg_icecast_ar="${ffmpeg_icecast_ar:--ar 44100}"
   
        
    ffmpeg -re -i "${ffmpeg_icecast_in}" \
        -c: copy \
        -f mpegts \
        -legacy_icecast     "${ffmpeg_av_legacy_icecast:-0}" \
        -ice_name           "${ffmpeg_av_ice_name}" \
        -ice_description    "${ffmpeg_av_ice_description}" \
        -ice_url            "${ffmpeg_av_ice_url}" \
        -ice_genre          "${ffmpeg_av_ice_genre}" \
        -content_type video/mpeg \
        "${ffmpeg_av_icecast_out}" \
        -vn \
        -c:a libmp3lame ${ffmpeg_icecast_br} ${ffmpeg_icecast_ar} \
        -f mp3 \
        -legacy_icecast     "${ffmpeg_legacy_icecast:-0}" \
        -ice_name           "${ffmpeg_ice_name}" \
        -ice_description    "${ffmpeg_ice_description}" \
        -ice_url            "${ffmpeg_ice_url}" \
        -ice_genre          "${ffmpeg_ice_genre}" \
        -content_type audio/mpeg \
        "${ffmpeg_icecast_out}"
}



export -f ffmpeg_hls_out
export -f ffmpeg_mp3_icecast_out
export -f ffmpeg_mpegts_av_icecast_out
export -f ffmpeg_mpegts_av_mp3_icecast_out
