#!/bin/bash

function bash_repeat () {
    while true;
    do
        bash -c "${@}"
        sleep 10
   done
}

function split_output () {
    tee ${output_file_list[@]} > /dev/null
}

function wget_split_output () {
    wget_url="${1}"
    wget "${wget_url}" -O - | split_output
}

function create_split_files () {
    output_count="${1}"
    
    tmpdir="$(mktemp -d)"
    unset output_file_list
        
    for ((i=1; i<=output_count; i++))
    do
        output_file="${tmpdir}/output_${i}"
        mkfifo "${output_file}"
        add_end output_file_list "${output_file}"
    done
}

export -f bash_repeat 
export -f wget_split_output
export -f create_split_files
export -f split_output
