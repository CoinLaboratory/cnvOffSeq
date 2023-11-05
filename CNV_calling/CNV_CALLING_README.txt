INSTRUCTIONS
------------

Once the pre-processing steps finished and the data has been converted
to the required zip format, we are ready for CNV calling. The zip files
should be copied to the ./data folder in the appropriate subfolder (e.g. ./data/RD/6.zip).
This is performed by the pre-processing scripts. Next, CNV calling
can be performed using the cnvOffSeq.jar. This file contains all
the necessary libraries and requires the following:

- a data.csv file that contains the training parameters for each data source
  (represented by different columns in the file). The name of each data source
  must be the same for the the data.csv columns and the input folder names.

- a param.txt that contains general parameters of the model

- an input folder (in our example ./data), which contains separate
  folders for each data source. In turn, these folders contain the pre-processed
  zip files. If these folders were not created using the provided scripts,
  they should all be renamed to the chromosome name (e.g. "6.zip")

When running cnvOffSeq, some basic parameters can be set from the command-line:

* --mid specifies the region on which to perform the analysis
  (e.g. --mid 6:48.91mb:48.96mb). The first argument (here "6" corresponds
  to the name of the zip files that contain the data)

* --baseDir specifies where the input data is located

* --include specifies which data sources to include in the analysis by name
  (as specified by the columns of the data.csv file and the input folder names)
  by default we include RD

* --plot specifies whether to produce plots of the underlying data along with the
  segmentation. To enable plotting this parameter needs to be set to 1, otherwise
  to 0. When plotting is enabled the analysis will take longer.

* --numIt argument defines the number of training iterations for the model. To avoid
  overfitting this parameter shouldn't be set above 15. For single-sample analysis
  the segmentation doesn't improve with training.


Here's an example for running cnvCapSeq:

java -Xmx3800m -cp ./cnvOffSeq.jar lc1.dp.appl.CNVHap --paramFile param.txt --mid 6:48.91mb:48.96mb --baseDir ./data/ --index 1 --column 1 --numIt 5 --include RD --plot 0 --r_panel true --b_panel true --showScatter false --showHMM false  --expModelIntHotSpot 0.1:1:1e3 --collapseDupStates true > output_msg.txt 2>&1

Alternatively, you can perform CNV calling directly, by running the 
run_cnvOffSeq.sh script from the commandline without any arguments.

The program creates separate folders for each run and names them after
the region of choice. Inside these folders, you can find a variety of results,
with the actual CNV calls contained in text files in the "cnv" folder. If you
chose to plot the results they will appear in the "plot_all_predictionsB" folder.












































After the pre-processing, we use the following process for CNV calling:
-The merged zip files are copied into the appropriate subfolder of the /data folder
-Then we go to the /analysis folder and run the "split_regions.sh" script to create the individual CNV calling jobs
-In the "split.txt" file, we define the regions that we want to analyze (separate job for each line of the file).
-For capture data, however, the splitting is not necessary since the regions are already relatively small
-After we have defined the split regions we run the "split_regions.sh" scripts that requires 4 arguments:
	#the first should always be "1"
	#the second should always be "1"
	#the third is the maximum memory to be used in MB (usually 32000)
	#the fourth argument determines how easy it is for the model to transition between states, ranging from 0.01 (hard to transition) to 100 (easy to transition)
-An example is: sh split_regions.sh 1 1 32000 1
-This script will create individual jobs for each of the split regions, which we can submit to the cluster for analysis

A few interesting parameters of the model and the program:
-in the split_regions.sh script:
	#"--numIt" determines how many training iterations will be used across the population (defaults to 15, anything higher than 25 is probably overfitting)
	#"--plot" if set to 1 it produces plots for visualizing the results, produces no plots if set to 0. If the plotting is on the calling process will be slower
-in the param.txt file:
	#"--experiment" determines the experiment name
	#you may notice that some parameters are duplicate. The version in the "split_regions.sh" script will override the others
-in the data.csv file:
	#regionsToExlude, contains all the regions that will not be used during the calling in the format: chr;start;stop;chr;start;stop... this needs to be defined for every data source (e.g. RD, RP, SR...)
	#noCopies should be set to 2 for autosomal chromosomes and 1 for Y chromosome
	
After the CNV calling has finished, the results will be contained in a zip file, within the output directory created by "split_regions.sh".
When unzipped, the text version of the CNV calls will be in the /cnv folder (the different files in here are identical, so you can use any one).
The plots will be in the /plot_all_predicitionsB folder in png format.
