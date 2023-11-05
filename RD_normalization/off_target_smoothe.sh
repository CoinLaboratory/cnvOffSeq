#!/bin/sh

export OUTPUTROOT=$1
export PILEUPDIR=$OUTPUTROOT/Pileup
export OUTPUT=$OUTPUTROOT/Smoothed
export JARDIR=$2
export chr=$3
export start=$4
export stop=$5
export window=$6

readDepthIndex=3
coordinateIndex=1
tolerance=10000

svdToKeep=1
printTextOutput="yes"

mkdir -p $OUTPUT

#This class samples the read depth files according to the windowSize variable
#and then normalizes them using the local adapative singular value decomposition.
#The larger the sample set and the chromosome size, the more memory it requires.
#This step requires a onTarget_toExclude.txt file in the ./RD_normalization
#directory, in order to accurately calculate the off-target coverage. The 
#onTarget_toExclude.txt file is mandatory and cannot be empty.

#The "OffTargetSmoothing" class takes 12 arguments:
#-1 the path of the folder that contains the pileup files (created by samtools)
#-2 the column index of the read depth in the pileup file
#-3 the column index of the genomic coordinate in the pileup file
#-4 the path of the file that contains on-target regions to be excluded (can be obtained from the assay manufacturers)
#-5 the chromosome that we are processing
#-6 the coordinate from which to start
#-7 the maximum coordinate that will be processed
#-8 the tolerance around the excluded region breakpoints (in bp, defaults to 10000)
#-9 the path of the output directory
#-10 the size of the sampling window (defaults to 100bp)
#-11 how many singular components to retain (the more the noisier), recommended: 1
#-12 output the normalized results in text format? yes or no, defaults to: no


java -Xmx3800m -jar $JARDIR/OffTargetSmoothing.jar $PILEUPDIR $readDepthIndex $coordinateIndex $JARDIR/onTarget_toExclude.txt $chr $start $stop $tolerance $OUTPUT $window $svdToKeep $printTextOutput

echo "Done normalizing off-target data."

