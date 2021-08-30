Data acquisition of our large-scale samples has been divided into several batches. This code is used for normalization and integration of large-scale metabolomics data from multiple batches to remove batch effect. 

If you would like to try it out, this is what you need:

1.A working version of R studio. This should be easy: a simple installation on your laptop could just be done from https://rstudio.com/ 

2.The dataset and R script: we have put them here: 

1)-Sample information
2)-Example data-peak area
3)-Expected output
4)-Normalization R script

For the example data analysis, the necessary information is following:

A total 60 test samples from S01 to S60 were included. After randomization, these samples were divided into 3 batches for sample injection. Sample injection order was listed in the excel named Sample information.

The pooled tissue samples were used as the quality control (QC) samples. The QC samples were inserted in each batch every 10 sample injections. 


"Sample information" contains the sample injection order in each batch.

"Example data-peak area" contains the peak area of detected metabolites in all samples.



More details were shown in the method section of the manuscript.

Please download these, and test the script with Example data.
You can run through the R studio and produce your own simulated data using this script! 

Finally: We'd love to hear from you. Please let us know if you have any comments or suggestions, or if you have questions about the code or the procedure. 

