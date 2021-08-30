# HRnV-Calc: Software for Heart Rate n-Variability Analysis



 - **HRnV-Calc Introduction**
      - [Description](#description)
      - [Installation](#installation)
      - [Citation](#citation)
      - [Contact](#contact)



## Description
The HRnV-Calc software is a heart rate variability (HRV) analysis software with the novel [HRnV method](https://bmccardiovascdisord.biomedcentral.com/articles/10.1186/s12872-020-01455-8) built in. The software is built upon the core HRV analysis code provided by [PhysioNet Cardiovascular Signal Toolbox (PCST)](https://physionet.org/content/pcst/1.0.0/). In addition to the fully automated command-line HRV analysis process provided by PCST, HRnV-Calc offers the HRnV metrics to augment insights discovered by HRV as well as intuitive graphical user interfaces (GUIs) for every major step of HRV and HRnV analysis. 

## Installation
The HRnV-Calc software is available freely on GitHub under the [GNU (V3 or later)](https://www.gnu.org/licenses/gpl-3.0.en.html) license. 

To begin, please download and install [Matlab](https://www.mathworks.com/) (2017b or higher) (required Matlab Toolboxes: Signal Processing Toolbox, Statistics and Machine Learning Toolbox, Neural Network Toolbox, and Image Processing Toolbox)

Before using the GUIs and HRnV analysis provided by HRnV-Calc, users need to install PCST for the core signal analysis and HRV toolkits that HRnV-Calc depends on. Users may use the installation script – [‘Install_Dependency.m’](Install_Dependency.m) included in HRnV-Calc to automatically download and install PCST. 

Alternatively, PCST can be manually downloaded from [PhysioNet](https://physionet.org/content/pcst/1.0.0/PhysioNet-Cardiovascular-Signal-Toolbox.zip) and added to the directory containing HRnV-Calc code as a subdirectory. Do note that the name of the folder containing PCST should not be changed, as HRnV-Calc will check the existence of the original PCST folder before the software starts. 

## Citation
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
## Contact
- Dagang Guo (Email: <guo.dagang@duke-nus.edu.sg>)
- Chenglin Niu (Email: <chenglin.niu@u.duke.nus.edu>)
- Nan Liu (Email: <liu.nan@duke-nus.edu.sg>)

<!--<figure class="image" align="center">
  <img src="../HRnV-Calc/figs/Data_loader.png" >
  <figcaption>Data Loader</figcaption>
</figure>-->


<!--![Data Loader](../HRnV-Calc/figs/Data_loader.png)-->

<!--<p align="center">
    <img src="../HRnV-Calc/figs/Data_loader.png" alt>
</p>
<p align="center">
    <cap>Data Loader</cap>
</p>-->