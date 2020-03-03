# Canu-Medaka pipeline for amplicon dereplication of Nanopore Reads.

This pipeline takes demultiplexed and trimmed fastq files from Nanopore sequencing.
It uses Canu to dereplicate the reads into amplicons.
Then, it used Medaka to polish the amplicons using the trimmed fastq files again.

This work flow depends on Bioconda to install the environmental dependencies (canu, medaka, and base R 3.6.0 for scripting).
And then runs the code using the attached scripts.

## Clone this code using GIT
git clone https://github.com/jiangweiyao/nanopore_amplicon_dereplicate.git


## Install Miniconda/Bioconda if no Conda is install on system. Need to do once.

Install and setup Miniconda (you can run using included Miniconda_install.sh)

```
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b
echo 'export PATH=~/miniconda3/bin:$PATH' >> .bashrc
conda init bash
conda config --set auto_activate_base false
```

Next, add bioconda and conda forge to the conda channel

```
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

## Create the environment. Need to do once.

We use conda to create an environment (that we can activate and deactivate) to install our dependent software and resolve their dependencies. We will call that new environment "canu_medaka".

```
conda create -n canu_medaka canu=1.9-0 medaka=0.11.5-0 r-docopt=0.6 -y
```

### Activate your environment and run your code.

Activating your environment makes the software you installed in that environment available for use. You will see "(canu_medaka)" in front bash after activation.
```
conda activate canu_medaka
```

Deactivating your environment exits out of your current environment, and returns you to your default system environment. You can build as many environments as you want and enter and exit out of them. Each environment is separate from each other to prevent version or dependency clashes. The author recommands using Conda/Bioconda to manage your dependencies.

Two actual lines of code runs the workflow. We wrapped it into an user friendly interface using docopt/R but the core commands if you are interested are here.

Use canu to dereplicate. -nanopore-raw takes the raw input file location and outputs it to -d location. You can look up the canu instruction manual to get more details on options.  
```
canu -p asm -d canu_BC02_cor  useGrid=0 -nanopore-raw barcode_fastq/BC02.fastq genomeSize=2000 stopOnReadQuality=false minReadLength=700 minOverlapLength=100 corMinCoverage=50 readSamplingCoverage=25000 correctedErrorRate=0.15 
```

Use medaka to polish the dereplicated amplicons. -i specifies where your fastq files are. -d points to where the dereplicated unitigs are. -o specifies output file. -m specifies model for polishing.  
```
medaka_consensus -i barcode_fastq/BC02.fastq -d canu_BC02_cor/asm.unitigs.fasta -o BC02_medaka -m r941_min_high_g303
```