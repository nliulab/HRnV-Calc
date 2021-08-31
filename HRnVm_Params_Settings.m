function varargout = HRnVm_Params_Settings(varargin)
%   HRNVM_PARAMS_SETTINGS MATLAB code for HRnVm_Params_Settings.fig
%      HRNVM_PARAMS_SETTINGS, by itself, creates a new HRNVM_PARAMS_SETTINGS or raises the existing
%      singleton*.
%
%      H = HRNVM_PARAMS_SETTINGS returns the handle to a new HRNVM_PARAMS_SETTINGS or the handle to
%      the existing singleton*.
%
%      HRNVM_PARAMS_SETTINGS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HRNVM_PARAMS_SETTINGS.M with the given input arguments.
%
%      HRNVM_PARAMS_SETTINGS('Property','Value',...) creates a new HRNVM_PARAMS_SETTINGS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HRnVm_Params_Settings_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HRnVm_Params_Settings_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%   See also: GUIDE, GUIDATA, GUIHANDLES

%   Edit the above text to modify the response to help HRnVm_Params_Settings

%   DEPENDENCIES & LIBRARIES:
%       PhysioNet Cardiovascular Signal Toolbox
%       https://github.com/cliffordlab/PhysioNet-Cardiovascular-Signal-Toolbox
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
%       Nan Liu (chenglin.niu@u.duke.nus.edu) in 2021
%   
%	COPYRIGHT (C) 2021 

%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information

% Last Modified by GUIDE v2.5 25-Aug-2021 18:50:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HRnVm_Params_Settings_OpeningFcn, ...
                   'gui_OutputFcn',  @HRnVm_Params_Settings_OutputFcn, ...
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


% --- Executes just before HRnVm_Params_Settings is made visible.
function HRnVm_Params_Settings_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HRnVm_Params_Settings (see VARARGIN)

%%Get Info from HRnVm_IniSetConfirm
% get the handle of HRnVm_IniSetConfirm
hhrnvminitset = findobj('Tag','HRnVm_IniSetConfirm');
% if exists (not empty)
if ~isempty(hhrnvminitset)
    dhhrnvminitset = guidata(hhrnvminitset);
    handles.filetype = dhhrnvminitset.filetype;
    handles.datatype = dhhrnvminitset.datatype;
    handles.fs = dhhrnvminitset.fs;
    handles.postfix = dhhrnvminitset.postfix;
    handles.prefix = dhhrnvminitset.prefix;
    handles.HRVParams = dhhrnvminitset.HRVParams;
    
    if handles.filetype == 1 %Single File
        set(handles.btsingle,'Enable','on');
        handles.patientID = dhhrnvminitset.patientID;
        if (handles.datatype == 2) || (handles.datatype == 4) %%Single IBI
            handles.ibidata = dhhrnvminitset.data;
        end
    else %Batch Files
        set(handles.btbatch,'Enable','on');
        handles.foldername = dhhrnvminitset.foldername;
    end
    
    %%Close HRnVmCal window once parameters transferred
    close(hhrnvminitset);
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

% Choose default command line output for HRnVm_Params_Settings
handles.output = hObject;
%% Chenglin mod
% resize font for gui
txtHand = findall(handles.HRnVmSettings, '-property', 'FontUnits'); 
set(txtHand, 'FontUnits', 'normalized')
%%

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HRnVm_Params_Settings wait for user response (see UIRESUME)
% uiwait(handles.HRnVmSettings);


% --- Outputs from this function are returned to the command line.
function varargout = HRnVm_Params_Settings_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in cbaddparam.
function cbaddparam_Callback(hObject, eventdata, handles)
% hObject    handle to cbaddparam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbaddparam


% --- Executes on button press in btsingle.
function btsingle_Callback(hObject, eventdata, handles)
% hObject    handle to btsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Chenglin mod, use new ui design
if get(handles.rbsingle,'Value') == 1
    handles.hrnv = str2double(get(handles.ednsingle,'String'));
    if get(handles.samem, 'Value') == 1
        handles.hrnvm = handles.hrnv;
        set(handles.edmsingle, 'Enable', 'off');
        set(handles.edmsingle, 'String', get(handles.ednsingle,'String'));
    else
        set(handles.edmsingle, 'Enable', 'on');
        handles.hrnvm = str2double(get(handles.edmsingle,'String'));
    end
else
    set(handles.ednall, 'Enable', 'on');
    set(handles.edmsingle, 'Enable', 'off');
    set(handles.ednsingle, 'Enable', 'off');
    set(handles.samem, 'Enable', 'off');
    handles.hrnv = str2double(get(handles.ednall,'String'));
    handles.hrnvm = handles.hrnv; %%Set hrnvm = hrnv to indicate all HRnVm based on hrnv value 
end

if handles.hrnvm > handles.hrnv
    warndlg('Invalid m value!', 'm value too high');
    return;
end
if handles.hrnvm<1 || handles.hrnv<1
    warndlg('Invalid value! Only positive integer m or n allowed', 'm or n invalid');
    return;
end
%%
handles.ecothreshold = str2double(get(handles.edecothre,'String'));

%%Initialization of some basic HRV params using Physionet-Tool-Box function

handles.HRVParams = ChangeSettings(handles,handles.HRVParams,handles.ecothreshold);
%% Chenglin mod
if get(handles.use_kb, 'Value') == 1
    handles.HRVParams = Modify_params_kb(handles.HRVParams);
end
%%

%%ecotopic beats Removal and change HRVparameters windowlength here 
[cleanibi,ectopicBeats] = ibitimegeneration(handles.ibidata,handles.HRVParams);
%%Save the percentage of removed ecotopic beat 
handles.ectopicBeats = ectopicBeats;
handles.HRVParams.windowlength = cleanibi(size(cleanibi,1),1) + 1;%%Extra 1 second to smooth Physionet-toolbox calculation

percentClean = round(10000*(length(cleanibi(:,2))/((length(cleanibi(:,2))+ectopicBeats))))/100;

if percentClean < 80
    %%Create messagebox
    msg = cat(2,'Record ',handles.patientID,' has only ',num2str(percentClean),'% non-ectopic beats!');
    warndlg(msg,'Too many ectopic beats!');
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
    
    %%Additional HRV Params Saving if checked
    if get(handles.cbaddparam,'Value') == 1
        defparamname = strcat(defname,'-AddParams');
        [outputparamFileName,outputparamPathName] = uiputfile('*.xls',cat(2,'Save additional parameters results to:'),defparamname);
        fullparamFileName = fullfile(outputparamPathName, outputparamFileName);
        
        paramheader = constructparamheader(handles.hrnv,handles.hrnvm);
        paramheader = cat(2,'patient_id',paramheader);%%Add patient_id as first column
        xlswrite(fullparamFileName,paramheader,1);
    end
    
    %hrnvmoverlap = handles.hrnv - handles.hrnvm;%% Chenglin mod, don't
    %need this under new HRnVm interpretation
    if handles.hrnv == 1
        hrnvmibi = cleanibi;
    else
        hrnvmibi = hrnvoverlap (cleanibi,handles.hrnv,handles.hrnvm);%% Chenglin mod, put hrnvm directly into function
    end
    [HRnVOutput,hrnvmoutput] = hrnvmcalculation(hrnvmibi,handles.HRVParams,handles.hrnv);
    hrnvmoutput = cat(2,handles.patientID,hrnvmoutput);
    xlsappend(convertStringsToChars(fullFileName),hrnvmoutput); 
    
    if get(handles.cbaddparam,'Value') == 1
        hrnvmparamoutput = hrnvmparamcal(hrnvmibi);
        hrnvmparamoutput = cat(2,handles.patientID,hrnvmparamoutput);
        xlsappend(convertStringsToChars(fullparamFileName),hrnvmparamoutput);
    end
    
    %%Save HRnVm name and result for display in HRnVm_Result
    if handles.hrnv == 1 %%HRV
       handles.hrnvmname = 'HRV'; 
    else
        if handles.hrnvm == handles.hrnv %% Chenglin mod
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
    
    %%Additional HRV Params Saving if checked
    if get(handles.cbaddparam,'Value') == 1
        defparamname = strcat(defname,'-AddParams');
        [outputparamFileName,outputparamPathName] = uiputfile('*.xls',cat(2,'Save additional parameters results to:'),defparamname);
        fullparamFileName = fullfile(outputparamPathName, outputparamFileName);
        
        paramheader = constructparamheader(handles.hrnv,handles.hrnvm);
        paramheader = cat(2,'patient_id',paramheader);%%Add patient_id as first column
    end
    
    %Calculate HRV first
    [HRnVOutput,hrnvmoutput] = hrnvmcalculation(cleanibi,handles.HRVParams,1);
    hrnvmoutput = cat(2,handles.patientID,hrnvmoutput); %%Add patientID value
    
    if get(handles.cbaddparam,'Value') == 1
        paramheader = constructparamheader(1,0);
        paramheader = cat(2,'patient_id',paramheader); %%Add patient_id as first column

        hrnvmparamoutput = hrnvmparamcal(cleanibi);
        hrnvmparamoutput = cat(2,handles.patientID,hrnvmparamoutput);
    end
        
    if handles.hrnv>=2
        for n=2:handles.hrnv
            for j = 0:n-1
                m = n-j;
                %% Chenglin mod, delete the following lines
                %if m == 0
                %    hrvoverlap = 0;
                %else
                %    hrvoverlap = n - m;
                %end
                %%
                
                %Calculate HRnVm ibi
                hrnvmibi = hrnvoverlap (cleanibi,n,m);%% Chenglin mod, use m 
                
                %Construct header for HRnVm and append
                subheader = constructheader(n,m);
                header = cat(2,header,subheader);
                
                %Calculate HRnVm param and append
                [HRnVOutput,subhrnvmoutput] = hrnvmcalculation(hrnvmibi,handles.HRVParams,n);
                hrnvmoutput = cat(2,hrnvmoutput,subhrnvmoutput);
                
                if get(handles.cbaddparam,'Value') == 1
                    %Construct header for HRnVm additional params and append
                    subparamheader = constructparamheader(n,m);
                    paramheader = cat(2,paramheader,subparamheader);

                    %Calculate HRnVm param and append
                    subhrnvmparamoutput = hrnvmparamcal(hrnvmibi);
                    hrnvmparamoutput = cat(2,hrnvmparamoutput,subhrnvmparamoutput);
                end
            end
        end
    end

    if isstring(fullSingleAllName)
        fullSingleAllName = convertStringsToChars(fullSingleAllName);
    end
    xlswrite(fullSingleAllName,header,1);
    xlsappend(fullSingleAllName,hrnvmoutput);
    
    if get(handles.cbaddparam,'Value') == 1
        if isstring(fullparamFileName)
           fullparamFileName = convertStringsToChars(fullparamFileName);           
        end
        xlswrite(fullparamFileName,paramheader,1);
        xlsappend(fullparamFileName,hrnvmparamoutput);
    end
    
    %%Create messagebox
    uiwait(msgbox('Calculation finished!'));

    hhrnvmsettings = findobj('Tag','HRnVmSettings');
    % if exists (not empty)
    if ~isempty(hhrnvmsettings)
        close(hhrnvmsettings);
    end
end


% --- Executes on button press in btbatch.
function btbatch_Callback(hObject, eventdata, handles)
% hObject    handle to btbatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%% Chenglin mod, use new ui design
if get(handles.rbsingle,'Value') == 1
    handles.hrnv = str2double(get(handles.ednsingle,'String'));
    if get(handles.samem, 'Value') == 1
        handles.hrnvm = handles.hrnv;
        set(handles.edmsingle, 'Enable', 'off');
        set(handles.edmsingle, 'String', get(handles.ednsingle,'String'));
    else
        set(handles.edmsingle, 'Enable', 'on');
        handles.hrnvm = str2double(get(handles.edmsingle,'String'));
    end
else
    set(handles.ednall, 'Enable', 'on');
    set(handles.edmsingle, 'Enable', 'off');
    set(handles.ednsingle, 'Enable', 'off');
    set(handles.samem, 'Enable', 'off');
    handles.hrnv = str2double(get(handles.ednall,'String'));
    handles.hrnvm = handles.hrnv; %%Set hrnvm = hrnv to indicate all HRnVm based on hrnv value 
end
if handles.hrnvm > handles.hrnv
    warndlg('Invalid m value!', 'm value too high');
    return;
end
if handles.hrnvm<1 || handles.hrnv<1
    warndlg('Invalid value! Only positive interger m or n allowed', 'm or n invalid');
    return;
end
%%

%%Do batch process for a folder with IBI or Kubios MAT IBI
%%Set default name
if get(handles.rbsingle,'Value') == 1 %Single HRnVm batch
    %%Set default file name
    defname = constructdeffilename(handles.filetype,1,'',handles.hrnv,handles.hrnvm);
else %All HRnVm batch
    defname = constructdeffilename(handles.filetype,2,'',handles.hrnv,handles.hrnvm);
end

%%Normal HRV Params File Saving
[outputFileName,outputPathName] = uiputfile('*.xls',cat(2,'Save results to:'),defname);
fullFileName = fullfile(outputPathName, outputFileName);

%%Additional HRV Params Saving if checked
if get(handles.cbaddparam,'Value') == 1
    defparamname = strcat(defname,'-AddParams');
    [outputparamFileName,outputparamPathName] = uiputfile('*.xls',cat(2,'Save additional parameters results to:'),defparamname);
    fullparamFileName = fullfile(outputparamPathName, outputparamFileName);
end

foldername = handles.foldername;
 %check input directory
fileList = dir(foldername); %get list of files
fileList(any([fileList.isdir],1))=[]; %remove folders/dir from the list
fnames = {fileList.name}; %get file names only from fileList structure  
%build array of full file paths    
fpaths=string(fnames);

for fileindex=1:length(fnames)
    ibidata = [];
    filename = strcat(foldername,fpaths(fileindex));
    [filepath,name,ext] = fileparts(filename);
    fpath = strcat(convertStringsToChars(foldername), '/',convertStringsToChars(fpaths(fileindex)));
  
    if (handles.datatype == 2)%IBI data
        if ext == '.txt'
           openfileID = fopen(fpath,'r');
           signal = textscan(openfileID,'%f');
           ibidata = signal{1};         
            if ~isempty(openfileID)
                fclose(openfileID);
            end
        else
            if ext == '.csv'
                ibidata = xlsread(fpath);
            end
        end
    else %Kubios IBI data
        if (handles.datatype == 4)
            result = load(fpath);
            ibidata = result.Res.HRV.Data.RR;
        else %%Temporay add for raw ECG batch
%             openfileID = fopen(fpath,'r');
%             ecgsignal = textscan(openfileID,'%f');
%             ecgdata = ecgsignal{1};    
%             
%             handles.ecothreshold = str2double(get(handles.edecothre,'String'));
%             %%Automatic get RRI data%%%
%             handles.HRVParams = ChangeSettings(handles,handles.HRVParams,handles.ecothreshold);
% 
%             %%Set processed windowlength to be whole ECG signal
%             handles.HRVParams.windowlength = floor(length(ecgdata)/handles.fs)+1;
% 
%             %%Using Physionet run_qrsdet_by_seg, but with one addiontional param '1'
%             %%to detect the peaks of whole signal, especially, remained QRS peaks of
%             %%the last segment less then 15 seconds window, and change
%             %%ecgdata to mv
%             jqrs_ann = run_qrsdet_by_seg_revised(1000*ecgdata,handles.HRVParams);
% 
%             %Search back and forward to see if this is real peak, if not,
%             %change
%             sbp = 10;
%             
%             for i = 1:length(jqrs_ann)
%                 startcheckpos = jqrs_ann(i)-sbp;
%                 endcheckpos = jqrs_ann(i)+sbp;
%                 if endcheckpos > length(ecgdata)
%                     endcheckpos = length(ecgdata);
%                 end
% 
%                 if startcheckpos < 1
%                     startcheckpos = 1;
%                 end
%                 ecgcheckseg = ecgdata(startcheckpos:endcheckpos);
%                 if ecgdata(jqrs_ann(i)) < max(ecgcheckseg)
%                     maxindexr=find(ecgcheckseg==max(ecgcheckseg));
%                     if length(maxindexr)>1
%                         maxindex = maxindexr(1);
%                     else
%                         maxindex = maxindexr;
%                     end
%                     jqrs_ann(i) = maxindex+jqrs_ann(i)-sbp-1;
%                 end
%             end
%             
%             ibidata = diff(jqrs_ann)/handles.fs;           
         end
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
    if isempty(fileID) %%Wrong input of prefix and postfix lead to fail extraction
        fileID = fpaths(fileindex);
    else
        if iscell(fileID) %%Extractbetween seems generate the cell contains the chars
            fileID = fileID{1};
        end
    end
    
    if isstring(fileID)
        record_id = cellstr(fileID);
    else
        record_id = fileID;
    end
    
    handles.ecothreshold = str2double(get(handles.edecothre,'String'));

    %%Initialization of some basic HRV params using Physionet-Tool-Box function
    handles.HRVParams = ChangeSettings(handles,handles.HRVParams,handles.ecothreshold);
    %% Chenglin mod; modify parames according to Kubios preset
    if get(handles.use_kb, 'Value') == 1
        handles.HRVParams = Modify_params_kb(handles.HRVParams);
    end
    %%
    

    %%ecotopic beats Removal
    [cleanibi,ectopicBeats] = ibitimegeneration(ibidata,handles.HRVParams);
    
    percentClean = round(10000*(length(cleanibi(:,2))/((length(cleanibi(:,2))+ectopicBeats))))/100;

    if percentClean < 80
        msg = cat(2,'Record ',record_id{1},' has only ',num2str(percentClean),'% non-ectopic beats!');
        warndlg(msg,'Too many ectopic beats!', 'non-modal');
        continue; %% Chenglin mod, let the process continue for other files
    end
    
    %%Save the percentage of removed ecotopic beat 
    handles.HRVParams.windowlength = cleanibi(size(cleanibi,1),1) + 1;%%Extra 1 second to smooth Physionet-toolbox calculation
    % Update handles structure if necessary
    guidata(hObject, handles);
    
    %%
    if get(handles.rbsingle,'Value') == 1 %Single HRnVm
        
        if isstring(fullFileName)
            fullFileName = convertStringsToChars(fullFileName);
        end
        
        if get(handles.cbaddparam,'Value') == 1
            if isstring(fullparamFileName)
                fullparamFileName = convertStringsToChars(fullparamFileName);
            end
        end
    
        if fileindex == 1 %%Only write header the fist time
            header = constructheader(handles.hrnv,handles.hrnvm);
            header = cat(2,'patient_id',header);%%Add patient_id as first column
            xlswrite(fullFileName,header,1);
            
            if get(handles.cbaddparam,'Value') == 1
                paramheader = constructparamheader(handles.hrnv,handles.hrnvm);
                paramheader = cat(2,'patient_id',paramheader);%%Add patient_id as first column
                xlswrite(fullparamFileName,paramheader,1);
            end
            
        end
        %% Chenglin mod, delete following lines
        %if handles.hrnvm == 0 %%HRV HR2V HR3V
        %    hrnvmoverlap = 0;
        %else
        %    hrnvmoverlap = handles.hrnv - handles.hrnvm;
        %end
        %%
        
        if handles.hrnv == 1
            hrnvmibi = cleanibi;
        else
            hrnvmibi = hrnvoverlap (cleanibi,handles.hrnv,handles.hrnvm); %% Chenglin mod, use hrnvm directly
        end
        [HRnVOutput,hrnvmoutput] = hrnvmcalculation(hrnvmibi,handles.HRVParams,handles.hrnv);

        hrnvmoutput = cat(2,record_id,hrnvmoutput);
        xlsappend(convertStringsToChars(fullFileName),hrnvmoutput); 
        
        if get(handles.cbaddparam,'Value') == 1
            hrnvmparamoutput = hrnvmparamcal(hrnvmibi);
            hrnvmparamoutput = cat(2,record_id,hrnvmparamoutput);
            xlsappend(convertStringsToChars(fullparamFileName),hrnvmparamoutput);
        end
        
    else %%HRnV,e.g.,HR3V include HRV, HR2v, HR2v1, HR3v,HR3v1,HR3v2 
        %Construct HRV header first (hrnv = 1)
        header = constructheader(1,0);
        header = cat(2,'patient_id',header); %%Add patient_id as first column
        
        if get(handles.cbaddparam,'Value') == 1
            paramheader = constructparamheader(1,0);
            paramheader = cat(2,'patient_id',paramheader); %%Add patient_id as first column
        end       

        %Calculate HRV first
        [HRnVOutput,hrnvmoutput] = hrnvmcalculation(cleanibi,handles.HRVParams,1);
        hrnvmoutput = cat(2,record_id,hrnvmoutput); %%Add patientID value
        
        if get(handles.cbaddparam,'Value') == 1
            hrnvmparamoutput = hrnvmparamcal(cleanibi);
            hrnvmparamoutput = cat(2,record_id,hrnvmparamoutput);
        end
        
        if handles.hrnv>=2
            for n=2:handles.hrnv
                for j = 0:n-1
                    m = n-j;
                    %% Chenglin mod, delete the following lines
                    %if m == 0
                    %    hrvoverlap = 0;
                    %else
                    %    hrvoverlap = n - m;
                    %end
                    %%

                    %Calculate HRnVm ibi
                    hrnvmibi = hrnvoverlap (cleanibi,n,m);%% Chenglin mod, use m instead

                    %Construct header for HRnVm and append
                    subheader = constructheader(n,m);
                    header = cat(2,header,subheader);

                    %Calculate HRnVm param and append
                    [HRnVOutput,subhrnvmoutput] = hrnvmcalculation(hrnvmibi,handles.HRVParams,n);
                    hrnvmoutput = cat(2,hrnvmoutput,subhrnvmoutput);
                    
                    if get(handles.cbaddparam,'Value') == 1
                        %Construct header for HRnVm additional params and append
                        subparamheader = constructparamheader(n,m);
                        paramheader = cat(2,paramheader,subparamheader);

                        %Calculate HRnVm param and append
                        subhrnvmparamoutput = hrnvmparamcal(hrnvmibi);
                        hrnvmparamoutput = cat(2,hrnvmparamoutput,subhrnvmparamoutput);
                    end
                end
            end
        end
        if isstring(fullFileName)
            fullFileName = convertStringsToChars(fullFileName);
        end
        if get(handles.cbaddparam,'Value') == 1
            if isstring(fullparamFileName)
                fullparamFileName = convertStringsToChars(fullparamFileName);
            end
        end
        
        if fileindex == 1 %Only write header the fist time
            xlswrite(fullFileName,header,1);
        end
        xlsappend(fullFileName,hrnvmoutput);
        
        if get(handles.cbaddparam,'Value') == 1
            if fileindex == 1 %Only write header the fist time
                xlswrite(fullparamFileName,paramheader,1);
            end
            xlsappend(fullparamFileName,hrnvmparamoutput);
        end
    end

%     Temporay add for ECG raw batch
%     if ~isempty(openfileID)
%         fclose(openfileID);
%     end
    %%Close each file after use

end
fprintf('All calculation finished! \n');

%%Create messagebox
uiwait(msgbox('All Calculation finished!'));

hhrnvmsettings = findobj('Tag','HRnVmSettings');
% if exists (not empty)
if ~isempty(hhrnvmsettings)
    close(hhrnvmsettings);
end


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



function ednsingle_Callback(hObject, eventdata, handles)
% hObject    handle to ednsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ednsingle as text
%        str2double(get(hObject,'String')) returns contents of ednsingle as a double
if get(handles.samem, 'Value') == 1
        set(handles.edmsingle, 'Enable', 'off');
        set(handles.edmsingle, 'String', get(handles.ednsingle,'String'));
    else
        set(handles.edmsingle, 'Enable', 'on');
end



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

%%%To process new IBI based on HRnVm concept
%% Chenglin mod
% modify hrnvoverlap using new interpretation of HRnVm and samem
% hrnv - hrvoverlap = hrnvm; according to the original notation
 function processedibi = hrnvoverlap (ibi,hrnv,hrnvm)
    processedibilen = floor((length(ibi(:,2))-hrnv+1)/hrnvm);
    %Calculate first processed ibi, further will have overlap
    processedibi = zeros(processedibilen,2);
    for j = 1:hrnv
        processedibi(1,2) = processedibi(1,2)+ibi(j,2);
    end
    processedibi(1,1) = ibi(1,1); 
    
    for i=2:processedibilen
        for j = 1:hrnv
            processedibi(i,2) = processedibi(i,2)+ibi((i-1)*hrnvm+j,2);
        end
        processedibi(i,1) = ibi((i-1)*hrnvm+1,1);
    end
%%
    
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

%%HRnVm Additional parameters calculation
function hrvparam =hrnvmparamcal(hrnvmibi)
kmax = [5 10 20 30 40];

hrnvibi = hrnvmibi(:,2)*1000; %to ms
%%%Calculate new parameter

newparam.MAD = round(mad(hrnvibi)*1000)/1000; %in ms, and round to 3 decimals
newparam.KFD = round(1000*Katz_FD(hrnvibi))/1000;
diffibi = diff(hrnvibi);
newparam.ZUG = round(1000*sum(abs(diffibi-median(diffibi)))/length(diffibi))/1000;

hribi = round(1000*60*1000./hrnvibi)/1000; %round to 3 decimals
sumHuey = 0;

for ii = 2:length(hribi)-1
   if ii == 22
       test = 1;
   end
   if (hribi(ii-1)-hribi(ii))*(hribi(ii)-hribi(ii+1))<0
       sumHuey = sumHuey + hribi(ii)-hribi(ii+1);
   end
end

newparam.HUEY = round(1000*sumHuey)/1000;

for kk = 1:length(hribi)-1
    phii(kk) = atan(hribi(kk+1)/hribi(kk));
end
newparam.HANN = round(1000*iqr(phii))/1000;

for j=1:length(kmax)
    newparam.HFD(j)= round(1000*Higuchi_FD(hrnvibi,kmax(j)))/1000;
end

hrvparam = {newparam.MAD,newparam.KFD,newparam.ZUG,newparam.HUEY,newparam.HANN};
for jj=1:length(kmax)
    hrvparam = cat(2,hrvparam,newparam.HFD(jj));
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
    if hrnvm == hrnv %% Chenglin mod
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
function header = constructparamheader(n,m)
    
kmax = [5 10 20 30 40];
%%Construct Header%%   
if n == 1 %%HRV
    header = {'hrv_MAD','hrv_KFD','hrv_Zug','hrv_Huey','hrv_Hann'};
    for i=1:length(kmax)
        header =  cat(2,header,cat(2,'hrv_HFD_',num2str(kmax(i))));
    end
else
    if m == n %% Chenglin mod, let m = n
        header = {cat(2,'hr',num2str(n),'v_MAD'),...
            cat(2,'hr',num2str(n),'v_KFD'),...
            cat(2,'hr',num2str(n),'v_Zug'),...
            cat(2,'hr',num2str(n),'v_Huey'),...
            cat(2,'hr',num2str(n),'v_Hann')};
        for i=1:length(kmax)
             header =  cat(2,header,cat(2,'hr',num2str(n),'v_HFD_',num2str(kmax(i))));
        end
    else
        header = {cat(2,'hr',num2str(n),'v',num2str(m),'_MAD'),...
        cat(2,'hr',num2str(n),'v',num2str(m),'_KFD'),...
        cat(2,'hr',num2str(n),'v',num2str(m),'_Zug'),...
        cat(2,'hr',num2str(n),'v',num2str(m),'_Huey'),...
        cat(2,'hr',num2str(n),'v',num2str(m),'_Hann')};
        for i=1:length(kmax)
            header =  cat(2,header,cat(2,'hr',num2str(n),'v',num2str(m),'_HFD_',num2str(kmax(i))));
        end
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
            if hrnvm == hrnv %% Chenglin mod 
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
            if hrnvm == hrnv %% chenglin mod 
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


% --- Executes on button press in samem.
function samem_Callback(hObject, eventdata, handles)
% hObject    handle to samem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.samem, 'Value') == 1
        %handles.hrnvm = handles.hrnv;
        set(handles.edmsingle, 'Enable', 'off');
        set(handles.edmsingle, 'String', get(handles.ednsingle,'String'));
    else
        set(handles.edmsingle, 'Enable', 'on');
        handles.hrnvm = str2double(get(handles.edmsingle,'String'));
end

function use_kb_Callback(hObject, eventdata, handles)
% hObject    handle to samem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function rball_Callback(hObject, eventdata, handles)
% hObject    handle to samem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rball, 'Value') == 1
    set(handles.edmsingle, 'Enable', 'off');
    set(handles.ednsingle, 'Enable', 'off');
    set(handles.samem, 'Enable', 'off');
    set(handles.ednall, 'Enable', 'on');
end

function rbsingle_Callback(hObject, eventdata, handles)
% hObject    handle to samem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.rbsingle, 'Value') == 1
    set(handles.edmsingle, 'Enable', 'on');
    set(handles.ednsingle, 'Enable', 'on');
    set(handles.samem, 'Enable', 'on');
    set(handles.ednall, 'Enable', 'off');
end
nv = get(handles.ednsingle,'String');
if get(handles.samem, 'Value') == 1
        set(handles.edmsingle, 'Enable', 'off');
        set(handles.edmsingle, 'String', nv);
    else
        set(handles.edmsingle, 'Enable', 'on');
end



% --- Executes on key press with focus on ednsingle and none of its controls.
function ednsingle_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to ednsingle (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
nv = get(handles.ednsingle,'String');
if get(handles.samem, 'Value') == 1
        %handles.hrnvm = handles.hrnv;
        set(handles.edmsingle, 'Enable', 'off');
        set(handles.edmsingle, 'String', nv);
    else
        set(handles.edmsingle, 'Enable', 'on');
        %handles.hrnvm = str2double(get(handles.edmsingle,'String'));
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ednsingle.
