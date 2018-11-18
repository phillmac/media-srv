#!/bin/bash

function mvkserver_out_mp3_audio () {
    mkvserver_ffmpeg_in="-"
    mkvserver_ffmpeg_in="${1:-${mkvserver_ffmpeg_in}}"
    ffmpeg -re -i "${mkvserver_ffmpeg_in}" -c:v copy -c:a libmp3lame -q:a 0 -f matroska - | mkv_server 2>/dev/null 1>/dev/null
}

function mvkserver_out_aac_audio () {
    mkvserver_ffmpeg_in="-"
    mkvserver_ffmpeg_in="${1:-${mkvserver_ffmpeg_in}}"
    echo "ffmpeg input: ${mkvserver_ffmpeg_in}"
    ffmpeg -re -i ${mkvserver_ffmpeg_in} -c:v copy -c:a libfdk_aac -b:a 192k -f matroska - | mkv_server 2>/dev/null 1>/dev/null
}

function mvkserver_out_passthru_audio () {
    mkvserver_ffmpeg_in="-"
    mkvserver_ffmpeg_in="${1:-${mkvserver_ffmpeg_in}}"
    ffmpeg -re -i  -c:v copy -c:a copy -f matroska - | mkv_server 2>/dev/null 1>/dev/null
}


export -f mvkserver_out_mp3_audio 
export -f mvkserver_out_aac_audio 
export -f mvkserver_out_passthru_audio
