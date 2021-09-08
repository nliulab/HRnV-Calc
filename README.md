# HRnV-Calc: Software for Heart Rate n-Variability Analysis



 - **[HRnV-Calc Introduction](#hrnv-calc-introduction)**
      - [Description](#description)
      - [Installation](#installation)
      - [Citation](#citation)
      - [Contact](#contact)
- **[HRnV/HRV Methods and Metrics](#hrnvhrv-methods-and-metrics)**
  - [Methods and Metrics Documentation](#methods-and-metrics-documentations) 
- **[HRnV-Calc Tutorial](#hrnv-calc-tutorial)**
  - [Data Loader](#data-loader)


## HRnV-Calc Introduction
### Description
The HRnV-Calc software is a heart rate variability (HRV) analysis software with the novel [HRnV method](https://bmccardiovascdisord.biomedcentral.com/articles/10.1186/s12872-020-01455-8) built in. The software is built upon the core HRV analysis code provided by [PhysioNet Cardiovascular Signal Toolbox (PCST)](https://physionet.org/content/pcst/1.0.0/). In addition to the fully automated command-line HRV analysis process provided by PCST, HRnV-Calc offers the HRnV metrics to augment insights discovered by HRV as well as intuitive graphical user interfaces (GUIs) for every major step of HRV and HRnV analysis. 

### Installation
The HRnV-Calc software is available freely on GitHub under the [GNU GPL (v3 or later)](https://www.gnu.org/licenses/gpl-3.0.en.html) license. 

To begin, please download and install [Matlab](https://www.mathworks.com/) (2017b or higher) (required Matlab Toolboxes: Signal Processing Toolbox, Statistics and Machine Learning Toolbox, Neural Network Toolbox, and Image Processing Toolbox)

Before using the GUIs and HRnV analysis provided by HRnV-Calc, users need to install PCST for the core signal analysis and HRV toolkits that HRnV-Calc depends on. Users may use the installation script – [‘Install_Dependency.m’](Install_Dependency.m) included in HRnV-Calc to automatically download and install PCST. 

Alternatively, PCST can be manually downloaded from [PhysioNet](https://physionet.org/content/pcst/1.0.0/PhysioNet-Cardiovascular-Signal-Toolbox.zip) and added to the directory containing HRnV-Calc code as a subdirectory. Do note that the name of the folder containing PCST should not be changed, as HRnV-Calc will check the existence of the original PCST folder before the software starts. 

### Citation
If you are using HRnV-Calc, please cite PCST and other related papers:

```
[1] Vest, A. N., Da Poian, G., Li, Q., Liu, C., Nemati, S., Shah, A. J., & Clifford, G. D. (2018). 
    An open source benchmarked toolbox for cardiovascular waveform and interval analysis. 
    Physiological measurement, 39(10), 105004. https://doi.org/10.1088/1361-6579/aae021

[2] Liu, N., Guo, D., Koh, Z. X., Ho, A., Xie, F., Tagami, T., Sakamoto, J. T., 
    Pek, P. P., Chakraborty, B., Lim, S. H., Tan, J., & Ong, M. (2020).
    Heart rate n-variability (HRnV) and its application to risk stratification of chest pain patients in the emergency department. 
    BMC cardiovascular disorders, 20(1), 168. https://doi.org/10.1186/s12872-020-01455-8
 
```  
### Contact
- Dagang Guo (Email: <guo.dagang@duke-nus.edu.sg>)
- Chenglin Niu (Email: <chenglin.niu@u.duke.nus.edu>)
- Nan Liu (Email: <liu.nan@duke-nus.edu.sg>)

## HRnV/HRV Methods and Metrics 
### Methods and Metrics Documentations
For a simple demonstration of how the HRnV method work, please check the documentation of HRnV.

A brief description of all HRV/HRnV metrics provided by HRnV-Calc can be found in the list below. 

## HRnV-Calc Tutorial
HRnV-Calc is primarily operated using its step-by-step GUIs, which include four main interfaces: (1) [Data Loader](#data-loader), (2) [QRS Detection & Edits viewer](#qrs-detection-and-edits-qde-viewer), (3) [$HR_nV_m$  Setting viewer](#hr_nv_m-setting-viewer), and (4) $HR_nV_m$ Results Display. Each of these interfaces will be presented one at a time for every step of HRnV and HRV analysis. 
### Data Loader
The initial GUI of HRnV-Calc is Data Loader, which provides basic settings for users to begin HRV/HRnV analysis. Users may choose to perform analysis on a single file or multiple files as batch-processing. It is noteworthy that the current version of HRnV-Calc supports **only batch processing on RRI (IBI) inputs**, which do not require manual QRS inspection to complete the HRV/HRnV analysis. 

<figure class="image" align="center">
  <img src="../HRnV-Calc/figs/Data_loader.png" >
  <figcaption>Data Loader</figcaption>
</figure>

#### Data Type and Formats
Currently, HRnV-Calc accepts five different input types, which include:

- Raw ECG (*.txt, *.csv)
- IBI (*.txt, *.csv)
- Kubios ECG files (*.mat) saved by [Kubios HRV](https://www.kubios.com/)
- Kubios IBI (*.mat)
- ECG PC -- ECG singal with peak positions (*.csv) saved by HRnV-Calc. 

#### Single/Batch Processing
**Single File** lets users to conduct HRV/HRnV analysis on one single input file at a time. This option supports all data types. Once the data type is configured, users may click on the 'Open File/Folder' button to navigate and locate the input file. Note that HRnV-Calc will only display files in supported formats for the specified data type.


**Batch Files** allows users to conduct HRV/HRnV analyses on **multiple RRI input files** simultaneously. To conduct batch processing, all input RRI files have to be in the same format (either *.txt or *.mat) and saved under the same directory. Users may use 'Open File/Folder' button to navigate and locate the input directory, and HRnV-Calc will automatically analyze all supported files in the directory. 

#### Adult/Infant Processing Profile
Since infant ECG and RRI signals have distinct features to the ones from adults, HRnV-Calc has two processing profiles for users to choose from for downstream analysis. For more details about the profiles, please refer to the [PCST paper](https://iopscience.iop.org/article/10.1088/1361-6579/aae021).

#### Sampling Rate
For ECG inputs, users need to specify the sampling rate of the signal. There are two predetermined sampling rates to choos: 125Hz or 250Hz. If the signal is sampled using other rates, users may choose the 'Others' option and type in the sampling rate. 

For RRI inputs, this section will not be avaible, as the sampling rate does not affect the analysis on RRI. HRnV-Calc will assign one of the default rates to the input. 


#### Record ID Extraction
By default, HRnV-Calc will use the full file name (e.g., Demo_NSR16786.txt) of the input as record ID to store and display analysis results. Users may customize the ID extraction by specifying the prefix and postfix of the input file. For example, as shown in the figure above and all subsequent figures, record ID 'NSR16786' can be extracted from the file name by specifying the prefix to be 'Demo_' and postfix to be '.txt'. 

#### Cofirmation Window
Once the input files and all settings in the Data Loader are properly configured, users may click on 'Next' to proceed to the next step. A confirmation window will be displayed to let users double check on the settings made in the Data Loader. If it is necessary to change any setting, clicking 'Back' will bring up the Data Loader agian. The 'Next' button will bring up the QRS Detection and Edits (QDE) Viewer for ECG inputs or $HR_nV_m$  Setting viewer for RRI inputs. 

<figure class="image" align="center">
  <img src="../HRnV-Calc/figs/Confirmation.png" >
  <figcaption>Setting Confirmation</figcaption>
</figure>

### QRS Detection and Edits (QDE) Viewer
The QDE viewer is designed to configure and inspect QRS detection on **ECG signals**. All settings and tools for QRS detection and inspection can be found in the setting section at the top. 

<figure class="image" align="center">
  <img src="../HRnV-Calc/figs/QDE_full.png" >
  <figcaption>QDE Viewer</figcaption>
</figure>

#### Segmentation of ECG
The ‘Signal Type’ section allows users to choose whether the full ECG or a segment of it should be analyzed. 

If the 'Segment' option is selected, the 'Display settings & ECG Segment Selection' section will be availabe to users to navigate and select the desired segment. 

There are three choices of segment length can be selected in the segmentation subsection: 5 min, 10 min, and 15 min. Users may change ‘Display Duration’ and ‘Display overlay’ to better navigate and locate the desired part of the ECG signal for segmentation.

As shown in the figure below, to select the starting point of the segment, click the ‘Select start point’ button, and then choose the starting point by clicking on the ECG plot displayed in the middle of the QDE viewer. Single clicks will be plotted on the ECG plot as crossing marks for reference. To avoid unintended inputs, such clicks are not stored as the actual starting points. Users may **finalize the choice of the starting point by double clicking** on the desired point in the ECG plot. Alternatively, right clicking will also finalize the starting point as the last single click position.  It is worth noting that only the horizontal position (i.e., the X-axis coordinate) of the click will be used to locate the starting point of the segment. Once the starting point is finalized, the **end point of the segment with specified length will be automatically displayed** on the ECG plot as a green dot. Users may finalize the choice of the end point by clicking the ‘Confirm End Point’ button and thus confirm the segmentation of the ECG signal.

<figure class="image" align="center">
  <img src="../HRnV-Calc/figs/QDE_seg_select.png" >
  <figcaption>Segmentation of ECG</figcaption>
</figure>

#### Noise Removal and Local Checkup

The baseline drift in the ECG signal can be removed by checking the 'Baseline Drfit Removal' option. 

Although the *jqrs* algorithm used in HRnV-Calc is one of the most robust and well-regarded QRS detection methods, it may sometimes yield unexpected annotation results, especially when taking ECG inputs with downwards R peaks (i.e., R peak being the local minimum of the signal). Therefore, HRnV-Calc performs **additional check on the *jqrs* output to modify the annotation to the local maximum** within a small region (10 samples before and after the original *jqrs* peak annotation, regardless of the sampling rate). If the input has downwards R peaks, the **‘Downwards QRS Peak’ option in the QDE viewer enables HRnV-Calc to modify the annotation to the local minimum**. If such a modification is deemed unnecessary, users may **uncheck the ‘Modify to local supremum’ option in the QDE viewer to skip the additional check**. 

#### Peak Detection and Editing
The 'QRS Peak Detection' button lets users to perform QRS detection on the selected ECG segment. The peak annotations will be plotted in the 'Denoised ECG Plot' as red dots. 

Manual correction of R peaks can be done in the ‘Denoised ECG Plot’ . users may first remove the incorrect R peaks by clicking on the ‘Remove Peak’ button and then **double click on the marked peak annotations to remove them**. Removal of the R peaks can be **stopped by a single right click**. Since HRnV-Calc performs checks to verify if there are two R peaks too close to each other, it is advised to always **remove the undesired R peaks before adding new ones**. All R peaks editing can be reversed by performing the QRS detection again.

To add a new peak annotation to the ECG signal, click on the ‘Add Peak’ button and **double click on the point where the new annotation will be added**. HRnV-Calc will **automatically mark the local maximum** (or minimum if ‘Downwards QRS Peak’ is selected) within a small region surrounding the selected point as the new R peak, since manual positioning of the exact R peak can be erroneous. Please note that clicking on the ‘Add Peak’ button will only allow users to add one peak to the signal. 

#### Saving Peak Annotation and Proceed
Mannual edits of the peak annotations can be saved by clicking 'New QRS Manual Edit' button. Once the QRS detection is finalized, users may proceed to $HR_nV_m$  Setting viewer for downstream analysis by clicking on 'HRnVm Calculation'. 

### $HR_{n}V_{m}$ Setting Viewer
$HR_nV_m$ analyses are configured in the $HR_nV_m$ Setting viewer. In the '$HR_nV_m$' section, users may choose to perform a single $HR_nV_m$ analysis by choosing the option **‘Single’** and specifying the desired $n$ and $m$ values. When choosing the option ‘HRnV (m = n)’, HRnV-Calc will perform $HR_nV$ (or $HR_nV_n$) analysis on the input depending on the specified $n$. By default, HRnV-Calc will perform the conventional HRV analysis with $n = 1$ and $m = 1$. 

<figure class="image" align="center">
  <img src="../HRnV-Calc/figs/HRnVm_setting.png" >
  <figcaption>HRnVm Setting</figcaption>
</figure>


The option **‘All’** lets users perform all $HR_nV_m$ analyses with $n$ and $m$ no greater than the specified $n$. For example, if $n$ is set to be 2, HRnV-Calc will conduct $HR_1V$ (i.e., conventional HRV), $HR_2V_1$, and $HR_2V$ analyses on the input signal altogether. The default value of n for this option is 1, indicating only the conventional HRV analysis to be performed. Note that the results generated using this option will not be shown in the $HR_nV_m$ Display, even when n is set to 1. Users may check the stored Excel sheets for detailed results. 

The **Ectopic Beats** section lets users allows users to specify the threshold (default: 20%) for a beat to be considered as an outlier and to select how outliers should be processed (default: remove). It should be noted that the detection and processing of ectopic beats will only be conducted on the original RRI. All $RR_nI_m$ intervals will be generated from the processed RRI intervals without further processing. 

In the **Frequency Domain** section, user may choose one of the four PSD methods (default: Lomb) provided in PCST. For details of each PSD estimate method, please refer to the [PCST paper](https://iopscience.iop.org/article/10.1088/1361-6579/aae021).

The **Use Kubios Preset** option lets users to modify the settings of some nonlinear methods used in HRnV-Calc according to the [published documentations of Kubios HRV](https://doi.org/10.1016/j.cmpb.2013.07.024). Note that the preset will not yield identiacal results to the ones generated by Kubios HRV, as the exact preprocessing methods used in Kubios HRV are proprietary. 


