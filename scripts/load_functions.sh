#!/bin/bash

export functions_dir="$(realpath $(dirname  ${BASH_SOURCE})/..)/functions"

for file in "${functions_dir}"/*.sh
do
  source "${file}"
done
