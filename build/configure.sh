#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "MOCK PACKER PROVISIONER"

echo "Install STAR"
conda install -y -c bioconda star 


echo "DONE"
