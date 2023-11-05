#!/bin/sh

inputpath=$1 
outputpath=$2
region=$3

#The input path can be local or on a remote server
#e.g. ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/data/$sample/alignment/$sample.mapped.ILLUMINA.bwa.CEU.low_coverage.20111114.bam
#This way we can directly extract the chromosome of interest
#without having to download the file first

samtools view -bh $inputpath $region -o $outputpath

