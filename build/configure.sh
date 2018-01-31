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

echo "Install cellranger"
aws s3 cp --quiet s3://viscrna-seq/assets/software/cellranger/cellranger-2.1.0.tar.gz /tmp/cellranger.tar.gz
tar -xf /tmp/cellranger.tar.gz -C /tmp
sudo mv /tmp/cellranger-2.1.0/* /usr/local/bin/
cellranger sitecheck

echo "Provide human and mouse transcriptomes"
mouse="refdata-cellranger-mm10-1.2.0"
human="refdata-cellranger-GRCh38-1.2.0"

echo "Make folders"
sudo mkdir /assets
sudo chmod -R a+rwX /assets

mkdir -p /assets/references/mouse/transcriptome
mkdir -p /assets/references/human/transcriptome

echo "wget mouse reference transcriptome"
cd /assets/references/mouse/transcriptome
wget -nv http://cf.10xgenomics.com/supp/cell-exp/$mouse.tar.gz

echo "Extract mouse reference transcriptome"
tar -xf $mouse.tar.gz
rm -rf $mouse.tar.gz

echo "wget human reference transcriptome"
cd /assets/references/human/transcriptome
wget -nv http://cf.10xgenomics.com/supp/cell-exp/$human.tar.gz

echo "Extract human reference transcriptome"
tar -xf $human.tar.gz
rm -rf $human.tar.gz

echo "DONE"
exit 0
