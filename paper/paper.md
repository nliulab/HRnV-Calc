---
title: 'HRnV-Calc: A Software for Heart Rate n-Variability and Heart Rate Variability Analysis'
tags:
  - MATLAB
  - GUI
  - HRnV
  - HRV
  
authors:
  - name: Chenglin Niu
    orcid: 0000-0001-6677-7910
    equal-contrib: true
    affiliation: 1
  - name: Dagang Guo
    equal-contrib: true 
    affiliation: 1
  - name: Marcus Eng Hock Ong
    affiliation: "1,2"
  - name: Zhi Xiong Koh
    affiliation: "1,2"
  - name: Guerry Alexiane Laure Marie-Alix
    affiliation: 3
  - name: Andrew Fu Wah Ho
    affiliation: "1,2"
  - name: Zhiping Lin
    affiliation: 4
  - name: Chengyu Liu
    affiliation: 5
  - name: Gari D. Clifford
    affiliation: "6,7"
  - name: Nan Liu
    corresponding: true 
    affiliation: "1,8,9"

affiliations:
 - name: Duke-NUS Medical School, National University of Singapore, Singapore, Singapore
   index: 1
 - name: Department of Emergency Medicine, Singapore General Hospital, Singapore, Singapore
   index: 2
 - name: École Polytechnique Fédérale de Lausanne (EPFL), Lausanne, Switzerland
   index: 3
 - name: School of Electrical and Electronic Engineering, Nanyang Technological University, Singapore 
   index: 4
 - name: School of Instrument Science and Engineering, Southeast University, Nanjing, China 
   index: 5
 - name: Department of Biomedical Informatics, Emory University, Atlanta, GA, United States of America
   index: 6
 - name: Department of Biomedical Engineering, Georgia Institute of Technology, Atlanta, GA, United States of America
   index: 7
 - name: SingHealth AI Health Program, Singapore Health Services, Singapore, Singapore 
   index: 8
 - name: SInstitute of Data Science, National University of Singapore, Singapore, Singapore
   index: 9

date: 23 November 2022
bibliography: paper.bib
---

# Summary

Variation of the time interval between a consistent point in time of each heartbeat (generally related to ventricular electrical activation), known as heart rate variability (HRV) [@RN28], has been proven by numerous studies to be a useful indicator of physiological status [@RN69; @RN28]. Thanks to its non-invasive nature and strong connection to the autonomic nervous system (ANS) [1, 2], HRV has been adopted to study a wide range of diseases and clinical conditions, which include myocardial infarction [3], sudden cardiac death [4], diabetes [5], renal failure [6], sepsis [7], seizure [8], and cancer [9]. In addition, the emergence of wearable devices with heart monitoring capabilities has also allowed researchers to study the above-mentioned medical conditions in real-world settings [10], as well as in non-clinical applications such as sports [11], stress [12], and sleep monitoring [13]. 

A variety of HRV metrics can be derived from the heartbeat time sequence known as the inter-beat interval (IBI), or the R-to-R peak interval (RR interval or RRI). Such sequences are often extracted from biomedical signals such as electrocardiograms (ECG) and photoplethysmograms (PPG). It is believed that a decrease of complexity in HRV is associated with an increase in both morbidity and mortality [1, 2]. To qualify and quantify the complexity, various conventional HRV metrics in linear and non-linear domains [14] have been established to reflect the dynamic of HRV [1, 15]. However, the exact mechanism regulating HRV is not perfectly clear in every detail[1, 2]. Some of recent developments in HRV have been mainly focused on non-linear metrics such as variants of approximate entropy (ApEn) and sample entropy (SampEn) [16-19]. 

Despite progress in HRV metrics research, the representation of RRI upon which HRV is based has rarely been examined. Cysarz et al. [20] proposed a binary symbolization of RRI, which combined with ApEn provides new information about the normal heart period regularity. The multiscale entropy (MSE) metrics [21] calculate SampEn on multiscale coarse-gained series derived from RRI to reflect the nonlinear behavior of the heart on multiple time scales. To generalize the averaging multiscale approach, Liu et al. [22] proposed heart rate n-variability (HRnV) that utilizes sliding and stridden summation windows over RRI to obtain new RRI-like intervals denoted RR_n I and RR_n I_m. Using these novel RRI representations, new HRnV metrics can be calculated with conventional HRV analysis metrics, providing an entire family of new metrics, and potentially additional insights into the dynamics and long-term dependencies of the original RRI, making HRnV complementary to the conventional HRV analysis. Research has shown that HRnV improves the accuracy of triage for patients with chest pain [22] and sepsis [23]. However, full potentials and physiological meaning of HRnV require broader collaboration between researchers and clinicians in various settings and applications. As such, an open and standard software package for HRnV is essential to facilitate further research on HRnV and its possible variations.   

There is an abundance of HRV software tools for commercial and non-commercial use, including Kubios HRV [24], ECGlab [25], ARTiiFACT [26], RHRV [27], and RR-APET [28]. However, none of these tools is suitable for incorporating HRnV analysis. Moreover, with the exception of two open-source toolboxes, none of the available tools provide equivalent results, making comparisons between research impossible [29]. Since HRnV shares some common processing methods with conventional HRV analysis [22], it is natural to develop a HRnV package based on existing benchmarked software. We therefore developed an open-source HRnV software, HRnV-Calc, based on the PhysioNet Cardiovascular Signal Toolbox (PCST) [29]. Compared to other HRV freeware, the PCST is standardized and well-documented. More importantly, the PCST is an open-source HRV software suite which has gone through rigorous testing and benchmarking in both technical and clinical settings. Based on the fully functional HRV command-line code provided by the PCST, HRnV-Calc has integrated graphical user interfaces (GUIs) that enable manual inspection and correction of RRI extraction from ECG signals, flexible configuration, and batch-processing, in a step-by-step manner. Its inherent functions support the analysis of both HRnV and conventional HRV metrics with enhanced usability. Therefore, HRnV-Calc not only facilitates new methodological developments, but also provide clinicians and researchers with transparent and easily accessible HRnV and HRV analyses.

HRnV-Calc has been used in several studies in the Singapore General Hospital and the KK Women's and Children's Hospital for triage of patient presented at the emergency department with symptoms potentially linked to sepsis and heart attack. 


# Basic Usage
This section provides a non-exhaustive walkthrough of the features and functionalities offered by HRnV-Calc. 

The HRnV method [22] for alternative RRI representation is a unique and the main feature implemented in HRnV-Calc. HRnV utilizes sliding and stridden summation windows on the original RRI, resulting in new $RR_{n}I$ and $RR_{n}I_{m}$  intervals ($n$ and $m$ are parameters for HRnV), which can then be fed into conventional HRV analysis to calculate corresponding $HR_{n}V$and $HR_{n}V_{m}$  metrics. For clarification, the term ‘HRnV’ refers to the name of the method (i.e., heart rate n-variability), while $HR_{n}V$ and $HR_{n}V_{m}$ refer to the analysis and derived metrics based on $RR_{n}I$ and $RR_{n}I_{m}$ intervals, respectively.

HRnV-Calc is primarily operated using its step-by-step GUIs, which include four main interfaces: (1) Data Loader, (2) QRS Detection & Edits (QDE) viewer, (3) $HR_{n}V_{m}$ 
Setting viewer, and (4) $HR_{n}V_{m}$ Results Display. A typical workflow using HRnV-Calc is illustrated in \autoref{fig:workflow}.
![Typical workflow of HRnV-Calc \label{fig:workflow}](HRnV-Calc_workflow.png)

The initial GUI of HRnV-Calc is Data Loader (\autoref{fig:dataloader}), which provides basic settings for users to begin HRV/HRnV analysis, such as the data type of the input and the sampling rate of the signal. Users may choose to perform analysis on a single file or multiple files as batch-processing. Currently, HRnV-Calc supports ECG and RRI inputs in the format of text and CSV. 
![Data Loader \label{fig:dataloader}](../figs/Data_loader.png)

Since the QRS peak detection of ECG is crucial for subsequent HRnV and HRV analysis, especially in clinical settings, the QDE viewer (\autoref{fig:QDE}) is designed to configure and inspect QRS detection on ECG inputs interactively. All settings and tools for QRS detection and inspection can be found in the setting section at the top. Manual adjustments of QRS peaks annotation can be made after the initial automatic QRS detection provided by *jqrs* [30, 31].

![QDE Viewer \label{fig:QDE}](../figs/QDE_full.png)

The $HR_{n}V_{m}$ Setting viewer (\autoref{fig:hrnvmsettings}) is used to configure HRnV and HRV analyses. Users may specify the $n$ and $m$ parameters for HRnV analysis in the ‘$HR_{n}V_{m}$’ section. The ‘Ectopic Beats’ section allows users to specify the threshold for a beat to be considered as an outlier and to select how outliers should be processed. It should be noted that the detection and processing of ectopic beats will only be conducted on the original RRI. In the ‘Frequency Domain’ section, users may choose one of the four power spectral density (PSD) estimation methods provided in the PCST [29]. The ‘Use Kubios Preset’ option allows users to modify the settings of some nonlinear methods used in HRnV-Calc according to the published documentations of Kubios HRV [24]. Finally, the ‘Additional Metrics’ option allows users to calculate additional metrics for HRV or HRnV analyses. These metrics include median absolute deviation (MAD), Katz’s fractal dimension (KFD), Higuchi Fractal Dimension (HFD) [32],  Huey’s index (HUEY), de Haan’s index (HANN), and Zugaib’s variability index (ZUG) [33]. 

![$HR_{n}V_{m}$ Parameters Setting \label{fig:hrnvmsettings}](../figs/HRnVm_setting.png)

Once the HRnV or HRV analysis is configured, HRnV-Calc will automatically save all analysis results under the user-specified directory in the excel spread sheet format. In addition, HRnV-Calc will also display the results of a single $HR_{n}V_{m}$ analysis (e.g., $HR_{3}V_{2}$) in the $HR_{n}V_{m}$ Results Display window. As shown in \autoref{fig:results}, the $HR_{n}V_{m}$ Results Display viewer provides a comprehensive overview of the $HR_{n}V_{m}$  analysis. If the conventional HRV analysis is performed, the ‘IBI Statistics’ section provides an overview of the abnormal beats presented in the original RRI and the percentage of clean beats in the entire input. For $HR_{n}V_{m}$  analyses other than conventional HRV, the ‘IBI Statistics’ section will only display the number of beats in the corresponding $RR_{n}I_{m}$  intervals, as preprocessing is only performed on the original RRI before converting to $RR_{n}I_{m}$  intervals.

![$HR_{n}V_{m}$ Parameters Setting \label{fig:results}](../figs/Results.png)

# References