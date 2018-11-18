#!/bin/bash

function wget_split_output () {
    wget_url="${1}"
    output_count="${2}"
    
    tmpdir="$(mktemp)"
    
    output_file_list=
    
    for ((i=1; i<=output_count; i++))
    do
        output_file="${tmpdir}/output/${i}"
        mkfifo "${output_file}"
        add_end output_file_list ">(cat > ${output_file})"
    done 
    
    wget "${wget_url}" -O - | tee ${output_file_list} > /dev/null
}
