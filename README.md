# Lisman Lab Analysis
> A collection of scripts used at the Lisman Lab at Brandeis

**Table of Contents**
- [Lisman Lab Analysis](#lisman-lab-analysis)
  - [MATLAB Analysis: analysis_1_2](#matlab-analysis-analysis_1_2)
    - [Installation](#installation)
      - [**Environment Setup**](#environment-setup)
      - [**Downloading analysis_1_2**](#downloading-analysis_1_2)
      - [**Downloading Dependencies**](#downloading-dependencies)
      - [**Downloading FLIMage**](#downloading-flimage)
    - [Usage](#usage)
      - [**Running analysis_1_2**](#running-analysis_1_2)
      - [**Supported Files**](#supported-files)
        - [Opening Files](#opening-files)
        - [Multiple Files](#multiple-files)
      - [**Experiment Information**](#experiment-information)
        - [DNA Type](#dna-type)
        - [Solutions](#solutions)
        - [Importing Information](#importing-information)
      - [**Data Editting**](#data-editting)
        - [Adding Rows](#adding-rows)
        - [Deleting Rows](#deleting-rows)
        - [Zeroing Rows](#zeroing-rows)
        - [Fixing Data](#fixing-data)
      - [**Data Modifiers**](#data-modifiers)
        - [Adjusting Time](#adjusting-time)
        - [Normalizing Values](#normalizing-values)
        - [Enabling/Disabling ROIs](#enablingdisabling-rois)
      - [**Plotting**](#plotting)
        - [Selecting What to Plot](#selecting-what-to-plot)
        - [Plotting All Data](#plotting-all-data)
        - [Plotting Selected Data](#plotting-selected-data)
        - [Plotting Averages](#plotting-averages)
        - [Plot Annotations](#plot-annotations)
      - [**Saving/Closing Data**](#savingclosing-data)
        - [Saving ROI Data](#saving-roi-data)
        - [Closing ROI Data](#closing-roi-data)
      - [**Tools and Preferences**](#tools-and-preferences)
        - [Analysis Tools](#analysis-tools)
        - [Preferences](#preferences)
  - [MATLAB Statistics: stats_IB](#matlab-statistics-stats_ib)
    - [Installation](#installation-1)
      - [**Downloading stats_IB**](#downloading-stats_ib)
    - [Usage](#usage-1)
      - [**Running stats_IB**](#running-stats_ib)
      - [**Supported Files**](#supported-files-1)
      - [**Sampling Data**](#sampling-data)
        - [By Selection](#by-selection)
        - [By Time Range](#by-time-range)
        - [Sample Table](#sample-table)
      - [**Descriptive Statistics**](#descriptive-statistics)
        - [Mean and Standard Error](#mean-and-standard-error)
      - [**Statistical Tests**](#statistical-tests)
        - [Difference in Means](#difference-in-means)

## MATLAB Analysis: analysis_1_2
### Installation
#### **Environment Setup**
MATLAB is required to run these scripts. These scripts were developed in MATLAB release 2018b, but they should be backwards compatible up to release 2012. 

MATLAB keeps track of files with a path variable. Make a directory that will contain all of the scripts. Here is an example directory structure:
```
-> .../lisman-lab-scripts/
  -> analysis_1_2/
  -> depenedencies/
```
Add the directory and subfolders to MATLAB's path

#### **Downloading analysis_1_2**
Navigate to [lisman-lab-analysis/analysis_1_2](https://github.com/igor-barinov/lisman-lab-analysis/tree/master/analysis_1_2_IB). Download the file called [release.zip](https://github.com/igor-barinov/lisman-lab-analysis/blob/master/analysis_1_2_IB/release.zip) and extract the contents into the directory you made.

#### **Downloading Dependencies**
Navigate to [lisman-lab-analysis](https://github.com/igor-barinov/lisman-lab-analysis). Download the file called [lib.zip](https://github.com/igor-barinov/lisman-lab-analysis/blob/master/lib.zip) and extract the contents into the directory you made.

#### **Downloading FLIMage**
Download FLIMage using the [installer](https://github.com/ryoheiyasuda/FLIMage_Installer) made by [ryoheiyasuda](https://github.com/ryoheiyasuda). After installing FLIMage, you need to add it to the system path. Follow these steps for Windows:

>Find and open the environment variable settings 

![Search](https://user-images.githubusercontent.com/23390420/93026476-2f150500-f5d4-11ea-9a10-2bfa1ad1a4dd.png)

> Click on "Environment Variables"

![Environment Variables](https://user-images.githubusercontent.com/23390420/93026477-2fad9b80-f5d4-11ea-9200-77f305657932.png)

> Select the system variable called "Path" and click on "Edit"

![Select Path](https://user-images.githubusercontent.com/23390420/93026478-2fad9b80-f5d4-11ea-9b6c-2b9807e9ae3a.png)

> Click on "New" then click "Browse"

![New and browse](https://user-images.githubusercontent.com/23390420/93026480-2fad9b80-f5d4-11ea-8881-6b7d8192e0aa.png)


> Navigate to the directory containing "FLIMage.exe" and click "Ok" and save changes

![Select directory and save](https://user-images.githubusercontent.com/23390420/93026481-2fad9b80-f5d4-11ea-9ee2-3f3c49b355c0.png)

To see if FLIMage was added to the path, open command prompt and enter either `FLIMage` or `FLIMage.exe`. If FLIMage did not launch, make sure FLIMage is installed properly and that the correct directory was added to the system path.

### Usage
#### **Running analysis_1_2**
Once `analysis_1_2` is added to MATLAB's path along with all dependencies, you can start the program by either opening `analysis_1_2_IB_XXXXXX.fig` or entering `analysis_1_2_XXXXXX` into MATLAB's command line interface, where `XXXXXX` is replaced by the appropriate version.

#### **Supported Files**
`analysis_1_2` uses Region of Interest (ROI) files to open, edit, and save data. There are four formats for ROI files. Here are the differences:

| ROI File Format | Extension | Uneditted Data | Adjusted Data | Averaged Data | Experiment Info |
| - | - | - | - | - | - |
| FLIMage   | .csv | ✔️ | ❌ | ❌ | ❌ | ❌ |
| Raw       | .mat | ✔️ | ❌ | ❌ | ❌ | ❌ |
| Prepared  | .mat | ✔️ | ✔️ | ❌ | ✔️ | ❌ |
| Averaged  | .mat | ❌ | ❌ | ❌ | ✔️ | ✔️ |

##### Opening Files
Files can be opened by going to `File -> Open` in the menu. You will be presented with a dialog to choose the file. If you select a *prepared* ROI file, you will be prompted to choose either raw or prepared data. Selecting raw will treat the file as a *raw* ROI file, otherwise the file will open as a *prepared* ROI file.

##### Multiple Files
Multiple files can be opened at once, as long as they have the same format. If you select multiple *prepared* or *averaged* ROI files, you will be notified of any experiment information discrepancies (e.g. missing information or different DNA types)

#### **Experiment Information**
> Experiment information consists of a DNA type and the solutions used during the experiment

##### DNA Type
To change the DNA type, add/edit the text box labeled `DNA Type`. To describe multiple DNA types, delimit each type with semi-colons (`;`), ex: `Camui; mlsn2b`. Otherwise, any character sequence is a valid DNA type.

##### Solutions
You can add solution information such as name and time of application using the solution table. To add a solution click on `Add Solution` and enter both the solution name and timing. Solution timing is measured in number of data points ranging from 1 to the total number of data points. Solutions with the first unique timing are the baseline solutions. The next unique timing will dictate the number of baseline points.

> This table corresponds to 2 baseline solutions with 5 baseline points

| Solution | Timing |
| - | - |
| BaselineA | 1 |
| BaselineB | 1 |
| SolutionA | 5 |
| SolutionB | 10 |

You can edit solutions by directly editting the solution table. Both the name and timing can be editted. If the name is deleted, you will be prompted to either keep or delete the solution entry.

Multiple solutions with the same timing can be described like DNA types by using semi-colons (`;`). You can omit entries before and after semi-colons to describe only some solutions occuring at a certain timing, ex: `solutionA; ; solutionC`.

To remove some or all solutions, click on `Remove Solution` and select which solution entries you want to remove.

##### Importing Information
You can import experiment information from either a Word Document or other ROI files with existing experiment information. To import information from a Word Document, the document must be formatted properly. Here are the supported patterns:

| Information | Note Pattern (brackets indicate position of information) |
| - | - |
| DNA Type | `... NOMMDDYYX [DNA TYPE] cells are ...` |
| Baseline Solution | `... Start with [BASELINE SOLUTION] ( ...` |
| Solution with Timing | `... After img[TIMING] start [SOLUTION]. ...` |

To import information click on `Import Info`. You will be able to select either Word files or ROI files. Only *prepared* and *averaged* ROI files will contain experiment information.

#### **Data Editting**
> Only *FLIMage*, *raw*, and *prepared* ROI files support data editting.

##### Adding Rows
After selecting a cell or row in the data table, you can go to `Data -> Row` and click on `Add Above` or `Add Below` to add a row above or below the selection. The new row will be full of zeros.

##### Deleting Rows
You can delete a row of data by making a selection and going to `Data -> Row -> Delete`. You will be prompted to either keep or remove time values. Keeping time values will only delete non-time values. Otherwise both time and non-time values will be removed.

##### Zeroing Rows
You can zero-out a row by making a selection and going to `Data -> Row -> Zero`. Both time and non-time values will be zeroed-out

##### Fixing Data
You can "fix" data by going to `Data -> Fix`. Data is fixed by filling in zeros and NaNs. For time values, the time is assumed to be increasing linearly, so the new values are based off of the calculated rate of change. For non-time values, only values which have valid (non-zero and non-NaN) adjacent data are fixed. The non-time values become either the average of the neighboring data points or direct copies. If the program fails to fix a certain ROI, you have the choice to disable those ROIs.

#### **Data Modifiers**
> Data modifiers are used to adjust data without changing original experimental values

##### Adjusting Time
To adjust time values, the [number of baseline points](#solutions) must be set. Once the number of baseline points are set, click on `Toggle Adjusted Time` to toggle between unadjusted and adjusted time. Adjusted time values are in minutes and equal to zero at the number of baseline points.

##### Normalizing Values
To normalize values, like with adjusted time, the [number of baseline points](#solutions) must be set. Once the number of baseline points are set, click on `Toggle Normalized Values` or go to `Data -> Toggle -> Normalized Values` to toggle between regular and normalized values. Normalized values will have a mean of 1 throughout the baseline points, with the remaining values scaled to according to this constraint.

##### Enabling/Disabling ROIs
Disabling ROIs will hide the ROI data by replacing it with NaNs. Enabling ROIs will revert the NaNs back to the original values. To enable a select few ROIs, make a selection in the data table, and click on `Enable Selected ROI` or go to `Data -> Toggle -> ROI -> Enable Selected`. 

To toggle a single ROI between being enabled and disabled, go to `Data -> Toggle -> ROI` and select the menu item corresponding to the ROI you want to toggle (e.g. `ROI #3`).

To revert all disabled ROIs, go to `Data -> Toggle -> ROI -> Enable All`. All ROIs will then have their original values

#### **Plotting**
> You can plot data, its averages, and any experiment information

##### Selecting What to Plot
Under the `Plot` menu, you can choose to toggle `Show Lifetime`, `Show Green Intensity`, `Show Red Intensity`, and `Show Annotations`. By default, `Show Lifetime`, `Show Green Intensity`, and `Show Red Intensity` will be toggled on. However, if one of the data types are missing (e.g. no valid red intensity values), then you will not be able to plot that data type. `Show Annotations` is toggled off by default, and can only be toggled on once a [DNA type](#dna-type) is present and the [number of baseline points](#solutions) is set.

##### Plotting All Data
To plot all data based on your preferences, go to `Plot -> All`. A figure for each data type will appear. For lifetime values, you will see `Mean Lifetime` over `Time`. For green intensity values, you will see `Mean Green Intensity` over `Time`. For red intensity values, you will see `Mean Red Intensity` over `Time`. Any [data modifiers](#data-modifiers) that are enabled will also affect the plots.

##### Plotting Selected Data
To plot a selection from the data table, make a selection, then go to `Plot -> Selected`. You will see the same thing as plotting all data, except only the selected ROIs will appear.

##### Plotting Averages
To plot the averages, go to `Plot -> Averages`. The plots will appear according to your preferences, and they will contain the mean and standard errors over time. [Data modifiers](#data-modifiers) will also affect the averages plot.

##### Plot Annotations
When `Plot -> Show Annotations` is toggled, you will see annotations describing [solutions](#solutions) and the [DNA type](#dna-type). For *raw* and *prepared* ROI files the DNA types will appear in the plot title. For *averaged* ROI files, the DNA types will appear in the legend. Solution information will appear as horizontal bars along the top of the plot. The length of the bar corresponds to the solution timing. Each bar will have a label below it with the name of the solution.

#### **Saving/Closing Data**
> Once you are finished working on a file, you can either save the edits in another ROI file or just close the file

##### Saving ROI Data
Before saving a file, the minimum amount of [experiment information](#experiment-information) must be present: the number of baseline points and the DNA type. To save the ROI data, go to `File -> Save`. In the dialog that opens, choose where you are saving the file, name the file, and select the type of file you want to save as. You can save the file as one of the [supported file types](#supported-files). If any ROIs are disabled, you will have the option to either save or remove those ROIs. All other [data modifiers](#data-modifiers) will not be applied to the saved ROI data.

##### Closing ROI Data
To close any opened ROI files, go to `File -> Close`. You will be asked to confirm before closing. No data will be saved once a file is closed.

#### **Tools and Preferences**
> Supplementary tools are available along with the preferences menu.

##### Analysis Tools
To use other analysis tools, go to `Tools` and select the corresponding menu item. `SPC Analysis`, `imstack Analysis`, and [`Statistics`](#matlab-statistics-stats_ib) are MATLAB programs. `FLIMage Analysis` is an external C# program.

##### Preferences
To edit preferences, go to `Tools -> Preferences`. Currently, only default [plotting preferences](#selecting-what-to-plot) can be changed.

## MATLAB Statistics: stats_IB
### Installation
> Follow the instructions to [setup the MATLAB environment](#environment-setup) and [download the dependencies](#downloading-dependencies) before installation
#### **Downloading stats_IB**
Navigate to [lisman-lab-analysis/stats_IB](https://github.com/igor-barinov/lisman-lab-analysis/tree/master/stats_IB). Download the file called [release.zip](https://github.com/igor-barinov/lisman-lab-analysis/blob/master/stats_IB/release.zip) and extract the contents into the directory you setup.

### Usage
#### **Running stats_IB**
After adding `stats_IB` to the MATLAB path, you can start the program by either opening `stats_IB_XXXXXX.fig` or entering `stats_IB_XXXXXX` into the MATLAB command line interface, where `XXXXXX` is the appropriate version.

#### **Supported Files**
> See the [files that `analysis_1_2` supports](#supported-files) for more details

`stats_IB` is designed to be used in tandem with `analysis_1_2`, so data is stored in ROI files. All ROI files except *averaged* and *FLIMage* files are supported.

#### **Sampling Data**
> Data can be sampled by selection and time range

##### By Selection
To sample specific data, select the data you want to sample then go to `Sample -> Selection`.

##### By Time Range
To sample a range of data, go to `Sample -> Time Range`. A dialog will appear letting you enter the start and end of the time range. The range you enter is in number of data points and is inclusive.

##### Sample Table
The sample table will split each sample by data type: lifetime, green intensity, and red intensity. The table can be cleared by going to `Sample -> Clear`.

#### **Descriptive Statistics**
##### Mean and Standard Error
To get the mean and standard error of a single sample, go to `Statistics -> M+SE`. A dialog will appear letting you select a single sample.

#### **Statistical Tests**
##### Difference in Means
To test the difference in means, go to `Statistics -> P-Value`. A dialog will appear letting you select 2 samples. After the samples are selected, either a 2-sample t-test or a Wilcoxon Rank Sum test will be performed.