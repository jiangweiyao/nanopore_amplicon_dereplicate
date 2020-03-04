#!/usr/bin/env Rscript

library(docopt)
library(tools)

'This is the batch version of the canu-medaka pipeline for dereplicating amplicon sequences generated on Nanopore sequencing.
Specify a folder containing files named BC**.fastq to process. This script will run the pipeline on each of the files. The final polished sequence is under filename_medaka/consensus.fasta.


Usage:
   nanopore_amplicon_dereplicate_batch -i <input directory> [--readSamplingCoverage <max number of reads> --genomeSize <estimated amplicon length> --correctedErrorRate <estimated error rate> --model <polish model> --stopOnReadQuality <stop on bad quality> --minReadLength <discard read length less than> --overOverlapLength <required overlap length> --corMinCoverage <corMinCoverage>]

Options:
   -i input directory (required) 
   --genomeSize [default: 2000]
   --stopOnReadQuality [default: false]
   --minReadLength [default: 700]
   --minOverlapLength [default: 100]
   --corMinCoverage [default: 50]
   --readSamplingCoverage [default: 25000]
   --correctedErrorRate [default: 0.15]
   --model [default: r941_min_high_g303]

 ]' -> doc

opts <- docopt(doc)

fastqs <- sort(list.files(opts$i, pattern="BC(.*).((fastq|fq)(|\\.gz))$", full.names = TRUE))

print(fastqs)

for(file in fastqs){



    canu_cmd <- (paste0("canu -p asm -d ", file_path_sans_ext(basename(file)), "_canu useGrid=0 -nanopore-raw ", file, " genomeSize=", opts$genomeSize, " stopOnReadQuality=", opts$stopOnReadQuality, " minReadLength=",opts$minReadLength, " minOverlapLength=", opts$minOverlapLength, " corMinCoverage=", opts$corMinCoverage, " readSamplingCoverage=", opts$readSamplingCoverage, " correctedErrorRate=", opts$correctedErrorRate))

    medaka_cmd <- (paste0("medaka_consensus -i ", opts$i, " -d ", file_path_sans_ext(basename(file)), "_canu/asm.unitigs.fasta -o ", file_path_sans_ext(basename(file)), "_medaka -m ", opts$model))


    print("commands being executed:")
    print(canu_cmd)
    print(medaka_cmd)


    system(canu_cmd)
    system(medaka_cmd)
}
