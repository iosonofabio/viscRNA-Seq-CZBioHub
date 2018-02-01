#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "PACKER PROVISIONER"

echo "Add miniconda to PATH"
export PATH=$HOME/anaconda/bin:$PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH' >> ~/.bashrc
hash -r

echo "Configure conda for automation"
conda config --set always_yes yes --set changeps1 no

echo "Update conda"
conda update -q conda

echo "Set up pipeline script server side"
sudo mkdir -p /data
sudo chmod a+rwX /data
sudo rm -rf /usr/local/bin/pipeline
sudo mv /tmp/pipeline /usr/local/bin/

echo "DONE"
exit 0
