# HRnV-Calc: A Software for Heart Rate n-Variability and Heart Rate Variability Analysis [![License: GPL v3](https://img.shields.io/badge/License-GPL%20v3-blue)](https://www.gnu.org/licenses/gpl-3.0.html)
 - **[HRnV-Calc Introduction](#hrnv-calc-introduction)**
      - [Description](#description)
      - [Citation](#citation)
      - [Contact](#contact)
- **[Installation](#installation)**
- **[HRnV/HRV Methods and Metrics](#hrnvhrv-methods-and-metrics)**
  - [The HRnV Method](#the-hrnv-method)
  - [Metrics Descriptions](#metrics-descriptions)
- **[Running HRnV-Calc](#running-hrnv-calc)**
  - [Data Loader](#data-loader)
  - [QRS Detection & Edits viewer](#qrs-detection-and-edits-qde-viewer)
  - [HR<sub>n</sub>V<sub>m</sub>   Setting Viewer](#hrnvm-setting-viewer)
  - [HR<sub>n</sub>V<sub>m</sub>  Results Display](#hrnvm-results-display)


## HRnV-Calc Introduction
### Description
The HRnV-Calc software is a heart rate variability (HRV) analysis software with the novel [Heart Rate n-Variability (HRnV) method](https://bmccardiovascdisord.biomedcentral.com/articles/10.1186/s12872-020-01455-8) built in. The software is built upon the core HRV analysis code provided by [PhysioNet Cardiovascular Signal Toolbox (PCST)](https://physionet.org/content/pcst/1.0.0/). In addition to the fully automated command-line HRV analysis process provided by PCST, HRnV-Calc offers the HRnV metrics to augment insights discovered by HRV as well as intuitive graphical user interfaces (GUIs) for every major step of HRV and HRnV analysis. 

The HRnV-Calc software is available freely on GitHub under the [GNU GPL (v3 or later)](https://www.gnu.org/licenses/gpl-3.0.en.html) license.


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


## Installation
To install HRnV-Calc, please download and install [Matlab](https://www.mathworks.com/) (2017b or higher) (required Matlab Toolboxes: Signal Processing Toolbox, Statistics and Machine Learning Toolbox, Deep Learning Toolbox, and Image Processing Toolbox)

Source code of HRnV-Calc and its GUIs can be downloaded from this GitHub repository using the following command:
```
git clone https://github.com/nliulab/HRnV-Calc.git
```

Before using the GUIs and HRnV analysis provided by HRnV-Calc, users need to install PCST for the core signal analysis and HRV toolkits that HRnV-Calc depends on. Users may use the installation script – [‘Install_Dependency.m’](./Install_Dependency.m) included in HRnV-Calc to automatically download and install PCST. 

Alternatively, PCST can be manually downloaded from [PhysioNet](https://physionet.org/content/pcst/1.0.0/PhysioNet-Cardiovascular-Signal-Toolbox.zip) and added to the directory containing HRnV-Calc code as a subdirectory. Do note that the name of the folder containing PCST should not be changed, as HRnV-Calc will check the existence of the original PCST folder before the software starts. 

## HRnV/HRV Methods and Metrics 
### The HRnV Method
To use HRnV-Calc, it is important to know how the HRnV method works. Here we will give a simple explaination of the method. 


HRnV is a method applied to RRIs (i.e., R to R peak intervals). Therefore, the extraction of RRI from ECG for HRnV is exactly the same as conventional HRV. Once the original RRI is obtained, HRnV will generate new intervals called RR<sub>n</sub>I<sub>m</sub>, which is similar to RRI. 

There are two parameters to be specified for the HRnV method: the summation parameter $n$ and the stride parameter $m$. Both $n$ and $m$ can take any positive integer (i.e., $n, m \geqslant 1$) given that $m \leqslant n$. 

To fully describe the process of RR<sub>n</sub>I<sub>m</sub> generation, consider a series of clean RRI (i.e., all outliers and non-sinus beats are removed or processed), $X_i\ (i=1,2,3, \ldots, N)$ of length $N$. With specified $n$ and $m$, the RR<sub>n</sub>I<sub>m</sub> generated from the input RRI, $Y_i\ (i=1,2,3, \ldots, M)$ of length $M$ can be expressed as:

$$
Y_i = \sum_{j=1}^n X_{(i-1) * m+j}\ (j = 1,2,3, \ldots, M)
$$

The length of the new series, $M$, is given by $M=\left\lfloor\frac{N-n+1}{m}\right\rfloor$, where $\lfloor\cdot\rfloor$ represents the floor function. The figure below illustrates a toy example of generating RR<sub>3</sub>I<sub>2</sub> from a RRI series of length 9. 
<p align = "center">
<img src = "./figs/rrni.png">
</p>
<p align = "center">
Generation of RR<sub>n</sub>I<sub>m</sub> Toy Example
</p>

All conventional HRV methods and metrics can then be applied to the new RR<sub>n</sub>I<sub>m</sub> intervals (i.e., feed RR<sub>n</sub>I<sub>m</sub> into conventional HRV analysis as normal RRI). Such metrics, namely HR<sub>n</sub>V<sub>m</sub> metrics, provide additional insights to the conventional HRV. 

### Metrics Descriptions
A brief description of all HRV/HR<sub>n</sub>V<sub>m</sub> metrics provided by HRnV-Calc can be found in the table below. 

| Metrics                           | Units | Description                                                                             |
|-----------------------------------|-------|-----------------------------------------------------------------------------------------|
| **Tiem Domain**                       |       |                                                                                         |
| Average RR                        | ms    | The mean of RR intervals                                                                |
| SDRR                              | ms    | The standard deviation of RR intervals                                                  |
| Average HR                        | 1/min | The mean of heart rate                                                                  |
| SDHR                              | 1/min | The standard deviation of heart rate                                                    |
| RMSSD                             | ms    | Square root of the mean squared differences between successive RR intervals             |
| NN50                              | count | Numbers of RR intervals differ more than 50 ms from the previous intervals              |
| pNN50                             | %     | Percentage of NN50 intervals within the entire RR intervals                             |
| RR Skewness                       | -     | The skewness of the RR intervals distribution                                           |
| RR Kurtosis                       | -     | The kurtosis of the RR intervals distribution                                           |
| RR Triangular Index               | -     | The integral of the RR intervals histogram divided by the height of the histogram       |
| **Frequency Domain**                  |       |      For more detailed documentations of the frequency domain metrics, check out [here](https://github.com/cliffordlab/PhysioNet-Cardiovascular-Signal-Toolbox#frequency-domain-measures-of-hrv-default-using-lomb-periodogram-method).                                                                                   |
| VLF, LF, and HF Peak frequencies  | Hz    | The peak frequencies in the power spectral distribution (PSD) for VLF, LF, and HF bands |
| VLF, LF, and HF Powers            |       | Absolute powers of VLF, LF, and HF bands                                                |
| VLF, LF, and HF Power Percentages | %     | The percentage for powers of VLF, LF, and HF bands within the overall spectrum          |
| LF and HF Normalized Powers       | n.u.  | Normalized powers for LF and HF bands                                                   |
| Total Power                       |       | The overall power of the PSD                                                            |
| LF/HF                             | -     | The ratio between the powers of LF and HF bands                                         |
| **Nolinear Domain**                   |       |                                                                                         |
| Poincare SD1 and SD2              | ms    | The width and length of the eclipse fitted in the Poincare plot                         |
| App_Ent                           | -     | Approximate entropy                                                                     |
| Sam_Ent                           | -     | Sample entropy                                                                          |
| DFA &alpha;<sub>1</sub> and &alpha;<sub>2</sub>                              | -     | Short-term and long-term fluctuations of detrended fluctuation analysis (DFA)           | 


## Running HRnV-Calc
HRnV-Calc is primarily operated using its step-by-step GUIs, which include four main interfaces: (1) [Data Loader](#data-loader), (2) [QRS Detection & Edits viewer](#qrs-detection-and-edits-qde-viewer), (3) [HR<sub>n</sub>V<sub>m</sub>  Setting Viewer](#hrnvm-setting-viewer), and (4) [HR<sub>n</sub>V<sub>m</sub> Results Display](#hrnvm-setting-viewer). Each of these interfaces will be presented one at a time for every step of HRnV and HRV analysis. 

We use the demo ECG input [Demo_NSR16786.txt](./Demo_Data/Demo_NSR16786.txt) to illustrate functionalities of HRnV-Calc. The demo input is a 10 min ECG recording (sampling rate: 128Hz) randomly sampled from patient #16786 in the [MIT-BIH Normal Sinus Rhythm Database](https://physionet.org/content/nsrdb/1.0.0/).
### Data Loader
The initial GUI of HRnV-Calc is Data Loader, which provides basic settings for users to begin HRV/HRnV analysis. Users may choose to perform analysis on a single file or multiple files as batch processing. It is noteworthy that the current version of HRnV-Calc supports **only batch processing on RRI (IBI) inputs**, which do not require manual QRS inspection to complete the HRV/HRnV analysis. 

<p align="center">
  <img src="./figs/Data_loader.png" />
</p>
<p align="center">
  Data Loader
</p>

#### Data Type and Formats
Currently, HRnV-Calc accepts five different data types, which include:

- Raw ECG (*.txt, *.csv)
- IBI (*.txt, *.csv)
- ECG PC -- ECG signal with peak positions (*.csv) saved by HRnV-Calc. 

#### Single/Batch Processing
**Single File** lets users conduct HRV/HRnV analysis on one single input file at a time. This option supports [all data types](#data-type-and-formats). Once the data type is configured, users may click on the `Open File/Folder` button to navigate and locate the input file. Note that HRnV-Calc will only display files in supported formats for the specified data type.


**Batch Files** allows users to conduct HRV/HRnV analyses on **multiple RRI input files** simultaneously. To conduct batch processing, all input RRI files have to be in the **same format** (either *.txt or *.mat) and saved under **the same directory**. Users may use `Open File/Folder` button to navigate and locate the input directory, and HRnV-Calc will automatically analyze all supported files in the directory. HRnV-Calc includes three demo [RRI input files](./Demo_Data/Demo_RRI/) from the [Normal Sinus Rhythm RR Interval Database](https://physionet.org/content/nsr2db/1.0.0/) for users to try batch processing.


#### Fetal ECG Processing Profile
Since fetal ECG signals have distinct features to the ones from adults, HRnV-Calc has two processing profiles for users to choose from for downstream analysis. For more details about the profiles, please refer to the [PCST paper](https://iopscience.iop.org/article/10.1088/1361-6579/aae021). Note this processing profile is only valid for **ECG inputs**.

#### Sampling Rate
For ECG inputs, users need to specify the sampling rate of the signal. There are two predetermined sampling rates to choose: `125Hz` or `250Hz`. If the signal is sampled using other rates, users may choose the `Others` option and type in the sampling rate. 

For RRI inputs, this section will not be avaible, as the sampling rate does not affect the analysis on RRI. HRnV-Calc will assign one of the default rates to the input. 


#### Patient ID Extraction
By default, HRnV-Calc will use the full file name (e.g., Demo_NSR16786.txt) of the input as patient ID to store and display analysis results. Users may customize the ID extraction by specifying the prefix and postfix of the input file. For example, as shown in the figure above and all subsequent figures, patient ID 'NSR16786' can be extracted from the file name by specifying the prefix to be 'Demo_' and postfix to be '.txt'. 

#### Cofirmation Window
Once the input files and all settings in the Data Loader are properly configured, users may click on `Next` to proceed to the next step. A confirmation window will be displayed to let users double check on the settings made in the Data Loader. If it is necessary to change any setting, clicking `Back` will bring up the Data Loader agian. The `Confirm` button will bring up the [QRS Detection and Edits (QDE) Viewer](#qrs-detection-and-edits-qde-viewer) for ECG inputs or [HR<sub>n</sub>V<sub>m</sub>  Setting Viewer ](#hrnvm-setting-viewer) for RRI inputs. 

<p align="center">
  <img src="./figs/Confirmation.png" />
</p>
<p align="center">
  Setting Confirmation
</p>


### QRS Detection and Edits (QDE) Viewer
The QDE viewer is designed to configure and inspect QRS detection on **ECG signals**. All settings and tools for QRS detection and inspection can be found in the setting section at the top. 

<p align="center">
  <img src="./figs/QDE_full.png" />
</p>
<p align="center">
  QDE Viewer
</p>


#### Segmentation of ECG
The `Signal Type` section allows users to choose whether the full ECG or a segment of it should be analyzed. 

If the `Segment` option is selected, the `Display settings & ECG Segment Selection` section will be availabe to users to navigate and select the desired segment. 

There are three choices of segment length can be selected in the segmentation subsection: `5 min`, `10 min`, and `15 min`. Users may change `Display Duration` and `Display overlay` to better navigate and locate the desired part of the ECG signal for segmentation.

As shown in the figure below, to select the starting point of the segment, click the `Select start point` button, and then choose the starting point by clicking on the ECG plot displayed in the middle of the QDE viewer. Single clicks will be plotted on the ECG plot as crossing marks for reference. To avoid unintended inputs, such clicks are not stored as the actual starting points. Users may **finalize the choice of the starting point by double clicking** on the desired point in the ECG plot. Alternatively, right clicking will also finalize the starting point as the last single click position.  It is worth noting that only the horizontal position (i.e., the X-axis coordinate) of the click will be used to locate the starting point of the segment. Once the starting point is finalized, the **end point of the segment with specified length will be automatically displayed** on the ECG plot as a green dot. Users may finalize the choice of the end point by clicking the `Confirm End Point` button and thus confirm the segmentation of the ECG signal.


<p align="center">
  <img src="./figs/QDE_seg_select.png" />
</p>
<p align="center">
  Segmentation of ECG
</p>


#### Noise Removal and Local Checkup

Baseline drifts in the ECG signal can be removed by checking the `Baseline Drfit Removal` option. 

Although the *jqrs* algorithm used in HRnV-Calc is one of the most robust and well-regarded QRS detection methods, it may sometimes yield unexpected annotation results, especially when taking ECG inputs with downwards R peaks (i.e., R peak being the local minimum of the signal). Therefore, HRnV-Calc performs **an additional check on the *jqrs* output to modify the annotation to the local maximum** within a small region (10 samples before and after the original *jqrs* peak annotation, regardless of the sampling rate). If the input has downwards R peaks, the **`Downwards QRS Peak` option in the QDE viewer enables HRnV-Calc to modify the annotation to the local minimum**. If such a modification is deemed unnecessary, users may **uncheck the `Modify to local supremum` option to skip the additional check**. 

#### Peak Detection and Editing
The `QRS Peak Detection` button lets users perform QRS detection on the selected ECG segment. The peak annotations will be plotted in the `Denoised ECG Plot` as red dots. 

Manual correction of R peaks can be done in the `Denoised ECG Plot`. users may first remove the incorrect R peaks by clicking on the `Remove Peak` button and then **double click on the marked peak annotations to remove them**. Removal of the R peaks can be **stopped by a single right click**. Since HRnV-Calc performs checks to verify if there are two R peaks too close to each other, it is advised to always **remove the undesired R peaks before adding new ones**. All R peaks editing can be reversed by performing the QRS detection again.

To add a new peak annotation to the ECG signal, click on the `Add Peak` button and **double click on the point where the new annotation will be added**. HRnV-Calc will **automatically mark the local maximum** (or minimum if `Downwards QRS Peak` is selected) within a small region surrounding the selected point as the new R peak, since manual positioning of the exact R peak can be erroneous. Please note that clicking on the `Add Peak` button will only allow users to add one peak to the signal at a time. 

#### Saving Peak Annotation and Proceed
Mannual edits of the peak annotations can be saved by clicking `New QRS Manual Edit` button. Once the QRS detection is finalized, users may proceed to [HR<sub>n</sub>V<sub>m</sub>  Setting](#hrnvm-setting-viewer) viewer for downstream analysis by clicking on `HRnVm Calculation`. 

### HR<sub>n</sub>V<sub>m</sub> Setting Viewer
Before using HR<sub>n</sub>V<sub>m</sub> analysis, we recommend reading [the explaination of the HRnV method](#the-hrnv-method). 

HR<sub>n</sub>V<sub>m</sub>  analyses are configured in the HR<sub>n</sub>V<sub>m</sub>  Setting viewer. In the 'HR<sub>n</sub>V<sub>m</sub> ' section, users may choose to perform a single HR<sub>n</sub>V<sub>m</sub>  analysis by choosing the option **`Single`** and specifying the desired `n` and `m` values. When choosing the option `HRnV (m = n)`, HRnV-Calc will perform HR<sub>n</sub>V (or HR<sub>n</sub>V<sub>n</sub>) analysis on the input depending on the specified `n`. By default, HRnV-Calc will perform the conventional HRV analysis with `n = 1` and `m = 1`. 

<p align="center">
  <img src="./figs/HRnVm_setting.png" />
</p>
<p align="center">
  HR<sub>n</sub>V<sub>m</sub> Setting
</p>


The option **`All`** lets users perform all HR<sub>n</sub>V<sub>m</sub> analyses with `n` and `m` no greater than the specified `n`. For example, if `n` is set to be 2, HRnV-Calc will conduct HR<sub>1</sub>V (i.e., conventional HRV), HR<sub>2</sub>V<sub>1</sub>, and HR<sub>2</sub>V analyses on the input signal altogether. The default value of *n* for this option is 1, indicating only the conventional HRV analysis to be performed. Note that the results generated using this option will not be shown in the HR<sub>n</sub>V<sub>m</sub> Display, even when *n* is set to be 1. Users may check the stored Excel sheets for detailed results. 

The **`Ectopic Beats`** section allows users to specify the threshold (default: `20%`) for a beat to be considered as an outlier and to select how outliers should be processed (default: remove). It should be noted that the detection and processing of ectopic beats will **only be conducted on the original RRI**. All RR<sub>n</sub>I<sub>m</sub> intervals will be generated from the processed RRI intervals without further processing. 

In the **`Frequency Domain`** section, user may choose one of the four PSD methods (default: `Lomb`) provided in PCST. For details of each PSD estimate method, please refer to the [PCST paper](https://iopscience.iop.org/article/10.1088/1361-6579/aae021).

The **`Use Kubios Preset`** option lets users modify the settings of some nonlinear methods used in HRnV-Calc according to the [published documentations of Kubios HRV](https://doi.org/10.1016/j.cmpb.2013.07.024). Note that the preset will not yield identiacal results to the ones generated by Kubios HRV, as the exact processing methods used in Kubios HRV are proprietary. 

### HR<sub>n</sub>V<sub>m</sub> Results Display
HRnV-Calc will display results of a single HR<sub>n</sub>V<sub>m</sub> analysis (e.g., HR<sub>2</sub>V<sub>1</sub>) in the HR<sub>n</sub>V<sub>m</sub> Results Display window. Note the display window will **not** be activated if users choose to perform multiple HR<sub>n</sub>V<sub>m</sub> analyses (by choosing option `All` in [HR<sub>n</sub>V<sub>m</sub> Setting Viewer](#hrnvm-setting-viewer)) or to conduct [batch processing on multiple input files](#singlebatch-processing). 

<p align="center">
  <img src="./figs/Results.png" />
</p>
<p align="center">
  HR<sub>n</sub>V<sub>m</sub> Results Display
</p>

As shown in figure above, the HR<sub>n</sub>V<sub>m</sub> Results Display viewer provides a comprehensive overview of the HR<sub>n</sub>V<sub>m</sub>  analysis. If the conventional HRV (or HR<sub>1</sub>V) analysis is performed, the `IBI Statistics` section provides an overview of the abnormal beats presented in the original RRI and the percentage of clean beats in the entire input. For HR<sub>n</sub>V<sub>m</sub>  analyses other than conventional HRV (e.g., HR<sub>2</sub>V<sub>1</sub>), the `IBI Statistics` section will only display the number of beats in the corresponding RR<sub>n</sub>I<sub>m</sub>  intervals, as preprocessing is only performed on the original RRI before converting to RR<sub>n</sub>I<sub>m</sub>  intervals.



