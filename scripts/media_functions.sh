#!/bin/bash

function streamlink_in_out_hls_out_mkvserver () {
    streamink_in="${1}"
    
    create_split_files 2
    
    ffmpeg_hls_in="${output_file_list[1]}"
    ffmpeg_mkvserver_in="${output_file_list[2]}"
    
    tmux split ffmpeg_hls_out "${ffmpeg_hls_in}"
    tmux split 
}

function streamlink_in_out_mkvserver_aac () {
    streamink_url="${1}"
    streamlink_quality="${2}"
    
    streamlink_player_out "$[streamink_url}" "${streamlink_quality}" bash -c mvkserver_out_aac_audio
}

export -f streamlink_in_out_hls_out_mkvserver
export -f streamlink_in_out_mkvserver_aac
