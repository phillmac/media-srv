#!/bin/bash

function streamlink_http_out () {
    streamlink_url="${1}"
    streamlink_quality="${2}"

    streamlink_http_port="9000"
    streamlink_http_port="${STREAMLINK_HTTP_PORT:-${streamlink_http_port}}"
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
    streamlink_url="${1}"
    streamlink_quality="${2}"
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
    streamlink_url="${1}"
    streamlink_quality="${2}"

    streamlink \
        --verbose-player \
        --hls-segment-threads 3 \
        --hls-live-edge 10 \
        --ringbuffer-size 256M \
        --stdout \
        "${streamlink_url}" "${streamlink_quality}"
}

export -f streamlink_http_out
export -f streamlink_player_out
export -f streamlink_stdout
