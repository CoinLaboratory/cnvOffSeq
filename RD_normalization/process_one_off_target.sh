#!/bin/sh

#This step requires SAMtools (http://samtools.sourceforge.net)

export OUTPUTROOT=$1
export INPUTDIR=$2
export OUTPUT=$OUTPUTROOT/Pileup
export TMPDIR=$OUTPUTROOT

mkdir -p $OUTPUT

sample=$(basename $3 .bam)

#First we index the input bam files.
echo "Indexing..."
samtools index $INPUTDIR/$sample.bam
#Then we sort them
echo "Sorting..."
samtools sort $INPUTDIR/$sample.bam $TMPDIR/$sample.sorted
#Finally we pile them up
echo "Piling up..."
samtools mpileup $TMPDIR/$sample.sorted.bam | cut -f 1,2,3,4 > $OUTPUT/$(basename $sample .bam).pile
