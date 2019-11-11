
# Downloading the zipped file using url
fileurl = 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
download.file(fileurl, destfile = 'assignment.zip')

# Unzipping the file
zipfile <- file.choose('assignment.zip')
unzip(zipfile)

# This creates a folder named UCI HAR Dataset
# Reading the train dataset
x_train = read.table('UCI HAR Dataset/train/X_train.txt', header = FALSE)
subject_train = read.table('UCI HAR Dataset/train/subject_train.txt', header = FALSE)
y_train = read.csv('UCI HAR Dataset/train/y_train.txt', header = FALSE)

# Using cbind to append subject_train and y_train to x_train
x_train = cbind(x_train, subject_train, y_train)

# There are 561 features in feature file description
# Checking the dimension for x_train
train_dim = dim(x_train)

# Reading the train dataset
x_test = read.table('UCI HAR Dataset/test/X_test.txt', header = FALSE)
subject_test = read.table('UCI HAR Dataset/test/subject_test.txt', header = FALSE)
y_test = read.table('UCI HAR Dataset/test/y_test.txt', header = FALSE)

# Using cbind to append subject_test and y_test to x_test
x_test = cbind(x_test, subject_test, y_test)

# Checking if the dimensions of the test dataset is same as train dataset
test_dim = dim(x_test)

# Train and Test dataset have same number of columns
# Using rbind to merge the datasets
X = rbind(x_train, x_test)

# Renaming the columns of the dataset dataset
# We'll read the file features file which has names of all the features
features = read.table('UCI HAR Dataset/features.txt', header = FALSE)

# Since there are duplicate column names in the dataset, combining the index to the names
features = str_c(features$V1, features$V2)

# Renaming the merged dataframe columns with the feature names
# Changing the case to lower for removing ambiguity
colnames(X) <- tolower(c(as.character(features), 'Subject', 'Activity'))

# Checking the names of the columns in the merged dataframe
names(X)

# Checking the data type of subject column
typeof(X$activity)

# Since the data type is integer we need to change it to character
X$activity = as.character(X$activity)

# Reading the activity names file to replace the subject names
activity_labels = read.table('UCI HAR Dataset/activity_labels.txt', header = FALSE)[,2]

# Replacing the values in subject column
X$activity = factor(X$activity, levels = c(1, 2, 3, 4, 5, 6), labels = activity_labels)

# Extracting only the columnw which have mean and SD
extracted_features = c(as.character(features[str_which(pattern = 'mean|std', features)]), 'subject', 'activity')
extracted_features

# Selecting the extracted features from the X
X = select(X, tolower(as.character(extracted_features)))

# Extracting the names of the dataset
names(X)

# Removing the numerical values from the column names
colnames(X) = str_remove_all(names(X), '[0-9]')

# Taking average of each column
final_df = X %>%
        group_by(subject, activity) %>%
        summarise_each(mean)

write.table(final_df, 'tidy_dataset.txt')