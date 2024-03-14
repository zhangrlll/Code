Overview:
This repository contains MATLAB code for analyzing eye tracking data. The code facilitates the processing of raw data collected from an eye tracker into fixation sequences using the i-dt algorithm. Additionally, it provides functionalities for computing various metrics related to eye movements, such as activate information storage (AIS) and transfer entropy (TE) from retinal flow to fixation.

Folder Structure:

**data_gaze**: Contains raw eye tracking data collected from the eye tracker.

**data_Fixation**: Contains fixation sequences generated from the raw data using the i-dt algorithm.

Usage Instructions:

**result.mlx:**

This MATLAB Live Script contains code to produce the desired results based on the processed fixation sequences.
Execute this script to obtain the results of the eye tracking analysis.

**main_AIS.m:**

Running this MATLAB script will compute all activate information storage (AIS) related results. 

**mainTE2f.m:**

Executing this MATLAB script will compute all transfer entropy (TE) from retinal flow to fixation related results.

Instructions for Running:

Ensure MATLAB is installed on your system.

Place the raw eye tracking data files in the data_fixation folder.

Run the appropriate MATLAB scripts ( main_AIS.m, mainTE2f.m, result.mlx) to perform the desired analysis.

Review the generated results to gain insights into the eye tracking data.
