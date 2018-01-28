#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

echo "PACKER PROVISIONER"

#echo "Install conda (it should be there but ok)"
#wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh
#bash /tmp/miniconda.sh -b -p $HOME/anaconda
#rm -rf /tmp/miniconda.sh

echo "Add miniconda to PATH"
export PATH=$HOME/anaconda/bin:$PATH
echo 'export PATH=$HOME/anaconda/bin:$PATH' >> ~/.bashrc
hash -r

echo "Configure conda for automation"
conda config --set always_yes yes --set changeps1 no

#echo "Update conda"
#conda update -q conda
#
#echo "Install STAR"
#conda install -y -c bioconda star 
#
#echo "Install HTSeq"
#conda install -y -c bioconda htseq

echo "Install cellranger"
aws s3 cp s3://viscrna-seq/assets/software/cellranger/cellranger-2.1.0.tar.gz /tmp/cellranger.tar.gz
tar -xvf /tmp/cellranger.tar.gz -C /tmp
sudo mv /tmp/cellranger-2.1.0/* /usr/local/bin/
cellranger sitecheck

echo "DONE"
exit 0
