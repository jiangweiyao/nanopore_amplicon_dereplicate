#!/usr/bin/env Rscript

library(docopt)

'This is the single file version of the canu-medaka pipeline for dereplicating amplicon sequences generated on Nanopore sequencing.
Specify an input fastq file and output base name. The final polished sequence is under basename_medaka/consensus.fasta.

Usage:
   nanopore_amplicon_dereplicate -i <input fastq> -o <output base name> [--readSamplingCoverage <max number of reads> --genomeSize <estimated amplicon length> --correctedErrorRate <estimated error rate> --model <polish model> --stopOnReadQuality <stop on bad quality> --minReadLength <discard read length less than> --overOverlapLength <required overlap length> --corMinCoverage <corMinCoverage>]

Options:
   -i input fastq (required) 
   -o output base name (required)
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

#print(opts)

##Uncomment the line below if your system has PERL5LIB variable preset and is causing canu to stop.
Sys.setenv(PERL5LIB = "")
system("echo $PER5LIB")

print("commands being executed:")

canu_cmd <- (paste0("canu -p asm -d ", opts$o, "_canu useGrid=0 -nanopore-raw ", opts$i, " genomeSize=", opts$genomeSize, " stopOnReadQuality=", opts$stopOnReadQuality, " minReadLength=",opts$minReadLength, " minOverlapLength=", opts$minOverlapLength, " corMinCoverage=", opts$corMinCoverage, " readSamplingCoverage=", opts$readSamplingCoverage, " correctedErrorRate=", opts$correctedErrorRate))

medaka_cmd <- (paste0("medaka_consensus -i ", opts$i, " -d ", opts$o, "_canu/asm.unitigs.fasta -o ", opts$o, "_medaka -m ", opts$model))


print("commands being executed:")
print("canu_cmd")
print("medaka_cmd")


system(canu_cmd)
system(medaka_cmd)

