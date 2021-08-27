function varargout = HRnVm_Calculation(varargin)
% HRNVM_CALCULATION MATLAB code for HRnVm_Calculation.fig
%      HRNVM_CALCULATION, by itself, creates a new HRNVM_CALCULATION or raises the existing
%      singleton*.
%
%      H = HRNVM_CALCULATION returns the handle to a new HRNVM_CALCULATION or the handle to
%      the existing singleton*.
%
%      HRNVM_CALCULATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HRNVM_CALCULATION.M with the given input arguments.
%
%      HRNVM_CALCULATION('Property','Value',...) creates a new HRNVM_CALCULATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HRnVm_Calculation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HRnVm_Calculation_OpeningFcn via varargin.
%
%   DEPENDENCIES & LIBRARIES:
%       PhysioNet Cardiovascular Signal Toolbox
%       https://github.com/cliffordlab/PhysioNet-Cardiovascular-Signal-Toolbox
%
%   REFERENCE: 
%   Chenglin Niu, Dagang Guo et al. HRnV-Calc: A software for heart rate n-variability
%   and heart rate variability analysis
%
%   Written by: Dagang Guo(guo.dagang@duke-nus.edu.sg), Nan Liu, Chenglin Niu
%
%	REPO:       
%       https://github.com/nliulab/HRnV-Calc
%   ORIGINAL SOURCE AND AUTHORS:     
%       Written by Dagang Guo(guo.dagang@duke-nus.edu.sg), Nan Liu,
%       Chenglin Niu on 2021
%   
%	COPYRIGHT (C) 2021 

%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information


% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HRnVm_Calculation_OpeningFcn, ...
                   'gui_OutputFcn',  @HRnVm_Calculation_OutputFcn, ...
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


% --- Executes just before HRnVm_Calculation is made visible.
function HRnVm_Calculation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HRnVm_Calculation (see VARARGIN)

% Choose default command line output for HRnVm_Calculation
handles.output = hObject;

%% Chenglin mod 
% Include current working directory and its sub-directories to PATH
HRnV_path = fileparts(which('HRnVm_Calculation.m'));
cd(HRnV_path)
if exist('PhysioNet-Cardiovascular-Signal-Toolbox-master', 'dir') ~= 7 
    msg = sprintf('PhysioNet-Cardiovascular-Signal-Toolbox Not Installed!\n                  Please Install the toolbox first');
    warndlg(msg,"Denpendencies Not Found")
    return;
end
addpath(genpath(HRnV_path));
% resize font for gui
hhrnvmresult = findobj('Tag','hrnvmresult');
txtHand = findall(handles.HRnVmCal, '-property', 'FontUnits'); 
set(txtHand, 'FontUnits', 'normalized')
%%


%%Initialize some handles parameters
%%Temp setting
handles.fs = 250;
set(handles.rb250,'Value',1);
set(handles.edprefix,'String','');
set(handles.edpostfix,'String','');


%handles.fs = 125; %Initialize sampling rate
handles.infant = 2; %1?Infant,2: Adult
handles.filetype = 1;%File type: 1-Single; 2-Batch
handles.datatype = 1;%Data type: 1-ECG Raw; 2-IBI; 3-Kubios ECG; 4-Kubios IBI?5-ECG Peak Check (PC)
handles.prefix = "";
handles.postfix = "";
handles.foldername = "";
handles.patientID = "";

% Update handles structure
guidata(hObject, handles);

%%Close old HRnVm_Result or Preprocess figure once this HRnVm_Calculation is
%%calling from them
hhrnvmresult = findobj('Tag','hrnvmresult');
% if exists (not empty)
if ~isempty(hhrnvmresult)
    close(hhrnvmresult);
end

hhrnvpreprocess = findobj('Tag','HRnVmPreprocess');
% if exists (not empty)
if ~isempty(hhrnvpreprocess)
    close(hhrnvpreprocess);
end

% UIWAIT makes HRnVm_Calculation wait for user response (see UIRESUME)
% uiwait(handles.HRnVmCal);


% --- Outputs from this function are returned to the command line.
function varargout = HRnVm_Calculation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in btnext.
function btnext_Callback(hObject, eventdata, handles)
% hObject    handle to btnext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%%Update all settings to handles
if get(handles.rb125,'Value') == 1
    handles.fs = 125;
else
    if get(handles.rb250,'Value') == 1
        handles.fs = 250;
    else
        handles.fs = str2double(get(handles.edfs,'String'));
    end
end

if get(handles.rbsingle,'Value') == 1
    handles.filetype = 1;
else
    handles.filetype = 2;
end

if get(handles.rbecg,'Value') == 1
    handles.datatype = 1;
else
    if get(handles.rbibi,'Value') == 1
        handles.datatype = 2;
    else
        if get(handles.rbkecg,'Value') == 1
            handles.datatype = 3;
        else
            if get(handles.rbkibi,'Value') == 1
                handles.datatype = 4;
            else
                handles.datatype = 5;
            end
        end
    end
end

handles.prefix = get(handles.edprefix,'String');
handles.postfix = get(handles.edpostfix,'String');
 
%%Read Input for single file
    
if handles.filetype == 1
    PathName = handles.pathname;
    FileName = handles.filename;
    filename = strcat(PathName,FileName);
    [filepath,name,ext] = fileparts(filename);

    if (handles.datatype == 1)||(handles.datatype == 2) %%Raw ECG or IBI
        if ext == '.txt'
           fileID = fopen([PathName '/' FileName],'r');
           signal = textscan(fileID,'%f');
           data = signal{1};
        else
            if ext == '.csv'
                data = xlsread([PathName '/' FileName]);
                %%%If user open ECG&Peakpos file here
                if size(data,2)==2
                    data = data(:,1);
                end
            end
        end
        %if (handles.datatype == 1)
        %    handles.data = double(1000*data); %%raw ECG, change to mv
        %else
            handles.data = double(data); %%IBI/ECG
        %end
    else
        if (handles.datatype == 5)%%ECG PC data
            ecgpc = xlsread([PathName '/' FileName]);
            handles.data = ecgpc(:,1); %ECG raw
            peakposcol = ecgpc(:,2); %Peak Pos
            handles.peakpos = find(peakposcol == 1);
        else %Kubios MAT file for ECG Raw/IBI
            result = load([PathName '/' FileName]);
            if (handles.datatype == 4)%%Kubios IBI data              
                handles.data = result.Res.HRV.Data.RR;
            else %%Kubios ECG
                handles.data = result.Res.CNT.EKG;%%change to mv
            end
        end
    end
end

%Update HRVParams for Physionet Toolbox
%%Initialization of some basic HRV params using Physionet-Tool-Box function
HRVParams = InitializeHRVparams('');
if get(handles.rbinfant,'Value') == 1
    handles.infant = 1;
    HRVParams.PeakDetect.REF_PERIOD = 0.150; %For fetal ECG
    HRVParams.PeakDetect.ecgType = 'fECG'; %For fetal ECG
    HRVParams.preprocess.lowerphysiolim = 60/300;       % Default: 60/160 for adult (160bpm)
else
    handles.infant = 2;
end

handles.HRVParams = HRVParams;
% Update handles structure
guidata(hObject, handles);

if handles.filetype == 2 %Batch file
    %HRnVm_Settings;
    HRnVm_IniSetConfirm;
else %Single file
    %%Extract patientid from prefix and postfix
    if handles.prefix == ""
        if handles.postfix ~= ""
            fileID = extractBefore(handles.filename,handles.postfix);
        else
            fileID = handles.filename; %%No prefix and postfix
        end
    else
        if handles.postfix == ""
            fileID = extractAfter(handles.filename,handles.prefix);
        else
            fileID = extractBetween(handles.filename,handles.prefix,handles.postfix);
        end
    end
    if isempty(fileID) %%Wrong input of prefix and postfix lead to fail extraction
        fileID = handles.filename;
    else
        if iscell(fileID) %%Extractbetween seems generate the cell contains the chars
            fileID = fileID{1};
        end
    end
    handles.patientID = fileID;
    
   
    % Update handles structure
    guidata(hObject, handles);

%     if (handles.datatype == 2)||(handles.datatype == 4) %%IBI file
%         HRnVm_Settings;
%     else %%ECG Raw
%         PreProcess;
%     end
    HRnVm_IniSetConfirm;
end



% --- Executes on button press in btopen.
function btopen_Callback(hObject, eventdata, handles)
% hObject    handle to btopen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (get(handles.rbecg,'Value')==1)
    handles.datatype = 1; %ECG raw
else
    if (get(handles.rbibi,'Value')==1)
        handles.datatype = 2; %IBI
    else
       if (get(handles.rbkecg,'Value')==1)
            handles.datatype = 3;%% Kubios MAT ECG
       else
            if (get(handles.rbkibi,'Value')==1)
                handles.datatype = 4;%% Kubios MAT IBI
            else
                handles.datatype = 5;%% ECG Peak Check (PC)
            end
       end
    end
end

if (get(handles.rbsingle,'Value')==1)
    handles.filetype = 1; %Single file
else
    handles.filetype = 2; %Batch files
end
    
if (handles.filetype == 1) %%Single File
    
    if (handles.datatype == 1) %%Raw ECG File
        [FileName,PathName] = uigetfile('*.*','Please select ECG Raw Data File *.csv or *.txt');
    else %%IBI File
        if (handles.datatype == 2) %%IBI File
            [FileName,PathName] = uigetfile('*.*','Please select IBI Data File *.csv or *.txt');
        else
            if (handles.datatype == 5) %%ECG PC File
                [FileName,PathName] = uigetfile('*.csv','Please select IBI Data File *.csv');
            else
                [FileName,PathName] = uigetfile('*.mat','Select MAT File');
            end
        end
    end

    handles.filename = FileName; %%Save filename to handle
    handles.pathname = PathName; %%Save pathname to handle
    
    filename = strcat(PathName,FileName);
    set(handles.edpos,'String',filename);
else
    foldername = uigetdir('D:\');
    set(handles.edpos,'String',foldername);
    handles.foldername = foldername;
end
guidata(hObject,handles);
set(handles.btnext,'Enable','on');


function edpos_Callback(hObject, eventdata, handles)
% hObject    handle to edpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edpos as text
%        str2double(get(hObject,'String')) returns contents of edpos as a double


% --- Executes during object creation, after setting all properties.
function edpos_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edpos (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edprefix_Callback(hObject, eventdata, handles)
% hObject    handle to edprefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edprefix as text
%        str2double(get(hObject,'String')) returns contents of edprefix as a double


% --- Executes during object creation, after setting all properties.
function edprefix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edprefix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edpostfix_Callback(hObject, eventdata, handles)
% hObject    handle to edpostfix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edpostfix as text
%        str2double(get(hObject,'String')) returns contents of edpostfix as a double


% --- Executes during object creation, after setting all properties.
function edpostfix_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edpostfix (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rbbatch.
function rbbatch_Callback(hObject, eventdata, handles)
% hObject    handle to rbbatch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbbatch
%%Batch can only do IBI%%
if get(handles.rbbatch,'Value') == 1
    set(handles.rbecgpc,'Enable','off');
    set(handles.rbecg,'Enable','off');
    %%Temporary
    %%set(handles.rbecg,'Enable','on');  
    set(handles.rbkecg,'Enable','off');
    set(handles.rbibi,'Value',1);
    set(handles.edpos,'String','');
%% chenglin mod, disable fs for RRIs
    set(handles.rb125,'Enable','off');
    set(handles.rb250,'Enable','off');
    set(handles.rbothers,'Enable','off');
    set(handles.edfs,'Enable','off');
%%
end


% --- Executes on button press in rbsingle.
function rbsingle_Callback(hObject, eventdata, handles)
% hObject    handle to rbsingle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbsingle
if get(handles.rbsingle,'Value') == 1
    set(handles.rbecgpc,'Enable','on');
    set(handles.rbecg,'Enable','on');
    set(handles.rbkecg,'Enable','on');
    set(handles.rbecg,'Value',1);
    set(handles.edpos,'String','');
    set(handles.rb125,'Enable','on');
    set(handles.rb250,'Enable','on');
    set(handles.rbothers,'Enable','on');
    set(handles.edfs,'Enable','on');
end



function edfs_Callback(hObject, eventdata, handles)
% hObject    handle to edfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edfs as text
%        str2double(get(hObject,'String')) returns contents of edfs as a double


% --- Executes during object creation, after setting all properties.
function edfs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edfs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rbothers.
function rbothers_Callback(hObject, eventdata, handles)
% hObject    handle to rbothers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbothers
if get(handles.rbothers,'Value') == 1
    set(handles.edfs,'Enable','on');
end


% --- Executes on button press in rb125.
function rb125_Callback(hObject, eventdata, handles)
% hObject    handle to rb125 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb125
if get(handles.rb125,'Value') == 1
    set(handles.edfs,'Enable','off');
end


% --- Executes on button press in rb250.
function rb250_Callback(hObject, eventdata, handles)
% hObject    handle to rb250 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rb250
if get(handles.rb250,'Value') == 1
    set(handles.edfs,'Enable','off');
end


% --- Executes on button press in rbibi.
function rbibi_Callback(hObject, eventdata, handles)
% hObject    handle to rbibi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbibi
%% Chenglin mod, don't need fs for RRI input
if get(handles.rbibi,'Value')==1
    set(handles.rb125,'Enable','off');
    set(handles.rb250,'Enable','off');
    set(handles.rbothers,'Enable','off');
    set(handles.edfs,'Enable','off');
end
    


% --- Executes on button press in rbkibi.
function rbkibi_Callback(hObject, eventdata, handles)
% hObject    handle to rbkibi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbkibi
%% Chenglin mod, don't need fs for RRI input
if get(handles.rbkibi,'Value')==1
    set(handles.rb125,'Enable','off');
    set(handles.rb250,'Enable','off');
    set(handles.rbothers,'Enable','off');
    set(handles.edfs,'Enable','off');
end
    


% --- Executes on button press in rbecg.
function rbecg_Callback(hObject, eventdata, handles)
% hObject    handle to rbecg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbecg
if get(handles.rbecg,'Value')==1
    set(handles.rb125,'Enable','on');
    set(handles.rb250,'Enable','on');
    set(handles.rbothers,'Enable','on');
    set(handles.edfs,'Enable','on');
end


% --- Executes on button press in rbkecg.
function rbkecg_Callback(hObject, eventdata, handles)
% hObject    handle to rbkecg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbkecg
if get(handles.rbkecg,'Value')==1
    set(handles.rb125,'Enable','on');
    set(handles.rb250,'Enable','on');
    set(handles.rbothers,'Enable','on');
    set(handles.edfs,'Enable','on');
end


% --- Executes on button press in rbecgpc.
function rbecgpc_Callback(hObject, eventdata, handles)
% hObject    handle to rbecgpc (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbecgpc
if get(handles.rbecgpc,'Value')==1
    set(handles.rb125,'Enable','on');
    set(handles.rb250,'Enable','on');
    set(handles.rbothers,'Enable','on');
    set(handles.edfs,'Enable','on');
end
