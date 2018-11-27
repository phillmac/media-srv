#!/bin/bash

function streamlink_http_out () {
    streamlink_url="${1:-${streamlink_url}}"
    streamlink_quality="${2:-${streamlink_quality}}"

    streamlink_http_port="${streamlink_http_port:-9000}"
    streamlink_http_port="${3:-${streamlink_http_port}}"

    streamlink \
        --hls-segment-threads 3 \
        --hls-live-edge 10 \
        --ringbuffer-size 256M \
        --player-external-http \
        --player-external-http-port "${streamlink_http_port}" \
        "${streamlink_url}" "${streamlink_quality}"

}

function streamlink_player_out () {
    streamlink_url="${1:-${streamlink_url}}"
    streamlink_quality="${2:-${streamlink_quality}}"
    streamlink_player_command="${@:3}";

    streamlink \
        --verbose-player \
        --hls-segment-threads 3 \
        --hls-live-edge 10 \
        --ringbuffer-size 256M \
        --player "${streamlink_player_command}" \
        "${streamlink_url}" "${streamlink_quality}"
}
function streamlink_stdout () {
    streamlink_url="${1:-${streamlink_url}}"
    streamlink_quality="${2:-${streamlink_quality}}"

    streamlink \
        --hls-segment-threads 3 \
        --hls-live-edge 10 \
        --ringbuffer-size 256M \
        --stdout \
        "${streamlink_url}" "${streamlink_quality}"
}

function streamlink_hls_mkvserver_out () {
    streamlink_url="${1:-${streamlink_url}}"
    streamlink_quality="${2:-${streamlink_quality}}"
    ffmpeg_hls_out="${3:-${ffmpeg_hls_out}}"
    
    
    create_split_files 2
    
    ffmpeg_hls_in="${output_file_list[0]}"
    mkvserver_ffmpeg_in="${output_file_list[1]}"
    
    #export ffmpeg_hls_in mkvserver_ffmpeg_in ffmpeg_hls_out
    
    tmux split bash -c "ffmpeg_hls_out ${ffmpeg_hls_in} ${ffmpeg_hls_out}"
    tmux split bash -c "mvkserver_out_aac_audio ${mkvserver_ffmpeg_in}"
    tmux split bash -c "python_serve_http"
    tmux select-layout even-vertical
    streamlink_stdout "${streamlink_url}" "${streamlink_quality}" | split_output
}

function streamlink_hls_mkvserver_ice_out () {
    streamlink_url="${1:-${streamlink_url}}"
    streamlink_quality="${2:-${streamlink_quality}}"
    ffmpeg_hls_out="${3:-${ffmpeg_hls_out}}"
    ffmpeg_icecast_out="${4:-${ffmpeg_icecast_out}}"
    
    create_split_files 3
    
    ffmpeg_hls_in="${output_file_list[0]}"
    mkvserver_ffmpeg_in="${output_file_list[1]}"
    ffmpeg_icecast_in="${output_file_list[2]}"
    
    #export ffmpeg_hls_in ffmpeg_hls_out mkvserver_ffmpeg_in ffmpeg_hls_out ffmpeg_icecast_in ffmpeg_icecast_out
    
    tmux split bash -c "ffmpeg_hls_out ${ffmpeg_hls_in} ${ffmpeg_hls_out}"
    tmux select-layout even-vertical
    tmux split bash -c "mvkserver_out_aac_audio ${mkvserver_ffmpeg_in}"
    tmux select-layout even-vertical
    tmux split bash -c "ffmpeg_mp3_icecast_out ${ffmpeg_icecast_in} ${ffmpeg_icecast_out}"
    tmux select-layout even-vertical
    tmux split bash -c "python_serve_http"
    tmux select-layout even-vertical
    streamlink_stdout "${streamlink_url}" "${streamlink_quality}" | split_output
}

function streamlink_mkvserver_out () {
    streamlink_url="${1:-${streamlink_url}}"
    streamlink_quality="${2:-${streamlink_quality}}"
    
    streamlink_player_out "${streamlink_url}" "${streamlink_quality}" bash -c mvkserver_out_aac_audio
}

function streamlink_mkvserver_passthru_out () {
    streamlink_url="${1:-${streamlink_url}}"
    streamlink_quality="${2:-${streamlink_quality}}"
    
    streamlink_player_out "${streamlink_url}" "${streamlink_quality}" bash -c mvkserver_out_passthru_audio
}

function streamlink_hls_mkvserver_ice_av_out () {
    streamlink_url="${1:-${streamlink_url}}"
    streamlink_quality="${2:-${streamlink_quality}}"
    ffmpeg_hls_out="${3:-${ffmpeg_hls_out}}"
    ffmpeg_icecast_out="${4:-${ffmpeg_icecast_out}}"
    
    create_split_files 3
    
    ffmpeg_hls_in="${output_file_list[0]}"
    mkvserver_ffmpeg_in="${output_file_list[1]}"
    ffmpeg_icecast_in="${output_file_list[2]}"
    
    #export ffmpeg_hls_in ffmpeg_hls_out mkvserver_ffmpeg_in ffmpeg_hls_out ffmpeg_icecast_in ffmpeg_icecast_out
    
    tmux split bash -c "ffmpeg_hls_out ${ffmpeg_hls_in} ${ffmpeg_hls_out}"
    tmux split bash -c "mvkserver_out_aac_audio ${mkvserver_ffmpeg_in}"
    tmux select-layout even-vertical
    tmux split bash -c "ffmpeg_mpegts_av_mp3_icecast_out  ${ffmpeg_icecast_in} ${ffmpeg_icecast_out}"
    tmux split bash -c "python_serve_http"
    tmux select-layout even-vertical
    streamlink_stdout "${streamlink_url}" "${streamlink_quality}" | split_output
}

export -f streamlink_http_out
export -f streamlink_player_out
export -f streamlink_stdout
export -f streamlink_hls_mkvserver_out
export -f streamlink_mkvserver_out
export -f streamlink_mkvserver_passthru_out
export -f streamlink_hls_mkvserver_ice_out
