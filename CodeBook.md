Code Book

Aim: To create a script which
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each 
   activity and each subject.

The script run_analysis.R provided accomplishes the tasks in the following way:
1. Downloading the zip folder containing the dataset
  i. The script will download the zip folder into the current working directory of R.
  ii. It will unzip the zipped file. The unzipped folder is named 'UCI HAR Dataset'
  iii. The following files are read to gather the data. 
  		* X_train.txt - to read the training data
  		* y_train.txt - to read the activity for which the data is defined in X_train.txt
  		* subject_train.txt - to read the subject number
  		* X_test.txt - to read the test data
  		* y_test.txt - to read the activity for which data is defined in X_test.txt
  		* subject_test - to read the subject number

2. The files mentioned above are read and merged to create a consolidated data frame. The dimension of the final 
   dataframe is (10362, 563).

3. To extract the colnames for the dataset, we use features.txt file. There is one issue with the column names. The names
   are repeated for a few columns. The repeated column names are described below.
      		   COLUMN NAMES            FREQ    
      fbodyacc-bandsenergy()-1,16        3
      fbodyacc-bandsenergy()-1,24        3
      fbodyacc-bandsenergy()-1,8         3
      fbodyacc-bandsenergy()-17,24       3
      fbodyacc-bandsenergy()-17,32       3
      fbodyacc-bandsenergy()-25,32       3
      fbodyacc-bandsenergy()-25,48       3
      fbodyacc-bandsenergy()-33,40       3
      fbodyacc-bandsenergy()-33,48       3
      fbodyacc-bandsenergy()-41,48       3
      fbodyacc-bandsenergy()-49,56       3
      fbodyacc-bandsenergy()-49,64       3
      fbodyacc-bandsenergy()-57,64       3
      fbodyacc-bandsenergy()-9,16        3   
      fbodyaccjerk-bandsenergy()-1,16    3
      fbodyaccjerk-bandsenergy()-1,24    3
      fbodyaccjerk-bandsenergy()-1,8     3
      fbodyaccjerk-bandsenergy()-17,24   3
      fbodyaccjerk-bandsenergy()-17,32   3
      fbodyaccjerk-bandsenergy()-25,32   3
      fbodyaccjerk-bandsenergy()-25,48   3
      fbodyaccjerk-bandsenergy()-33,40   3
      fbodyaccjerk-bandsenergy()-33,48   3
      fbodyaccjerk-bandsenergy()-41,48   3
      fbodyaccjerk-bandsenergy()-49,56   3
      fbodyaccjerk-bandsenergy()-49,64   3
      fbodyaccjerk-bandsenergy()-57,64   3
      fbodyaccjerk-bandsenergy()-9,16    3
      fbodygyro-bandsenergy()-1,16       3
      fbodygyro-bandsenergy()-1,24       3
      fbodygyro-bandsenergy()-1,8        3   
      fbodygyro-bandsenergy()-17,24      3
      fbodygyro-bandsenergy()-17,32      3
      fbodygyro-bandsenergy()-25,32      3
      fbodygyro-bandsenergy()-25,48      3
      fbodygyro-bandsenergy()-33,40      3
      fbodygyro-bandsenergy()-33,48      3
      fbodygyro-bandsenergy()-41,48      3
      fbodygyro-bandsenergy()-49,56      3
      fbodygyro-bandsenergy()-49,64      3
      fbodygyro-bandsenergy()-57,64      3
      fbodygyro-bandsenergy()-9,16       3

	  In order to counter the issue, the column names are read and named using the concatenation of indexes 
	  of the file features.txt and the actual column names. This removed the duplicacy of the data.
	  After renaming the columns using the way monetioned above, the columns are filtered to on the basis of
	  the column names containing the mean or std word in it. The numerical characters in the column names are
	  removed using the str_remove_all function from stringr package. The casing of the column is also changed 
	  to lower case to remove any ambiguity about the casing of the column names.   

4. In order to replace the activity values with the labels for each activity, we have to read the file 
   activity_labels.txt. This file contains the mapping for the activity number and the activity label. The activity 
   labels are as defined below:
   	  1 WALKING
   	  2 WALKING_UPSTAIRS
   	  3 WALKING_DOWNSTAIRS
   	  4 SITTING
   	  5 STANDING
   	  6 LAYING
   The data type for the activity column in the joined data frame in integer. We have to convert the variable into 
   factor in order to replace with the labels in the activity column of the data frame. In order to accomplish this,
   the column is first coerced to character and then to a factor by providing activity labels read from the text file 
   as labels. This replaces the numerical catergorical variable with the labels as are required.

5. The main principle of the tidy dataset is One observation per row and one variable per column. We can accomplish that 
   using the group by function from the dplyr package, and grouping the dataframe on the basis of subject and activity
   and using summarise_each function to summarise each column of the dataset using the mean function. This gives us the 
   final dataframe with 180 rows containing one mean value for each subject and activity and each kind of observation. 