#!/bin/bash

function serve_stream () {
  ffmpeg -re -i  http://127.0.0.1:9000/ -c:v copy -c:a libmp3lame -q:a 0 -f matroska - | server 2>/dev/null 1>/dev/null
}


export -f serve_stream
