#!/bin/bash

scripts_dir="$(realpath $(dirname ${BASH_SOURCE}))"

source "${scripts_dir}"/load_functions.sh

[[ ! -z "${hls_cleanup_patern}" ]] && rm -v "${hls_cleanup_patern}"

[[ ! -z "${media_srv_cmd}" ]] && tmux new -d -x 150 -y 50 bash -c "${media_srv_cmd}" || echo 'Please set environment var media_srv_cmd'
