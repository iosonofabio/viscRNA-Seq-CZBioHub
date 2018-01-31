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

echo "Compute combined transcriptome hashes"
vir="NC_004065_1.gb"
tra="refdata-cellranger-mm10-1.2.0"

echo "Make folders"
sudo mkdir /assets
sudo chmod -R a+rwX /assets
mkdir -p /assets/references/virus_genome
mv /tmp/$vir /assets/references/virus_genome/$vir
mkdir -p /assets/references/transcriptome
cd /assets/references/transcriptome

echo "wget reference transcriptome"
wget -nv http://cf.10xgenomics.com/supp/cell-exp/$tra.tar.gz

echo "Extract reference transcriptome"
tar -xf $tra.tar.gz
rm -rf $tra.tar.gz

echo "Make combined hashes"
/tmp/append_virus_to_transcriptome --virus-gb $HOME/assets/references/virus_genome/$vir --genome-fasta $HOME/assets/references/transcriptome/$tra/fasta/genome.fa --transcriptome-gtf $HOME/assets/references/transcriptome/$tra/genes/genes.gtf --output /assets/references/transcriptome/combined

echo "Remove original transcriptome"
rm -rf /assets/references/transcriptome/$tra
echo "Combined transcriptome hashed"

echo "Set up pipeline script server side"
sudo mv /tmp/pipeline /usr/local/bin/

echo "DONE"
exit 0
