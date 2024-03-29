%% Installation script of PhysioNet Cardiovascular Signal Toolbox (PCST)
%   To use HRnV-Calc, PCST is required. 
%   To cite HRnV-Calc, please also cite PCST:
%   Vest, A. N., Da Poian, G., Li, Q., Liu, C., Nemati, S., Shah, A. J., & Clifford, G. D. (2018). 
%   An open source benchmarked toolbox for cardiovascular waveform and interval analysis. 
%   Physiological measurement, 39(10), 105004. https://doi.org/10.1088/1361-6579/aae021
%
%   DEPENDENCIES & LIBRARIES:
%       PhysioNet Cardiovascular Signal Toolbox
%       https://physionet.org/content/pcst/1.0.0/
%       https://github.com/cliffordlab/PhysioNet-Cardiovascular-Signal-Toolbox
%       
%
%   REFERENCE: 
%   Chenglin Niu, Dagang Guo et al. HRnV-Calc: A software for heart rate n-variability
%   and heart rate variability analysis
%
%   Written by: Dagang Guo(guo.dagang@duke-nus.edu.sg), Chenglin Niu
%   (chenglin.niu@u.duke.nus.edu), Nan Liu(chenglin.niu@u.duke.nus.edu)
%
%	REPO:       
%       https://github.com/nliulab/HRnV-Calc
%   ORIGINAL SOURCE AND AUTHORS:     
%       Written by: 
%       Dagang Guo(guo.dagang@duke-nus.edu.sg), 
%       Chenglin Niu (chenglin.niu@u.duke.nus.edu),
%       Nan Liu (liu.nan@duke-nus.edu.sg) in 2021
%   
%	COPYRIGHT (C) 2022 
%
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information

% Image Processing Toolbox is needed for ECG segment selection

% By default, this script will install the toolbox under the HRnV-Calc directory
HRnV_path = fileparts(which('HRnV_Calc.m'));
cd(HRnV_path)
if exist('PhysioNet-Cardiovascular-Signal-Toolbox-master', 'dir') == 7 || exist('PhysioNet-Cardiovascular-Signal-Toolbox', 'dir') == 7
    disp('PhysioNet Toolbox Directory Already Exists');
    disp('To Reinstall, Remove the Directory');
    return
end
pcst_url = 'https://physionet.org/files/pcst/1.0.0/PhysioNet-Cardiovascular-Signal-Toolbox.zip?download';
disp('Downloading PhysioNet Toolbox-----------');
disp('This may take a while')
savefilename = 'PhysioNet-Cardiovascular-Signal-Toolbox.zip';
try 
    fieldest = websave(savefilename, pcst_url);
    disp('Download Finished');
catch
    disp('Download Failed, Please Download PhysioNet Cardiovascular Signal Toolbox Mannully');
    return
end
disp('Installing------------------------------');
unzip('PhysioNet-Cardiovascular-Signal-Toolbox.zip');
addpath(genpath(HRnV_path));
%savepath %%Use this to save the path permanently
if exist('PhysioNet-Cardiovascular-Signal-Toolbox.zip', 'file') == 2
  delete('PhysioNet-Cardiovascular-Signal-Toolbox.zip');
end
clear fieldest HRnV_path pcst_url savefilename
clc;
disp('Installation Finished');
disp('Welcome!')
HRnV_Calc;