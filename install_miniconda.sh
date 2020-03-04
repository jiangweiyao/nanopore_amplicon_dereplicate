cd ~
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b
echo 'export PATH=~/miniconda3/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
conda init bash
source ~/.bashrc
conda config --set auto_activate_base false
rm Miniconda3-latest-Linux-x86_64.sh
