# lisman-lab-analysis
## Programs
- analysis_1_2_IB
- stats_IB
## Installation (for IB Programs)
1. Go to "Analysis/Igor B"
2. Under the program's directory you will find a "release.zip"
3. Download the "release.zip" and make sure the "deps" folder is in MATLAB's path
4. For "analsysis_1_2_IB" make sure you have "spc_drawInit", "h_imstack", "stats_IB" and their dependenicies in the MATLAB path
## Usage
Either run the relevant '.m' file or open the '.fig' file via MATLAB
## analysis_1_2_IB
### ROI Files
ROI (Region of Interest) Files contain time series data. There are 3 data types: lifetime, green intensity, and red intensity.
ROI Files have different versions of this data and some supplemental data depeniding on the file type:
| File Type | Description |
| --------- | ----------- |
| Raw | Contains uneditted experiment data. No experiment information is present |
| Prepared | Contains editted/adjusted experiment data. Experiment information is present |
| Averaged | Contains means and standard errors of editted/adjusted experiment data. Experiment information is present |
### Opening Files
Open files by going to "File->Open" in the menu. Supported file types are raw, prepared, and averaged ROI files.
If you select a prepared ROI file, you will be prompted to select either raw or prepared ROI data.
### Adding Information
#### DNA Type
This input can be any character sequence. To input multiple DNA types add semi-colons between sequences. Ex: "DNA1; DNA2"
#### Solutions
##### Table
The table will display solutions sorted by timing. Timing is measured in the number of data points, which are positive integers.
Solutions are used to set the number of baseline points. The first timing will correspond to baseline solutions. The next timing will indicate how many baseline points there are.
You can edit solution info by editting cells within the table. If the solution name or timing is erased, you will be prompted to delete the changed solution.
##### Adding Solutions
Clicking "Add Solution" will open a prompt to add solution info. You must enter a solution name, which can be any character sequence.
The solutions timing must be within the range of exising data points. You can have multiple solutions per timing.
##### Removing Solutions
Clicking "Remove Solution" will open a prompt to select solutions to remove.
#### Notes
You can add all of the information at once with a properly formatted Word file. 
Click "Import Notes" and select the Word document. If it is properly formatted, the DNA type and solution info will be entered.
You can choose to open a dialog containing the notes. This is how the notes should be formatted for all data to be found:
| Information | Pattern |
| ----------- | ------- |
| DNA type | ... NOMMDDYYX (DNA TYPE) cells are ... |
| Baseline Solution | ... Start with (BASELINE SOLUTION) (... |
| Solution | ... After img(TIMING) start (SOLUTION). ... |

### Data Editting
#### Adding Rows
You can add rows of data by going to "Data->Row" and clicking on "Add Above" or "Add Below". You must first select a cell or row in
the data table. The new row will be all zeros.
#### Removing Rows
You can remove a row of data by going to "Data->Row->Delete". You must first select a cell or row in the data table.
You will be prompted to either keep or remove time values. By keeping time values,
the last time value is removed and all data shifts to fill in the deleted row. By removing time values, the entire row is deleted.
#### Zeroing Rows
You can zero a row of data by going to "Data->Row->Zero". You must first select a cell or row in the data table. The selected row will then be filled with zeros, including time values.
#### Fixing Data
If there are missing data entries, you can fix data by going to "Data->Fix". Time values are assumed to increase linearly, so missing time values are filled according to the calculated rate of change. For all other values, missing entries will use the average of adjacent values. If the first or last entry is missing, the previous/next value will be copied. Consecutive missing entries cannot be fixed.
### Data Modifiers
#### Adjusting Time
To adjust time, at least 2 solutions with different timings must be in the solution table to determine the number of baseline points. You can then click on "Toggle Adjusted Time". Adjusted time is in minutes, where the 0-minute mark is at the number of baseline points. Time before this point is negative.
#### Normalizing Values
To normalize values, at least 2 solutions with different timings must be in the solution table to determine the number of baseline points. You can then click on "Toggle Normalization" or go to "Data->Toggle->Normalized Values". Normalized values have an average of 1 within baseline points.
For averaged files, the already calculated normalized values are used.
#### Enable Selected ROIs
To enable only selected ROIS, select cells or columns in the data table, then click on "Enable Selected ROI" or 
go to "Data->Toggle->ROI->Enable Selected". All other ROIs will be disabled. Disabled ROIs are just columns filled with NaNs.
#### Toggle ROIs
To enable/disable specific ROIs, go to "Data->Toggle->ROI", then click on the corresponding menu item (ROI #...). If this item is checked, then the corresponding ROI is enabled and vice versa.
#### Enable All ROIs
To re-enable all ROIs go to "Data->Toggle->ROI->Enable All". All ROIs will become enabled.
### Plotting
You can plot the data, its averages, and any information
#### Plot All Data
You can plot all ROI data by going to "Plot->All". This will plot data depending on which types of values are chosen to be plotted.
If "Plot->Show Lifetime" is checked, then lifetime values will be plotted.
If "Plot->Show Green Intensity" is checked, then green intensity values will be plotted.
If "Plot->Show Red Intensity" is checked, then red intensity values will be plotted.
Any modifiers applied to the data table will be applied to the plotted data, such as adjusted time and normalized values.
#### Plot Selected Data
You can plot only selected ROIs by selecting cells or columns in the data table then going to "Plot->Selected". As with plotting all values, only the chosen types of values will be plotted with the present modifiers
#### Plot Averages
You can plot the averages of the ROI data by going to "Plot->Averages". The averages along with standard errors will be plotted. Modifiers applied to the data table will be applied to the plotted averages as well. If values are normalized, values are first normalized then averaged.
#### Plot Annotations
You can plot any information along with data by checking "Plot->Annotations". For raw and prepared files, For averages, DNA type will be in the legend. Solutions timings will appear as bars on the top. There will be a bar for each solution, and solutions with the same timing will be stacked vertically.
### Saving Files
You must have the minimum amount of information added before saving (DNA type and 2 solutions).
Once all data is editted and plots are acceptable, you can save the data by going to "File->Save". You will have options to save as either "Prepared ROI Files" or "Averaged ROI Files". Select the file type, enter the filename and the file will be saved. If any ROIs are disabled, you can choose to either keep them or not save them.
### Closing Files
To clear the workspace, you can go to "File->Close". You will be prompted to confirm before closing the file.
### Tools
You can use supplementary tools by going to "Tools" in the menu and clicking on the corresponding item.
### Errors/Bugs
Invalid program use will usually raise warnings to prevent bugs/crashes. If an error does occur, the error will either be logged in a file in the same directory as the script, or an error will be displayed in the console. In either case, a dialog will appear indicating a fatal error. These errors indicate a bug and should be reported.
## stats_IB
### Opening Files
Open a file/file(s) via "File->Open" or by clicking "Open File". Supported files are '.mat' files containing either 'raw' or 'prepared' ROI data. Opening files will not clear data samples.
### Sampling Data
#### By Selection
Select data in the table and either go to "Sample->Selection" or click "Sample Selected Values".
#### By Time Range
Go to "Sample->Time Range" or click "Sample Time Range". Enter the start and end data points that define the time range 
you want.
#### Display
You should see the values appear in the adjacent table seperated by data type (Int, Red, or Tau). You should also see the sample details in the table below. You can clear samples by clicking "Clear Samples"
### Statistics
#### Mean and Standard Error
Go to "Statistics->M+SE" or click "Mean and Std. Error". Select a sample and the statistics will appear.
#### P-Value
Go to "Statistics->P-Value" or click "P-Value". Select 2 samples and the test result along with the p-value will appear.
### Bugs
Invalid usage should result in a warning dialog appearing with instructions to avoid the warning. 
If an error dialog appears, there may be a bug. Report bugs by submitting issues to this repository
