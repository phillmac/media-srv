#!/bin/bash

export functions_dir="$(dirname $(dirname $(realpath  ${BASH_SOURCE})))/functions"

for file in "${functions_dir}"/*.sh
do
  source "${file}"
done
