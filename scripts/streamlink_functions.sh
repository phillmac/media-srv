#!/bin/bash

function streamlink_http_out () {

streamlink_url="${1}"
streamlink_quality="${2}"

streamlink_http_port="9000"
streamlink_http_port="${STREAMLINK_HTTP_PORT:-${streamlink_http_port}}"
streamlink_http_port="${3:-${streamlink_http_port}}"

streamlink \
    --player-external-http \
    --player-external-http-port "${streamlink_http_port}" \
    "${streamlink_url}" "${streamlink_quality}"

}
