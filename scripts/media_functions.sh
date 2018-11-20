#!/bin/bash

function streamlink_in_out_hls_out_mkvserver () {
    streamlink_url="${1}"
    streamlink_quality="${2}"
    ffmpeg_hls_out="${3}"
    
    create_split_files 2
    
    ffmpeg_hls_in="${output_file_list[0]}"
    mkvserver_ffmpeg_in="${output_file_list[1]}"
    
    export ffmpeg_hls_in mkvserver_f fmpeg_in ffmpeg_hls_out
    
    tmux split bash -c "ffmpeg_hls_out ${ffmpeg_hls_in} ${ffmpeg_hls_out}"
    tmux split bash -c "mvkserver_out_aac_audio ${mkvserver_ffmpeg_in}"
    tmux select-layout even-vertical
    streamlink_stdout "${streamlink_url}" "${streamlink_quality}" | split_output
}

function streamlink_in_out_hls_out_mkvserver_out_ice () {
    streamlink_url="${1}"
    streamlink_quality="${2}"
    ffmpeg_hls_out="${3}"
    
    create_split_files 3
    
    ffmpeg_hls_in="${output_file_list[0]}"
    mkvserver_ffmpeg_in="${output_file_list[1]}"
    ffmpeg_icecast_in="${output_file_list[2]}"
    
    export ffmpeg_hls_in mkvserver_f fmpeg_in ffmpeg_hls_out
    
    tmux split bash -c "ffmpeg_hls_out ${ffmpeg_hls_in} ${ffmpeg_hls_out}"
    tmux split bash -c "mvkserver_out_aac_audio ${mkvserver_ffmpeg_in}"
    tmux split bash -c "ffmpeg_mp3_icecast_out ${ffmpeg_icecast_in}"
    tmux select-layout even-vertical
    streamlink_stdout "${streamlink_url}" "${streamlink_quality}" | split_output
}

function streamlink_in_out_mkvserver_aac () {
    streamlink_url="${1}"
    streamlink_quality="${2}"
    
    streamlink_player_out "${streamlink_url}" "${streamlink_quality}" bash -c mvkserver_out_aac_audio
}

function streamlink_in_out_mkvserver_passthru () {
    streamlink_url="${1}"
    streamlink_quality="${2}"
    
    streamlink_player_out "${streamlink_url}" "${streamlink_quality}" bash -c mvkserver_out_passthru_audio
}


export -f streamlink_in_out_hls_out_mkvserver
export -f streamlink_in_out_mkvserver_aac
export -f streamlink_in_out_mkvserver_passthru
