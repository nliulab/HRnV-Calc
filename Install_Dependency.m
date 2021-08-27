%% This is a installation script of PhysioNet Cardiovascular Signal Toolbox.
%% To use HRnV-Calc, the above toolbox is required. 
%% To cite HRnV-Calc, please also cite the toolbox.
%% Add citation below--
%%Vest A, Da Poian G, Li Q, Liu C, Nemati S, Shah A, Clifford GD, 
%%"An Open Source Benchmarked Toolbox for Cardiovascular Waveform and Interval Analysis" 
%%Physiological Measurement (In Press) DOI:10.5281/zenodo.1243111; 2018.

% Image Processing Toolbox is needed for ECG segment selection

% By default, this script will install the toolbox under the HRnV-Calc directory
HRnV_path = fileparts(which('HRnVm_Calculation.m'));
cd(HRnV_path)
if exist('PhysioNet-Cardiovascular-Signal-Toolbox', 'dir') == 7 
    disp('PhysioNet Toolbox Directory Already Exists');
    disp('To Reinstall, Remove the Directory');
    return
end
pcst_url = 'https://physionet.org/files/pcst/1.0.0/PhysioNet-Cardiovascular-Signal-Toolbox.zip?download';
disp('Downloading PhysioNet Toolbox-----------');
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
%savepath %Use this to save the path permanently
if exist('PhysioNet-Cardiovascular-Signal-Toolbox.zip', 'file') == 2
  delete('PhysioNet-Cardiovascular-Signal-Toolbox.zip');
end
clear fieldest HRnV_path pcst_url savefilename
disp('Installation Finished');