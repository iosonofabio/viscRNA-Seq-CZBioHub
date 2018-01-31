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

echo "Install biopython"
conda install -c bioconda biopython

echo "Compute combined transcriptome hashes"
vir="NC_004065_1.gb"
tra="refdata-cellranger-mm10-1.2.0"

echo "Make folders"
mkdir -p /assets/references/virus_genome
mv /tmp/$vir /assets/references/virus_genome/$vir

echo "Make combined hashes"
/tmp/append_virus_to_transcriptome --virus-gb /assets/references/virus_genome/$vir --genome-fasta /assets/references/mouse/transcriptome/$tra/fasta/genome.fa --transcriptome-gtf /assets/references/mouse/transcriptome/$tra/genes/genes.gtf --output /assets/references/combined/transcriptome

echo "Remove original transcriptomes"
rm -rf /assets/references/{mouse,human}
echo "Combined transcriptome hashed"

echo "Set up pipeline script server side"
sudo mv /tmp/pipeline /usr/local/bin/

echo "DONE"
exit 0
