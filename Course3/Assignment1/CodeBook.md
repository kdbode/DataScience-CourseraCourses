# FitBitTidy Dataset Code Book

This code book summarizes the data found in the fitbitTidy.txt file within this repository. 
More information on how the fitbitTidy file was created can be found in the README.md file in this repository.


## **IDENTIFIERS**
The following columns of data help you identify the subject and activty measured.
- **Subject** - The ID number assigned to each test subject.
  - IDs range from 1 to 30. 
- **Activity** - One of six activities being performed when the measurement was taken.
  - Walking
  - Walking Up Stairs
  - Walking Down Stairs
  - Standing
  - Sitting
  - Laying Down
 
 
## **VARIABLES**
The following columns of data provide reader with additional information on what the final value what and how it was gathered.
- **Instrument** - The instrument type used to gather the measurement
  - **accelerometer** - Average values calculated from measurements with this instrument are in g's (9.81 meters per second squared)
  - **gyroscope** - Average values calculated from measurements with this instrument are in radians per second.
- **Acceleration** - The measurements were seperated into two acceleration signals
  - **body** - Seperated using low pass Butterworth filter with corner frequency of 0.3 Hz
  - **gravity** - Seperated using low pass Butterworth filter with corner frequency of 0.3 Hz
- **Axial** - The three 3-axial signals in the X, Y, and Z direction
  - **x** - x direction
  - **y** - y direction
  - **z** - z direction
- **CalculationType** - The calculation performed on the variable set to obtain the recorded value
  - **mean** - The average of the measurements was calculated
  - **std** - The standard deviation of the measurements was calculated
- **Domain** - The measurements were sepereated into two domain signals
  - **freq** - The Fast Fourier Transform (FFT) was applied to this calculation
  - **time** - These were captured at a constant rate of 50Hz, filtered by a median filter, and filtered by a 3rd order low pass Butterworth filter with a corner frequency of 20Hz to remove noise.
- **Jerk** - The signal was derived from body linear acceleartion and angular velocity
  - **jerk** - The jerk was included in this calculation
  - **NA** - No jerk was included
- **Magnitude** - Calculated using the Euclidean norm of the 3-axial signals
  - **magnitude** - The magnitude was included in this calculation
  - **NA** - No magnitude was included


## **MEASUREMENT**
The final column of data is the averaged total for each combination of variables.
- **Average** - The mean was taken of all rows with the same combination of variables.


## **TRANSFORMATION OF SOURCE FILE**
The source data can be downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The following modifications were made to the original dataset
1. The three datasets within the train folder were merged (X_train, y_train, subject_train).
2. The three datasets within the test folder were merged (X_test, y_test, subject_test).
3. The modified train and test datasets from step 1 and 2 were merged together.
4. The CalculationType variables that didn't calculate a mean or standard deviation were removed.
5. The dataset was transformed to be tall instead of wide by doing the following.
   - Transforming columns that were a pre-defined variable combination into new rows
   - Adding a new column for each variable and setting its different options as factors
6. I took each pre-defined variable set, found the average value of each sets measurement, and removed the individual measurements.

