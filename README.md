# DataCleaningProject

The data sets provided are a result of modification from the data sets that can be found here : 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

All the modifications are available in the run.analysis.R script.

The modification process is presented in steps below:

Step 1 Merging of the data sets from the files X_test.txt and X_train.txt

Step 2 Keeping the variables of the data set that are a result of a mean or standard deviation calculation

Step 3 Reshaping the names of the variables that were kept and adding two columns as provided in the                       
       subject_text, subject_train, y_test and y_train files

Step 4 Writting the first data set in the file dataset1.txt

Step 5 Reading the data set created and from that creating a second data set containing the means for each variable, for each             subject and each activity type

Step 6 Writting the data set we created to the file dataset2.txt