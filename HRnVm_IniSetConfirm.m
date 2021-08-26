function varargout = HRnVm_IniSetConfirm(varargin)
% HRNVM_INISETCONFIRM MATLAB code for hrnvm_inisetconfirm.fig
%      HRNVM_INISETCONFIRM, by itself, creates a new HRNVM_INISETCONFIRM or raises the existing
%      singleton*.
%
%      H = HRNVM_INISETCONFIRM returns the handle to a new HRNVM_INISETCONFIRM or the handle to
%      the existing singleton*.
%
%      HRNVM_INISETCONFIRM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HRNVM_INISETCONFIRM.M with the given input arguments.
%
%      HRNVM_INISETCONFIRM('Property','Value',...) creates a new HRNVM_INISETCONFIRM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HRnVm_IniSetConfirm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HRnVm_IniSetConfirm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hrnvm_inisetconfirm

% Last Modified by GUIDE v2.5 04-Feb-2021 23:50:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HRnVm_IniSetConfirm_OpeningFcn, ...
                   'gui_OutputFcn',  @HRnVm_IniSetConfirm_OutputFcn, ...
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


% --- Executes just before hrnvm_inisetconfirm is made visible.
function HRnVm_IniSetConfirm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hrnvm_inisetconfirm (see VARARGIN)

%%%
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
    handles.infant = dhhrnvmcal.infant;
    
    set(handles.txtfs,'String',handles.fs);
    
    switch handles.filetype
        case 1
            set(handles.txtfiletype,'String','Single File');
            handles.data = dhhrnvmcal.data;
        otherwise
            set(handles.txtfiletype,'String','Batch Files');
    end
    
    switch handles.infant
        case 1
            set(handles.txtinfant,'ForegroundColor','red');
            set(handles.txtinfant,'String','Infant');
        otherwise
            set(handles.txtinfant,'String','Adult');
    end
    
    switch handles.datatype
        case 1
            set(handles.txtdatatype,'String','ECG Raw');
        case 2
            set(handles.txtdatatype,'String','IBI');
        case 3
            set(handles.txtdatatype,'String','Kubios ECG');
        case 4
            set(handles.txtdatatype,'String','Kubios IBI');
        otherwise
            set(handles.txtfiletype,'String','ECG PC(with Peak Position');
    end

    if handles.filetype == 1 %Single File
        handles.patientID = dhhrnvmcal.patientID;
        set(handles.txtpatientID,'String',handles.patientID);
        if (handles.datatype == 2) || (handles.datatype == 4) %%Single IBI
            handles.ibidata = dhhrnvmcal.data;
        end
    else %Batch Files
        handles.foldername = dhhrnvmcal.foldername;
        %%Extract first patientID from filename
         %check input directory
        fileList = dir(handles.foldername); %get list of files
        fileList(any([fileList.isdir],1))=[]; %remove folders/dir from the list
        fnames = {fileList.name}; %get file names only from fileList structure  
        %build array of full file paths    
        fpaths=string(fnames);
        %%Extract recordid from prefix and postfix
        if handles.prefix == ""
            if handles.postfix ~= ""
                fileID = extractBefore(fpaths(1),handles.postfix);
            else
                %% Chenglin mod
                fileID = fpaths(1);%fpaths(fileindex); %%No prefix and postfix
                %%
            end
        else
            if handles.postfix == ""
                fileID = extractAfter(fpaths(1),handles.prefix);
            else
                fileID = extractBetween(fpaths(1),handles.prefix,handles.postfix);
            end
        end
        if isempty(fileID) %%Wrong input of prefix and postfix lead to fail extraction
            fileID = fpaths(1);
        else
            if iscell(fileID) %%Extractbetween seems generate the cell contains the chars
                fileID = fileID{1};
            end
        end
        set(handles.txtpatientID,'String',fileID+'  etc.,.');
    end
       
end


%% Chenglin mod
% resize font for gui
txtHand = findall(handles.HRnVm_IniSetConfirm, '-property', 'FontUnits'); 
set(txtHand, 'FontUnits', 'normalized')
%%
% Choose default command line output for hrnvm_inisetconfirm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hrnvm_inisetconfirm wait for user response (see UIRESUME)
% uiwait(handles.HRnVm_IniSetConfirm);


% --- Outputs from this function are returned to the command line.
function varargout = HRnVm_IniSetConfirm_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btconfirmback.
function btconfirmback_Callback(hObject, eventdata, handles)
% hObject    handle to btconfirmback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% get the handle of HRnVmCal
hhrnvminitset = findobj('Tag','HRnVm_IniSetConfirm');
% if exists (not empty)
if ~isempty(hhrnvminitset)
    close(hhrnvminitset);
end

% --- Executes on button press in btconfirm.
function btconfirm_Callback(hObject, eventdata, handles)
% hObject    handle to btconfirm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if handles.filetype == 2 %Batch file
    HRnVm_Params_Settings;
else
    if (handles.datatype == 2)||(handles.datatype == 4) %%IBI file
        HRnVm_Params_Settings;
    else %%ECG Raw
        PreProcess;
    end
end
% get the handle of HRnVmCal
hhrnvminitset = findobj('Tag','HRnVm_IniSetConfirm');
% if exists (not empty)
if ~isempty(hhrnvminitset)
    close(hhrnvminitset);
end
