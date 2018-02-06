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

echo "Combined transcriptome hashes"
vir="NC_004065_1.gb"
tra="refdata-cellranger-mm10-1.2.0"

echo "Make virus folder"
mkdir -p /assets/references/virus_genome
mv /tmp/$vir /assets/references/virus_genome/$vir

# NOTE: rehashing is very expensive, so we cache it on S3
#echo "Make mouse folder"
#mkdir -p /assets/references/mouse/transcriptome
#
#echo "wget mouse reference transcriptome"
#cd /assets/references/mouse/transcriptome
#wget -nv http://cf.10xgenomics.com/supp/cell-exp/$tra.tar.gz
#
#echo "Extract mouse reference transcriptome"
#tar -xf $mouse.tar.gz
#
#echo "Remove tar.gz and star files"
#rm -rf $mouse.tar.gz
#rm -rf $mouse/star
#
#echo "Make combined hashes"
#/tmp/append_virus_to_transcriptome --virus-gb /assets/references/virus_genome/$vir --genome-fasta /assets/references/mouse/transcriptome/$tra/fasta/genome.fa --transcriptome-gtf /assets/references/mouse/transcriptome/$tra/genes/genes.gtf --output /assets/references/combined/transcriptome
#
echo "Remove original transcriptomes"
rm -rf /assets/references/{mouse,human}

echo "Copy combined transcriptome from S3"
#aws s3 cp s3://viscrna-seq/assets/references/reference_mouse_and_mCMV_separate.tar.gz /assets/references/
aws s3 cp s3://viscrna-seq/assets/references/reference_mouse_and_mCMV_combined.tar.gz /assets/references/
echo "Extracting combined transcriptome"
#mv /assets/references/reference_mouse_and_mCMV_separate.tar.gz /assets/references/mouse_and_mCMV.tar.gz
mv /assets/references/reference_mouse_and_mCMV_combined.tar.gz /assets/references/mouse_and_mCMV.tar.gz
tar -xf /assets/references/mouse_and_mCMV.tar.gz -C /assets/references/
echo "Removing tar.gz"
rm -rf /assets/references/mouse_and_mCMV.tar.gz
echo "Combined transcriptome hashed"

echo "DONE"
exit 0
