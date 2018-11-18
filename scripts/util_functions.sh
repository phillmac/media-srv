#!/bin/bash

function wget_split_output () {
    wget_url="${1}"  
    wget "${wget_url}" -O - | tee ${tee_output_list} > /dev/null
}

function create_split_files () {
    output_count="${1}"
    
    tmpdir="$(mktemp -d)"
    
    output_file_list=()
    tee_output_list=()
    
    for ((i=1; i<=output_count; i++))
    do
        output_file="${tmpdir}/output_${i}"
        mkfifo "${output_file}"
        add_end tee_output_list ">(cat > ${output_file})"
        add_end output_file_list
    done
    
    export output_file_list tee_output_list
}

export -f wget_split_output
export -f create_split_files
