# Canu-Medaka pipeline for amplicon dereplication of Nanopore Reads.

This pipeline takes basecalled, demultiplexed, and trimmed fastq files from Nanopore sequencing.
It uses Canu to dereplicate the reads into amplicons.
Then, it uses Medaka to polish the amplicons using the trimmed fastq files again.

This workflow depends on Bioconda to install the environmental dependencies (canu and medaka for the workflow, and R 3.6.0/docopt for scripting).
And then runs the attached scripts using the attached scripts.

## Summary - Installation 
1. Clone Repository 
2. Install Conda if not already in environment
3. Create conda environment

## Summary - How to run after installation.
1. Activate conda environment - `conda activate canu_medaka`
2. Run run test data - `~/nanopore_amplicon_dereplicate/nanopore_amplicon_dereplicate_batch.R -i ~/nanopore_amplicon_dereplicate/test -o test`
3. Run `~/nanopore_amplicon_dereplicate/nanopore_amplicon_dereplicate_batch.R -h` to get help.
4. Deactivate conda environment - `conda deactivate`

## Clone this code using GIT

### Install git for Debian systems using the following command (if necessary)
```
sudo apt update
sudo apt install git
```

##Installation directions 
These instructions install the code into your home path. Change the instructions if appropriate. 

### Clone the code from repository
```
cd ~
git clone https://github.com/jiangweiyao/nanopore_amplicon_dereplicate.git
```

### Install Miniconda (if no Conda is install on system). 
You can run the prepackaged script install_miniconda.sh to install into your home directory (recommended) by using the following command
```
. ~/nanopore_amplicon_dereplicate/install_miniconda.sh
```

Detailed instruction on the the Miniconda website if anything goes wrong:
https://conda.io/projects/conda/en/latest/user-guide/install/linux.html

### Clone the environment. Need to do once.

We use conda to create an environment (that we can activate and deactivate) to install our dependent software and resolve their dependencies. This environment is called "canu_medaka". The following command assumes your environment file is in your home path. Modify as appropriate.

```
conda env create -f ~/nanopore_amplicon_dereplicate/environment.yml
```

The command to generate the environment originally is in the included `canu_medaka_recipe.txt` file. 

## Run the code.

Activating your environment makes the software you installed in that environment available for use. You will see "(canu_medaka)" in front bash after activation.
```
conda activate canu_medaka
```

Test the single file version of the workflow with the following command
```
~/nanopore_amplicon_dereplicate/nanopore_amplicon_dereplicate.R -i ~/nanopore_amplicon_dereplicate/test/BC01_700bp.fastq -o test
```

Test the batch version of the workflow with the following command
```
~/nanopore_amplicon_dereplicate/nanopore_amplicon_dereplicate_batch.R -i ~/nanopore_amplicon_dereplicate/test -o test
```

Get help for how to use the script with the following command
```
~/nanopore_amplicon_dereplicate/nanopore_amplicon_dereplicate.R -h
```

When you are finished running the workflow, exit out of your environment by running `conda deactivate`. Deactivating your environment exits out of your current environment and protects it from being modified by other programs. You can build as many environments as you want and enter and exit out of them. Each environment is separate from each other to prevent version or dependency clashes. The author recommands using Conda/Bioconda to manage your dependencies.

## Known issues
### Issue 1: Perl clashing for canu
Some systems preset the PERL5LIB variable, causing canu to look for the perl5 library in that location rather than the default location in the conda environment. You can manually reset the PERL5LIB variance using the following command
`PERL5LIB=`

The R scripts should automatically set the variable.


## What the code is actually doing
Two actual lines of code runs the workflow. We wrapped it into an user friendly interface using docopt/R but the core commands if you are interested are here.

Use canu to dereplicate. -nanopore-raw takes the raw input file location and outputs it to -d location. You can look up the canu instruction manual to get more details on options.  
```
canu -p asm -d canu_BC02_cor  useGrid=0 -nanopore-raw barcode_fastq/BC02.fastq genomeSize=2000 stopOnReadQuality=false minReadLength=700 minOverlapLength=100 corMinCoverage=50 readSamplingCoverage=25000 correctedErrorRate=0.15 
```

Use medaka to polish the dereplicated amplicons. -i specifies where your fastq files are. -d points to where the dereplicated unitigs are. -o specifies output file. -m specifies model for polishing.  
```
medaka_consensus -i barcode_fastq/BC02.fastq -d canu_BC02_cor/asm.unitigs.fasta -o BC02_medaka -m r941_min_high_g303
````
