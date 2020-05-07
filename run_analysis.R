#################################################################################################################################
#################################### FIRST DATA SET #############################################################################
#################################################################################################################################
library(data.table)
library(dplyr)


## Merging the two data sets.

test <- read.table('./X_test.txt',sep='',header = F)
train <- read.table('./X_train.txt',sep='',header=F)
complete <- rbind(test,train)
#-------------------------------------------------------------------------

## Adding the original names to the variables and keeping only the variables that correspond to means and standard deviations.

features <- read.table('./features.txt',sep='')
names(complete) <- features[,2]
meanpos <- grep('mean()',features$V2) # finding the indexes for the mean variables
stdpos <- grep('std()',features$V2)   # finding the indexes for the variables corresponding to standard deviations
freqpos <- grep('meanFreq',features$V2) # a problem is created with the varibles containing meanFreq that we dont want to keep
meanpos <- setdiff(meanpos,freqpos) # we use the set difference to exlude the positions of those varibles from the ones in meanpos
data <- complete[,c(meanpos,stdpos)]
#-------------------------------------------------------------------------

## Adding the type variable to the data set and assigning coprehensive labels to the different types of activity.

typetest <- read.table('./y_test.txt',sep='')
typetrain <- read.table('./y_train.txt',sep='')
type <- rbind(typetest,typetrain)
data <- cbind(type,data)
names(data)[1] <- 'activitytype' # adding a name to the new collumn 
data <- fixtype(data) #using the function fixtype (below) to assign coprehensive labels to the dofferent types of activity
#--------------------------------------------------------------------------

## Adding the subject variable to the data set.

subjtest <- read.table('./subject_test.txt',sep='')
subjtrain <- read.table('./subject_train.txt',sep='')
subject <- rbind(subjtest,subjtrain)
data <- cbind(subject,data)
names(data)[1] <- 'subjectnumber' #adding a name to the new collumn
#--------------------------------------------------------------------------

## We fix the rest of the variable names to make them more handy.
names(data) <- gsub('-','',names(data)) # removing the dashes
names(data) <- tolower(names(data)) # replacing all capital with lower case
#--------------------------------------------------------------------------

## Writting the data set we have formulated to a txt file
write.table(data,file='./dataset1.txt',sep='\t',row.names=F,quote=F)

#--------------------------------------------------------------------------
## The function fixtype is used to replace the numeric IDs with the respective activites rendering readability.
fixtype <- function(data){
  activities <- c('Walking','Walking_Upstairs','Walking_Downstairs','Sitting','Standing','Laying')
  for(i in 1:6){
    data[grep(as.character(i),data$activitytype),1] <- activities[i]
    }
  data
}
#################################################################################################################################
################################################ SECOND DATA SET ################################################################
#################################################################################################################################

## We read the data set we oreviously created as a data.table object to make the loading faster and the subsetting more convenient
data2 <- fread('./dataset1.txt',sep = '\t')

#----------------------------------------------------------------------------


## We us the function getchunk (below) to get the means of the variables for each type of activity. The i argument is assigned the number of
## each subject. We start with the first subject and then we bind every other chunk in the for loop.
data <- getchunk(1)
for(i in 2:30){
  chunk <- getchunk(i)
  data <- rbind(data,chunk)
}

#----------------------------------------------------------------------------


## Finally we write the second data set we have formulated to a txt file.
write.table(data,file='dataset2.txt',sep='\t',row.names=F,quote=F)
data #return fot the requirements of the project
#-----------------------------------------------------------------------------

## The function getchunk calculates the mean of the variables for the six types of activities given the subject number and returns
## a well formated data frame to be utilised in the for loop above.
getchunk <- function(i){
  subjiter <- data2[data2$subjectnumber==i] #we get the subset of the data table that corresponds to the ith subject
  test <- split(subjiter,subjiter$activitytype) # we split the subset creating a list whose six elements are the values of the subset
                                                # that correspond to each type of activity

  chunk <- sapply(test,function(x){apply(as.matrix(x[,3:68]),2,function(x){mean(x,na.rm=T)})}) 
  #The apply function is used to calculate the means for each element of the list created above.The sapply function is used to 
  # iterate over all the elements of the list and return a matrix.
                                          
  chunk <- as.data.frame(t(chunk)) #we transpose the matrix
  chunk <- cbind(rownames(chunk),chunk) #we add the activity type name column
  chunk <- cbind(c(i,i,i,i,i,i),chunk) #we add the subject number column
  names(chunk)[2] <- 'actitiytype'#fixing name labels
  names(chunk)[1] <- 'subjectnumber'
  rownames(chunk) <- NULL
  
  chunk
}


