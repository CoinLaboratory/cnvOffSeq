*******************************************************************************
                                  cnvOffSeq
*******************************************************************************

SUMMARY
-------

cnvOffSeq is a set of Java-based command-line tools for detecting intergenic
Copy Number Variants (CNVs) using off-target exome sequencing data.


AUTHORS
-------

Evangelos Bellos: evangelos.bellos09[at]imperial.ac.uk
Lachlan Coin: l.coin[at]imperial.ac.uk


LICENSE
-------

Copyright (C) <2014>  <Evangelos Bellos>

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


VERSION HISTORY
---------------

Version 0.1.2
- Added automatic handling of corrupt and empty input files. 
- Added automatic correction of maximum analysis coordinate,
  based on both the user-defined parameter and the actual
  genomic contents of the input files. 
- Minor bug fixes.

Version 0.1.1
- First public release.



SOFTWARE REQUIREMENTS
---------------------

* Java(TM) Runtime Environment 1.6 (up to update 19) 
* SAMtools


SYSTEM REQUIREMENTS
-------------------

Pre-processing (for target regions up to 500kb, batches of up to 100 samples):
- 4GB of RAM
- 4GB of temporary disk space for intermediate files

CNV calling (for analyzing 500kb in 50 samples simultaneously)
- 4GB of RAM
- 1GB of temporary disk space


INSTALL
-------

cnvOffSeq takes BAM alignment files as input. These files should be placed in
the "bam" folder. The software can be run in two separate stages. The first
stage is running the pre-processing normalization pipeline and the second
is the CNV detection. The normalization pipeline is optimized for BAM files
that contain single chromosomes. Therefore we have provided a script to extract
a region of interest from a large BAM file (extract_region_from_BAM.sh).
Here's an example of how to extract chromosome 6 from a local BAM file:

sh extract_region_from_BAM.sh "./bam/test.bam" "./bam/test_chr6.bam" "6"

The normalization pipeline can be run using the following script:

* for read depth: sh RD_pipeline_off_target.sh 6 60000 171050000

The RD uses a tab-delimited text file with the exome sequencing target
coordinates that need to be excluded from off-target analysis. This is represented
by the "onTarget_toExclude.txt" file within the pipeline folder. This exclusion
file is required for accurate calculation of the off-target coverage
and the pipeline will fail without it.

Further instructions for the pipeline can be found in the individual scripts
and are also provided by running each jar file with the --help argument.

The pre-processing scripts place the results in a new folder named
"pre_processing_results" and copy the pre-processed data sources into
the ./CNV_calling/data folder. In the end of the pre-processing,
this folder should contain the zip files with the normalized sampled RD data.

Once the pre-processing is finished, the CNV calling algorithm can be run using
the ./CNV_calling/run_cnvOffSeq.sh script without any arguments.
The script uses default settings for the various parameters, which may not be
appropriate for all datasets. These parameters can be changed from the
param.txt and the data.csv files. 

The calling algorithm creates separate folders for each run and names them after
the region of choice. Inside these folders, you can find a variety of results,
with the actual CNV calls contained in text files in the "cnv" folder (which are
all identical). If you chose to plot the results using the run_cnvOffSeq.sh
script, they will appear in the "plot_all_predictionsB" folder. By default
the ploting option is turned off to save time.

