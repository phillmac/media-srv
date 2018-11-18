#!/bin/bash

function wget_split_output () {
    wget_url="${1}"
    output_count="${2}"
    echo "${output_file_list[@]}"
    wget "${wget_url}" -O - | tee ${output_file_list[@]} > /dev/null
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

export -f wget_split_output
export -f create_split_files
