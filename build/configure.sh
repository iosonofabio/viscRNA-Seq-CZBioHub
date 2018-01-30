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

echo "Update conda"
conda update -q conda

echo "Compute combined transcriptome hashes"
vir="NC_004065_1.gb"
tra="refdata-cellranger-mm10-1.2.0"
sudo mkdir /assets
sudo chmod -R a+rwX /assets
mkdir -p /assets/references/virus_genome
mv /tmp/$vir /assets/references/virus_genome/$vir
mkdir -p /assets/references/transcriptome
cd /assets/references/transcriptome
wget http://cf.10xgenomics.com/supp/cell-exp/$tra.tar.gz
tar -xvf $tra.tar.gz
rm -rf $tra.tar.gz
sudo /tmp/append_virus_to_transcriptome --virus-gb $HOME/assets/references/virus_genome/$vir --genome-fasta $HOME/assets/references/transcriptome/$tra/fasta/genome.fa --transcriptome-gtf $HOME/assets/references/transcriptome/$tra/genes/genes.gtf --output /assets/references/transcriptome/combined
rm -rf /assets/references/transcriptome/$tra

echo "Set up pipeline script server side"
sudo mv /tmp/pipeline /usr/local/bin/

echo "Install cellranger"
aws s3 cp s3://viscrna-seq/assets/software/cellranger/cellranger-2.1.0.tar.gz /tmp/cellranger.tar.gz
tar -xvf /tmp/cellranger.tar.gz -C /tmp
sudo mv /tmp/cellranger-2.1.0/* /usr/local/bin/
cellranger sitecheck

echo "DONE"
exit 0
