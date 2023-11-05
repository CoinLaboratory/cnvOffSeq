#!/bin/sh

#the "mid" argument specifies which region the CNV analysis should be performed on.
#e.g. for one of the intergenic regions described in the manuscript this would be
#--mid 6:48.91mb:48.96mb

#the "baseDir" argument specifies where the input data is located

#the "include" argument specifies which data sources to include in the analysis
#by default RD is included

#the "plot" argument specifies whether to produce plots of
#the underlying data along with the segmentation
#to enable plotting set "plot" to 1
#if plot is set to 0, no plots will be created and the process will be faster

#the "numIt" argument defines the number of training iterations, which is set to
#5 here but should be increased if analyzing many samples simultaneously

java -Xmx3800m -cp ./cnvOffSeq.jar lc1.dp.appl.CNVHap --paramFile param.txt --mid 6:48.91mb:48.96mb --baseDir ./data/ --index 1 --column 1 --numIt 5 --include RD --plot 0 --r_panel true --b_panel true --showScatter false --showHMM false  --expModelIntHotSpot 0.1:1:1e3 --collapseDupStates true > output_msg.txt 2>&1
