#!/bin/bash

function mvkserver_out_mp3_audio () {
  mkvserver_ffmpeg_in="${1}"
  ffmpeg -re -i "${mkvserver_ffmpeg_in}" -c:v copy -c:a libmp3lame -q:a 0 -f matroska - | mkv_server 2>/dev/null 1>/dev/null
}

export -f mvkserver_out_mp3_audio
