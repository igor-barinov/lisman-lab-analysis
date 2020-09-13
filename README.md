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
      - [**Data Modifiers**](#data-modifiers)
      - [**Plotting**](#plotting)
      - [**Saving/Closing Data**](#savingclosing-data)
      - [**Tools and Preferences**](#tools-and-preferences)
  - [MATLAB Statistics: stats_IB](#matlab-statistics-stats_ib)
    - [Installation](#installation-1)
    - [Usage](#usage-1)

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
Once *analysis_1_2* is added to MATLAB's path along with all dependencies, you can start the program by either opening `analysis_1_2_IB_XXXXXX.fig` or entering `analysis_1_2_XXXXXX` into MATLAB's command line interface, where `XXXXXX` is replaced by the appropriate version.

#### **Supported Files**
*analysis_1_2* uses Region of Interest (ROI) files to open, edit, and save data. There are four formats for ROI files. Here are the differences:

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
##### DNA Type
You can add experiment information such as the DNA type and solutions used in the experiment. To change the DNA type, add/edit the text box labeled `DNA Type`. To describe multiple DNA types, delimit each type with semi-colons (`;`), ex: `Camui; mlsn2b`. Otherwise, any character sequence is a valid DNA type.

##### Solutions
You can add solution information such as name and time of application using the solution table. To add a solution click on `Add Solution` and enter both the solution name and timing. Solution timing is measured in number of data points ranging from 1 to the total number of data points.

You can edit solutions by directly editting the solution table. Both the name and timing can be editted. If the name is deleted, you will be prompted to either keep or delete the solution entry.

Multiple solutions with the same timing can be described like DNA types by using semi-colons (`;`). You can omit entries before and after semi-colons to describe only some solutions occuring at a certain timing, ex: `solutionA; ; solutionC`.

To remove some or all solutions, click on `Remove Solution` and select which solution entries you want to remove.

##### Importing Information



#### **Data Editting**
#### **Data Modifiers**
#### **Plotting**
#### **Saving/Closing Data**
#### **Tools and Preferences**

## MATLAB Statistics: stats_IB
### Installation
### Usage