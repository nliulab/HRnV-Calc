function varargout = HRnVm_Settings(varargin)
% HRNVM_SETTINGS MATLAB code for HRnVm_Settings.fig
%      HRNVM_SETTINGS, by itself, creates a new HRNVM_SETTINGS or raises the existing
%      singleton*.
%
%      H = HRNVM_SETTINGS returns the handle to a new HRNVM_SETTINGS or the handle to
%      the existing singleton*.
%
%      HRNVM_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HRNVM_SETTINGS.M with the given input arguments.
%
%      HRNVM_SETTINGS('Property','Value',...) creates a new HRNVM_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HRnVm_Settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HRnVm_Settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HRnVm_Settings

% Last Modified by GUIDE v2.5 23-Jan-2021 16:32:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HRnVm_Settings_OpeningFcn, ...
                   'gui_OutputFcn',  @HRnVm_Settings_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before HRnVm_Settings is made visible.
function HRnVm_Settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HRnVm_Settings (see VARARGIN)


%%Get Info from HRnVmCal
% get the handle of HRnVmCal
hhrnvmcal = findobj('Tag','HRnVmCal');
% if exists (not empty)
if ~isempty(hhrnvmcal)
    dhhrnvmcal = guidata(hhrnvmcal);
    handles.filetype = dhhrnvmcal.filetype;
    handles.datatype = dhhrnvmcal.datatype;
    handles.fs = dhhrnvmcal.fs;
    handles.postfix = dhhrnvmcal.postfix;
    handles.prefix = dhhrnvmcal.prefix;
    handles.HRVParams = dhhrnvmcal.HRVParams;
    
    if handles.filetype == 1 %Single File
        set(handles.btsingle,'Enable','on');
        handles.patientID = dhhrnvmcal.patientID;
        if (handles.datatype == 2) || (handles.datatype == 4) %%Single IBI
            handles.ibidata = dhhrnvmcal.data;
        end
    else %Batch Files
        set(handles.btbatch,'Enable','on');
        handles.foldername = dhhrnvmcal.foldername;
    end
    
    %%Close HRnVmCal window once parameters transferred
    close(hhrnvmcal);
end

%%Get Info from Preprocess
% get the handle of HRnVmCal
hhrnvpreprocess = findobj('Tag','HRnVmPreprocess');
% if exists (not empty)
if ~isempty(hhrnvpreprocess)
    dhrnvpreprocess = guidata(hhrnvpreprocess);

    %%Set correct windowlength as total short-term signal as one
    %%segment ????
    handles.HRVParams = dhrnvpreprocess.HRVParams;
    handles.filetype = dhrnvpreprocess.filetype; 
    handles.fs = dhrnvpreprocess.settings.fs;
    handles.datatype = dhrnvpreprocess.settings.datatype;

    set(handles.btsingle,'Enable','on');
    handles.patientID = dhrnvpreprocess.patientID;
    handles.ibidata = dhrnvpreprocess.ibi;
    
    %%Close Preprocess window once parameters transferred
    close(hhrnvpreprocess);
end

% Choose default command line output for HRnVm_Settings
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HRnVm_Settings wait for user response (see UIRESUME)
% uiwait(handles.HRnVmSettings);



% --- Outputs from this function are returned to the command line.
function varargout = HRnVm_Settings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btsingle.
function btsingle_Callback(hObject, eventdata, handles)
% hObject    handle to btsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rbsingle,'Value') == 1
    handles.hrnv = str2double(get(handles.ednsingle,'String'));
    handles.hrnvm = str2double(get(handles.edmsingle,'String'));
else
    handles.hrnv = str2double(get(handles.ednall,'String'));
    handles.hrnvm = handles.hrnv; %%Set hrnvm = hrnv to indicate all HRnVm based on hrnv value 
end

handles.ecothreshold = str2double(get(handles.edecothre,'String'));

%%Initialization of some basic HRV params using Physionet-Tool-Box function

handles.HRVParams = ChangeSettings(handles,handles.HRVParams,handles.ecothreshold);

%%ecotopic beats Removal and change HRVparameters windowlength here 
[cleanibi,ectopicBeats] = ibitimegeneration(handles.ibidata,handles.HRVParams);
%%Save the percentage of removed ecotopic beat 
handles.ectopicBeats = ectopicBeats;
handles.HRVParams.windowlength = cleanibi(size(cleanibi,1),1) + 1;%%Extra 1 second to smooth Physionet-toolbox calculation

percentClean = round(10000*(length(cleanibi(:,2))/((length(cleanibi(:,2))+ectopicBeats))))/100;

if percentClean < 80
    fprintf('Too noisy record %s of \n',handles.patientID+' has only '+num2str(percentClean)+'% non-ectopic beats!');
end

%Save to handles
handles.percentClean = percentClean;

if get(handles.rbsingle,'Value') == 1 %Single HRnVm
    %%Set default file name
    defname = constructdeffilename(handles.filetype,1,handles.patientID,handles.hrnv,handles.hrnvm);
    %%File Saving 
    [outputFileName,outputPathName] = uiputfile('*.xls',cat(2,'Save results to:'),defname);
    fullFileName = fullfile(outputPathName, outputFileName);
    
    header = constructheader(handles.hrnv,handles.hrnvm);
    header = cat(2,'patient_id',header);%%Add patient_id as first column
    xlswrite(fullFileName,header,1);
    
    hrnvmoverlap = handles.hrnv - handles.hrnvm;
    if handles.hrnv == 1
        hrnvmibi = cleanibi;
    else
        hrnvmibi = hrnvoverlap (cleanibi,handles.hrnv,hrnvmoverlap);
    end
    [HRnVOutput,hrnvmoutput] = hrnvmcalculation(hrnvmibi,handles.HRVParams,handles.hrnv);
    hrnvmoutput = cat(2,handles.patientID,hrnvmoutput);
    xlsappend(convertStringsToChars(fullFileName),hrnvmoutput); 
    
    %%Save HRnVm name and result for display in HRnVm_Result
    if handles.hrnv == 1 %%HRV
       handles.hrnvmname = 'HRV'; 
    else
        if handles.hrnvm == 0
            handles.hrnvmname = cat(2,'HR',num2str(handles.hrnv),'V');
        else
            handles.hrnvmname = cat(2,'HR',num2str(handles.hrnv),'V',num2str(handles.hrnvm));
        end
    end
    %%Save processibi
    handles.prohrnvmibi = hrnvmibi;

    %%Save HRnVm output structure for single file and single HRnVm calculation
    %%for display in result
    handles.hrnvmoutput = HRnVOutput;

    % Update handles structure if necessary
    guidata(hObject, handles);
    
    HRnVm_Result;
    
else %%HRnV,e.g.,HR3V include HRV, HR2v, HR2v1, HR3v,HR3v1,HR3v2 
    %%Set default file name
    defname = constructdeffilename(handles.filetype,2,handles.patientID,handles.hrnv,handles.hrnvm);
    %%File Saving 
    [outputFileName,outputPathName] = uiputfile('*.xls',cat(2,'Save results to:'),defname);
    fullSingleAllName = fullfile(outputPathName, outputFileName);
    
    %Construct HRV header first (hrnv = 1)
    header = constructheader(1,0);
    header = cat(2,'patient_id',header); %%Add patient_id as first column
    
    %Calculate HRV first
    [HRnVOutput,hrnvmoutput] = hrnvmcalculation(cleanibi,handles.HRVParams,1);
    hrnvmoutput = cat(2,handles.patientID,hrnvmoutput); %%Add patientID value
    if handles.hrnv>=2
        for n=2:handles.hrnv
            for m = 0:n-1
                if m == 0
                    hrvoverlap = 0;
                else
                    hrvoverlap = n - m;
                end
                
                %Calculate HRnVm ibi
                hrnvmibi = hrnvoverlap (cleanibi,n,hrvoverlap);
                
                %Construct header for HRnVm and append
                subheader = constructheader(n,m);
                header = cat(2,header,subheader);
                
                %Calculate HRnVm param and append
                [HRnVOutput,subhrnvmoutput] = hrnvmcalculation(hrnvmibi,handles.HRVParams,n);
                hrnvmoutput = cat(2,hrnvmoutput,subhrnvmoutput);
            end
        end
    end
    xlswrite(fullSingleAllName,header,1);
    xlsappend(convertStringsToChars(fullSingleAllName),hrnvmoutput);
end

%%%To process new IBI based on HRnVm concept
 function processedibi = hrnvoverlap (ibi,hrnv,hrvoverlap)
    processedibilen = floor((length(ibi(:,2))-hrnv+1)/(hrnv-hrvoverlap));
    %Calculate first processed ibi, further will have overlap
    processedibi = zeros(processedibilen,2);
    for j = 1:hrnv
        processedibi(1,2) = processedibi(1,2)+ibi(j,2);
    end
    processedibi(1,1) = ibi(1,1); 
    
    for i=2:processedibilen
        for j = 1:hrnv
            processedibi(i,2) = processedibi(i,2)+ibi(i+hrnv+j-hrvoverlap-2,2);
        end
        processedibi(i,1) = ibi((i-1)*(hrnv-hrvoverlap)+1,1);
    end
    
%%%HRnVm calculation 
function [HRnVOutput,hrnvmoutput] = hrnvmcalculation(hrnvibi,HRVparams,hrnv)

%%Leave sqi empty, after manual QRS edit, all IBIs are considered as good
%%quality 1 
sqi = [];
winidx = 0; % For short-term ECG, only one segment start from time 0
%%Use Physionet-tool to calculate HRV parameters in time domain, frequency domain, non-linear domain 
HRnVOutput = Main_HRnVm_Analysis(hrnvibi(:,2)',hrnvibi(:,1)',sqi,HRVparams,winidx,hrnv);
if hrnv == 1 %%HRV,HRV does not have nn50x and pnn50x
    hrnvmoutput = {HRnVOutput.td.NNmean,HRnVOutput.td.SDNN, HRnVOutput.td.HRmean, ...
    HRnVOutput.td.SDHR, HRnVOutput.td.RMSSD, HRnVOutput.td.nn50,HRnVOutput.td.pnn50,...
    HRnVOutput.td.NNskew, HRnVOutput.td.NNkurt, HRnVOutput.td.HRVTi,...
    HRnVOutput.fd.peakvlf,HRnVOutput.fd.vlf,HRnVOutput.fd.vlfper,...
    HRnVOutput.fd.peaklf,HRnVOutput.fd.lf,HRnVOutput.fd.lfper,HRnVOutput.fd.lfnorm,...
    HRnVOutput.fd.peakhf,HRnVOutput.fd.hf,HRnVOutput.fd.hfper,HRnVOutput.fd.hfnorm,...
    HRnVOutput.fd.hrv_tp,HRnVOutput.fd.lfhf,HRnVOutput.nl.sd1,HRnVOutput.nl.sd2,...
    HRnVOutput.nl.ApEn,HRnVOutput.nl.SampEn,HRnVOutput.nl.DFA(2),HRnVOutput.nl.DFA(3)};
else
    hrnvmoutput = {HRnVOutput.td.NNmean,HRnVOutput.td.SDNN, HRnVOutput.td.HRmean, ...
    HRnVOutput.td.SDHR, HRnVOutput.td.RMSSD, HRnVOutput.td.nn50,HRnVOutput.td.pnn50,...
    HRnVOutput.td.nn50x,HRnVOutput.td.pnn50x,HRnVOutput.td.NNskew, HRnVOutput.td.NNkurt, HRnVOutput.td.HRVTi,...
    HRnVOutput.fd.peakvlf,HRnVOutput.fd.vlf,HRnVOutput.fd.vlfper,...
    HRnVOutput.fd.peaklf,HRnVOutput.fd.lf,HRnVOutput.fd.lfper,HRnVOutput.fd.lfnorm,...
    HRnVOutput.fd.peakhf,HRnVOutput.fd.hf,HRnVOutput.fd.hfper,HRnVOutput.fd.hfnorm,...
    HRnVOutput.fd.hrv_tp,HRnVOutput.fd.lfhf,HRnVOutput.nl.sd1,HRnVOutput.nl.sd2,...
    HRnVOutput.nl.ApEn,HRnVOutput.nl.SampEn,HRnVOutput.nl.DFA(2),HRnVOutput.nl.DFA(3)};
end

%%Construct header and subheader for HRnVm Table
function header = constructheader(hrnv,hrnvm)

if hrnv == 1 %%HRV
   header = {'hrv_arr','hrv_sdrr','hrv_avhr','hrv_sdhr','hrv_rmssd',...
'hrv_nn50','hrv_pnn50','hrv_rr_skewness','hrv_rr_kurtosis','hrv_rr_tri_index','hrv_vlf_peak','hrv_vlf_ms','hrv_vlf_per'...
'hrv_lf_peak','hrv_lf_ms','hrv_lf_per','hrv_lf_nu',...
'hrv_hf_peak','hrv_hf_ms','hrv_hf_per','hrv_hf_nu','hrv_tp_ms','hrv_lf_hf_ratio',...
'hrv_poincare_sd1','hrv_poincare_sd2','hrv_app_ent','hrv_sam_ent','hrv_dfa_a1','hrv_dfa_a2'}; 
else
    if hrnvm == 0
        header = {cat(2,'hr',num2str(hrnv),'v_arr'),...
                cat(2,'hr',num2str(hrnv),'v_sdrr'),...
                cat(2,'hr',num2str(hrnv),'v_avhr'),...
                cat(2,'hr',num2str(hrnv),'v_sdhr'),...
                cat(2,'hr',num2str(hrnv),'v_rmssd'),...
                cat(2,'hr',num2str(hrnv),'v_nn50'),...
                cat(2,'hr',num2str(hrnv),'v_pnn50'),...
                cat(2,'hr',num2str(hrnv),'v_nn50x'),...   
                cat(2,'hr',num2str(hrnv),'v_pnn50x'),...
                cat(2,'hr',num2str(hrnv),'v_rr_skewness'),...
                cat(2,'hr',num2str(hrnv),'v_rr_kurtosis'),...
                cat(2,'hr',num2str(hrnv),'v_rr_tri_index'),...
                cat(2,'hr',num2str(hrnv),'v_vlf_peak'),...  
                cat(2,'hr',num2str(hrnv),'v_vlf_ms'),... 
                cat(2,'hr',num2str(hrnv),'v_vlf_per'),...
                cat(2,'hr',num2str(hrnv),'v_lf_peak'),...
                cat(2,'hr',num2str(hrnv),'v_lf_ms'),...
                cat(2,'hr',num2str(hrnv),'v_lf_per'),...
                cat(2,'hr',num2str(hrnv),'v_lf_nu'),...
                cat(2,'hr',num2str(hrnv),'v_hf_peak'),...
                cat(2,'hr',num2str(hrnv),'v_hf_ms'),...
                cat(2,'hr',num2str(hrnv),'v_hf_per'),...
                cat(2,'hr',num2str(hrnv),'v_hf_nu'),...
                cat(2,'hr',num2str(hrnv),'v_tp_ms'),... 
                cat(2,'hr',num2str(hrnv),'v_lf_hf_ratio'),...   
                cat(2,'hr',num2str(hrnv),'v_poincare_sd1'),...       
                cat(2,'hr',num2str(hrnv),'v_poincare_sd2'),... 
                cat(2,'hr',num2str(hrnv),'v_app_ent'),...
                cat(2,'hr',num2str(hrnv),'v_sam_ent'),...          
                cat(2,'hr',num2str(hrnv),'v_dfa_a1'),...   
                cat(2,'hr',num2str(hrnv),'v_dfa_a2')};
    else
        header = {cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_arr'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_sdrr'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_avhr'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_sdhr'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_rmssd'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_nn50'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_pnn50'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_nn50x'),...   
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_pnn50x'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_rr_skewness'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_rr_kurtosis'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_rr_tri_index'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_vlf_peak'),...  
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_vlf_ms'),... 
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_vlf_per'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_lf_peak'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_lf_ms'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_lf_per'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_lf_nu'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_hf_peak'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_hf_ms'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_hf_per'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_hf_nu'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_tp_ms'),... 
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_lf_hf_ratio'),...   
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_poincare_sd1'),...       
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_poincare_sd2'),... 
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_app_ent'),...
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_sam_ent'),...          
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_dfa_a1'),...   
            cat(2,'hr',num2str(hrnv),'v',num2str(hrnvm),'_dfa_a2')};
    end
end


%%Construct header and subheader for HRnVm Table
function filename = constructdeffilename(filetype,hrnvtype,patientid,hrnv,hrnvm)

%%filetype: 1: single file, 2: batch files
%%hrnvtype: 1: single hrnvm, 2: all HRnVm (such as HR3V-all include HRV,
%%HR2V,HR2V1,HR3V,HR3V1,HR3V2

if filetype == 2 %%Batch files
    if hrnvtype == 1 %%Single HRnVm
        if hrnv == 1 %%HRV
            filename = 'HRV-BatchResults';
        else
            if hrnvm == 0
                filename = cat(2,'HR',num2str(hrnv),'V-BatchResults');
            else
                filename = cat(2,'HR',num2str(hrnv),'V',num2str(hrnvm),'-BatchResults');
            end
        end
    else %all HRnVm
        if hrnv == 1 %%HRV
            filename = 'HRV-all-BatchResults';
        else
            filename = cat(2,'HR',num2str(hrnv),'V-all-BatchResults');
        end
    end
else %Single file
    if hrnvtype == 1 %%Single HRnVm
        if hrnv == 1 %%HRV
           filename = cat(2,patientid,'-HRV'); 
        else
            if hrnvm == 0
                filename = cat(2,patientid,'-HR',num2str(hrnv),'V');
            else
                filename = cat(2,patientid,'-HR',num2str(hrnv),'V',num2str(hrnvm));
            end
        end
    else %%all HRnVm 
        if hrnv == 1 %%HRV
           filename = cat(2,patientid,'-HRV'); 
        else
            filename = cat(2,patientid,'-HR',num2str(hrnv),'V-all');
         end  
    end
end

%%Generate Peak Time and use Physionet RR Interval Process to remove
%%ecotopic beats
function [ibi,ectopicBeats] = ibitimegeneration(ibidata, HRVParameters)

peaktime(1) = ibidata(1);
for index=2:length(ibidata)
    peaktime(index) = peaktime(index-1)+ibidata(index);
end

[IBIOutput.NN IBIOutput.tNN ectopicBeats] = RRIntervalPreprocess_Revised(ibidata,peaktime,HRVParameters);
if size(IBIOutput.NN,1)<size(IBIOutput.NN,2)
    handles.hrvdata.NN = IBIOutput.NN';
else
    handles.hrvdata.NN = IBIOutput.NN;
end

if size(IBIOutput.tNN,1)<size(IBIOutput.tNN,2)
    handles.hrvdata.tNN = IBIOutput.tNN';
else
    handles.hrvdata.tNN = IBIOutput.tNN;
end
ibi = [handles.hrvdata.tNN handles.hrvdata.NN];


%%Revise some settings of HRVParams based on interface inputs
function HRVParams = ChangeSettings(handles,HRVParams,ecothreshold)

%%Ecotopic beat detection limit (percentage of change in one interval to
%%another)
HRVParams.preprocess.per_limit = ecothreshold/100;
HRVParams.MSE.on = 0;%Disable MSE
HRVParams.HRT.on = 0;%Disable HRT

if get(handles.rbremove,'Value') == 1
    ecomethod = 'rem';
else
    if get(handles.rbcubic,'Value') == 1
        ecomethod = 'cub';
    else
        if get(handles.rbpchip,'Value') == 1
            ecomethod = 'pchip';
        else
            ecomethod = 'lin';
        end
    end
end
HRVParams.preprocess.method_outliers = ecomethod; 

%%Set sampling frequency
HRVParams.Fs = handles.fs;

%%Set Frequency domain Analysis Method
if get(handles.rblomb,'Value') == 1
    fdmethod = 'lomb';
else
    if get(handles.rbwelch,'Value') == 1
        fdmethod = 'welch';
    else
        if get(handles.rbfft,'Value') == 1
            fdmethod = 'fft';
        else
            fdmethod = 'burg';
        end
    end
end
HRVParams.freq.method = fdmethod;


function edecothre_Callback(hObject, eventdata, handles)
% hObject    handle to edecothre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edecothre as text
%        str2double(get(hObject,'String')) returns contents of edecothre as a double


% --- Executes during object creation, after setting all properties.
function edecothre_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edecothre (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edmsingle_Callback(hObject, eventdata, handles)
% hObject    handle to edmsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edmsingle as text
%        str2double(get(hObject,'String')) returns contents of edmsingle as a double


% --- Executes during object creation, after setting all properties.
function edmsingle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edmsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ednsingle_Callback(hObject, eventdata, handles)
% hObject    handle to ednsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ednsingle as text
%        str2double(get(hObject,'String')) returns contents of ednsingle as a double


% --- Executes during object creation, after setting all properties.
function ednsingle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ednsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ednall_Callback(hObject, eventdata, handles)
% hObject    handle to ednall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ednall as text
%        str2double(get(hObject,'String')) returns contents of ednall as a double


% --- Executes during object creation, after setting all properties.
function ednall_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ednall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in btbatch.
function btbatch_Callback(hObject, eventdata, handles)
% hObject    handle to btbatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if get(handles.rbsingle,'Value') == 1
    handles.hrnv = str2double(get(handles.ednsingle,'String'));
    handles.hrnvm = str2double(get(handles.edmsingle,'String'));
else
    handles.hrnv = str2double(get(handles.ednall,'String'));
    handles.hrnvm = handles.hrnv; %%Set hrnvm = hrnv to indicate all HRnVm based on hrnv value 
end

%%Do batch process for a folder with IBI or Kubios MAT IBI
%%Set default name
if get(handles.rbsingle,'Value') == 1 %Single HRnVm batch
    %%Set default file name
    defname = constructdeffilename(handles.filetype,1,'',handles.hrnv,handles.hrnvm);
else %All HRnVm batch
    defname = constructdeffilename(handles.filetype,2,'',handles.hrnv,handles.hrnvm);
end

%%File Saving
[outputFileName,outputPathName] = uiputfile('*.xls',cat(2,'Save results to:'),defname);
fullFileName = fullfile(outputPathName, outputFileName);
    
foldername = handles.foldername;
 %check input directory
fileList = dir(foldername); %get list of files
fileList(any([fileList.isdir],1))=[]; %remove folders/dir from the list
fnames = {fileList.name}; %get file names only from fileList structure  
%build array of full file paths    
fpaths=string(fnames);

for fileindex=1:length(fnames)
    filename = strcat(foldername,fpaths(fileindex));
    [filepath,name,ext] = fileparts(filename);
    fpath = strcat(convertStringsToChars(foldername), '/',convertStringsToChars(fpaths(fileindex)));
  
    if (handles.datatype == 2)%IBI data
        if ext == '.txt'
           fileID = fopen(fpath,'r');
           signal = textscan(fileID,'%f');
           ibidata = signal{1};
        else
            if ext == '.csv'
                ibidata = xlsread(fpath);
            end
        end
    else %Kubios IBI data
        result = load(fpath);
        ibidata = result.Res.HRV.Data.RR;
    end
    
    %%Extract recordid from prefix and postfix
    if handles.prefix == ""
        if handles.postfix ~= ""
            fileID = extractBefore(fpaths(fileindex),handles.postfix);
        else
            fileID = fpaths(fileindex); %%No prefix and postfix
        end
    else
        if handles.postfix == ""
            fileID = extractAfter(fpaths(fileindex),handles.prefix);
        else
            fileID = extractBetween(fpaths(fileindex),handles.prefix,handles.postfix);
        end
    end
    
    record_id = fileID{1};    
    
    handles.ecothreshold = str2double(get(handles.edecothre,'String'));

    %%Initialization of some basic HRV params using Physionet-Tool-Box function
    handles.HRVParams = ChangeSettings(handles,handles.HRVParams,handles.ecothreshold);

    %%ecotopic beats Removal
    [cleanibi,ectopicBeats] = ibitimegeneration(ibidata,handles.HRVParams);
    
    percentClean = round(10000*(length(cleanibi(:,2))/((length(cleanibi(:,2))+ectopicBeats))))/100;

    if percentClean < 80
        fprintf('Too noisy record %s of \n',handles.patientID+' has only '+num2str(percentClean)+'% non-ectopic beats!');
    end
    %%Save the percentage of removed ecotopic beat 
    handles.HRVParams.windowlength = cleanibi(size(cleanibi,1),1) + 1;%%Extra 1 second to smooth Physionet-toolbox calculation
    % Update handles structure if necessary
    guidata(hObject, handles);
    
    %%
    if get(handles.rbsingle,'Value') == 1 %Single HRnVm
        if fileindex == 1 %%Only write header the fist time
            header = constructheader(handles.hrnv,handles.hrnvm);
            header = cat(2,'patient_id',header);%%Add patient_id as first column
            xlswrite(fullFileName,header,1);
        end
        
        if handles.hrnvm == 0 %%HRV HR2V HR3V
            hrnvmoverlap = 0;
        else
            hrnvmoverlap = handles.hrnv - handles.hrnvm;
        end
        
        if handles.hrnv == 1
            hrnvmibi = cleanibi;
        else
            hrnvmibi = hrnvoverlap (cleanibi,handles.hrnv,hrnvmoverlap);
        end
        [HRnVOutput,hrnvmoutput] = hrnvmcalculation(hrnvmibi,handles.HRVParams,handles.hrnv);
        hrnvmoutput = cat(2,record_id,hrnvmoutput);
        xlsappend(convertStringsToChars(fullFileName),hrnvmoutput); 
        
    else %%HRnV,e.g.,HR3V include HRV, HR2v, HR2v1, HR3v,HR3v1,HR3v2 
        %Construct HRV header first (hrnv = 1)
        header = constructheader(1,0);
        header = cat(2,'patient_id',header); %%Add patient_id as first column

        %Calculate HRV first
        [HRnVOutput,hrnvmoutput] = hrnvmcalculation(cleanibi,handles.HRVParams,1);
        hrnvmoutput = cat(2,record_id,hrnvmoutput); %%Add patientID value
        if handles.hrnv>=2
            for n=2:handles.hrnv
                for m = 0:n-1
                    if m == 0
                        hrvoverlap = 0;
                    else
                        hrvoverlap = n - m;
                    end

                    %Calculate HRnVm ibi
                    hrnvmibi = hrnvoverlap (cleanibi,n,hrvoverlap);

                    %Construct header for HRnVm and append
                    subheader = constructheader(n,m);
                    header = cat(2,header,subheader);

                    %Calculate HRnVm param and append
                    [HRnVOutput,subhrnvmoutput] = hrnvmcalculation(hrnvmibi,handles.HRVParams,n);
                    hrnvmoutput = cat(2,hrnvmoutput,subhrnvmoutput);
                end
            end
        end
        if fileindex == 1 %Only write header the fist time
            xlswrite(fullFileName,header,1);
        end
        xlsappend(convertStringsToChars(fullFileName),hrnvmoutput);
    end
end
fprintf('All calculation finished! \n');


% --- Executes on button press in rbsingle.
function rbsingle_Callback(hObject, eventdata, handles)
% hObject    handle to rbsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbsingle
if get(handles.rbsingle,'Value') == 1
    set(handles.ednall,'Enable','off');
    set(handles.ednsingle,'Enable','on');
    set(handles.edmsingle,'Enable','on');
end


% --- Executes on button press in rball.
function rball_Callback(hObject, eventdata, handles)
% hObject    handle to rball (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rball
if get(handles.rball,'Value') == 1
    set(handles.ednall,'Enable','on');
    set(handles.ednsingle,'Enable','off');
    set(handles.edmsingle,'Enable','off');
end
