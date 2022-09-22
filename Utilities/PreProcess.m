function varargout = PreProcess(varargin)
%   HRNVMPREPROCESS MATLAB code for hrnvmpreprocess.fig
%      HRNVMPREPROCESS, by itself, creates a new HRNVMPREPROCESS or raises the existing
%      singleton*.
%
%      H = HRNVMPREPROCESS returns the handle to a new HRNVMPREPROCESS or the handle to
%      the existing singleton*.
%
%      HRNVMPREPROCESS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HRNVMPREPROCESS.M with the given input arguments.
%
%      HRNVMPREPROCESS('Property','Value',...) creates a new HRNVMPREPROCESS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PreProcess_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PreProcess_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
%   See also: GUIDE, GUIDATA, GUIHANDLES

%   Edit the above text to modify the response to help hrnvmpreprocess

%   DEPENDENCIES & LIBRARIES:
%       PhysioNet Cardiovascular Signal Toolbox
%       https://physionet.org/content/pcst/1.0.0/
%       https://github.com/cliffordlab/PhysioNet-Cardiovascular-Signal-Toolbox
%
%   REFERENCE: 
%   Chenglin Niu, Dagang Guo et al. HRnV-Calc: A software for heart rate n-variability
%   and heart rate variability analysis
%
%   Vest, A. N., Da Poian, G., Li, Q., Liu, C., Nemati, S., Shah, A. J., & Clifford, G. D. (2018). 
%   An open source benchmarked toolbox for cardiovascular waveform and interval analysis. 
%   Physiological measurement, 39(10), 105004. https://doi.org/10.1088/1361-6579/aae021
%
%   Written by: Dagang Guo(guo.dagang@duke-nus.edu.sg), Chenglin Niu
%   (chenglin.niu@u.duke.nus.edu), Nan Liu(chenglin.niu@u.duke.nus.edu)
%
%	REPO:       
%       https://github.com/nliulab/HRnV-Calc
%   ORIGINAL SOURCE AND AUTHORS:     
%       Written by 
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

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PreProcess_OpeningFcn, ...
                   'gui_OutputFcn',  @PreProcess_OutputFcn, ...
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


% --- Executes just before hrnvmpreprocess is made visible.
function PreProcess_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hrnvmpreprocess (see VARARGIN)

% Choose default command line output for hrnvmpreprocess
handles.output = hObject;

%% Chenglin mod, resize fonts when window resizes
txtHand = findall(handles.HRnVmPreprocess, '-property', 'FontUnits'); 
set(txtHand, 'FontUnits', 'normalized')
%%
%%%Many places needs to set and update peakpos, therefore set to global
global peakpos;

%%Initialization
peakpos = [];

handles.settings.segment = 20; %Segment set as 20 second for display and plot
handles.settings.bfull = 1;%Full file (1) or Segment (0)
handles.popseglen.String = [5 10 15];
handles.popecglen.String = [6 8 10 12 14 16 18 20];
handles.popecgoverlay.String = [1 2 3 4];
handles.popqrslen.String = [5 10 20 30];

%%Initialization
%%set Initial QRS peak display window 
set(handles.popqrslen,'Value',2);

handles.data.ecgsegment = [];
%%%%Save ECG display length%%%
contentslen = get(handles.popecglen,'String'); 
handles.settings.ecglength = str2num(contentslen(get(handles.popecglen,'Value'),:));

%%%%Save ECG segment length for analysis%%%
contentsseglen = get(handles.popseglen,'String'); 
handles.settings.ecgseglen = str2num(contentsseglen(get(handles.popseglen,'Value'),:));

%%%%Set ECG display slider%%%%
contentsoverlay = get(handles.popecgoverlay,'String'); 
handles.settings.ecgoverlay = str2num(contentsoverlay(get(handles.popecgoverlay,'Value'),:));

%%%Get QRS segment length for plot
contentsqrslen = get(handles.popqrslen,'String');
handles.settings.qrslength = str2num(contentsqrslen(get(handles.popqrslen,'Value'),:));

%%Get ECG Data from HRnVmCal
% get the handle of HRnVmCal
hhrnvmcal = findobj('Tag','HRnVmCal');
% if exists (not empty)
if ~isempty(hhrnvmcal)
    % get data handles and other user-defined data associated to hrvmain
    dhhrv = guidata(hhrnvmcal);
    handles.data.ecgraw = dhhrv.data;
    handles.data.origecgraw = dhhrv.data; %To save this in case wavelet denosing applied later
    handles.settings.fs = dhhrv.fs; %Sampling rate
    handles.settings.datatype = dhhrv.datatype;
    handles.filetype = dhhrv.filetype;
    
    if handles.settings.datatype == 5 %%For ECG QC Check
        set(handles.btnewqrs,'Enable','on');
        set(handles.btprocess,'Enable','off');
        peakpos = dhhrv.peakpos;     
    end
    
    %%Set patient ID
    handles.patientID  = dhhrv.patientID;
    set(handles.txtpatientID,'String',handles.patientID);
    
    %%Extract HRVParams
    handles.HRVParams = dhhrv.HRVParams;
    
    %%Close HRnVmCal window once parameters transferred
    close(hhrnvmcal);
end
 
plotspecial(handles,handles.figecg,handles.data.ecgraw,1,1,length(handles.data.ecgraw),1);

if handles.settings.datatype == 5 %%For ECG QC Check
    %Plot first QRS detection segment with 10 x ticks
    peakseg = peakpos(find((peakpos<=handles.settings.qrslength*handles.settings.fs))); %%Get the corresponding indices in this figure
    ecgforpro = handles.data.ecgraw;
    plotspecial(handles,handles.figecgpeak,ecgforpro,1,1,handles.settings.qrslength*handles.settings.fs,0,peakseg);

    qrsslidecountmaxr = length(ecgforpro)/(handles.settings.qrslength*handles.settings.fs);

    if qrsslidecountmaxr == floor(qrsslidecountmaxr)
        qrsslidecountmax = floor(qrsslidecountmaxr);
    else
        qrsslidecountmax = floor(qrsslidecountmaxr)+1;
    end
    %Enable Plot Slider
    set(handles.plotslider,'Enable','on');

    %Disable other checkboxs and radiobutton and only can change peaks
    set(handles.rbsegment,'Enable','off');
    set(handles.cbwavelet,'Enable','off');
    set(handles.btnewqrs,'Enable','on');
    set(handles.btfinishqrs,'Enable','on');

    set(handles.plotslider,'Max',qrsslidecountmax);
    set(handles.plotslider,'Min',1);
    set(handles.plotslider,'SliderStep',[1/(qrsslidecountmax-1) 1]);
    set(handles.plotslider,'Value',1);
end

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes hrnvmpreprocess wait for user response (see UIRESUME)
% uiwait(handles.HRnVmPreprocess);


% --- Outputs from this function are returned to the command line.
function varargout = PreProcess_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



% --- Executes on button press in btprocess.
function btprocess_Callback(hObject, eventdata, handles)
% hObject    handle to btprocess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%Set denoise method,1: Bandpass filter,2:Wavelet, 3?Other, 4: All
%Enale QRS slider
global peakpos;
set(handles.plotslider,'Enable','on');
set(handles.btfinishqrs,'Enable','on');
set(handles.btnewqrs,'Enable','on');

fs = handles.settings.fs;
if handles.settings.bfull == 1
    %Full file
    ecgforpro = handles.data.ecgraw;
else
    %Segment
    ecgforpro = handles.data.ecgsegment;
end

%%save orig ecgforpro for display purpose
origecgforpro = ecgforpro;

if get(handles.cbrsr,'Value') == 1
    ecgforpro = 2* max(ecgforpro) - ecgforpro;
end

seg = handles.settings.qrslength;
sbp = 10;%%Search back and forward 5 samples to check if it is real sample

%%%
%%Peak detection%%

%%Initialization of some basic HRV params using Physionet-Tool-Box function
HRVParams = handles.HRVParams;

%%Set sampling frequency
HRVParams.Fs = fs;

%%Set processed windowlength to be whole ECG signal
HRVParams.windowlength = floor(length(ecgforpro)/fs)+1;

%%Using Physionet run_qrsdet_by_seg, but with one addiontional param '1'
%%to detect the peaks of whole signal, especially, remained QRS peaks of
%%the last segment less then 15 seconds window
jqrs_ann = run_qrsdet_by_seg_revised(ecgforpro,HRVParams);

%Search back and forward to see if this is real peak, if not,
%change
if get(handles.localcheck, 'Value')==1 || get(handles.localcheck, 'Value')==1 %%Chenglin mod, check on users' demand
for i = 1:length(jqrs_ann)
    startcheckpos = jqrs_ann(i)-sbp;
    endcheckpos = jqrs_ann(i)+sbp;
    if endcheckpos > length(ecgforpro)
        endcheckpos = length(ecgforpro);
    end

    if startcheckpos < 1
        startcheckpos = 1;
    end
    ecgcheckseg = ecgforpro(startcheckpos:endcheckpos);
    if ecgforpro(jqrs_ann(i)) < max(ecgcheckseg)
        maxindexr=find(ecgcheckseg==max(ecgcheckseg));
        if length(maxindexr)>1
            maxindex = maxindexr(1);
        else
            maxindex = maxindexr;
        end
        jqrs_ann(i) = maxindex+startcheckpos-1;%%Chenglin mode
    end
end
end

peakpos = jqrs_ann;

%%Remove minus value for peakpos for some case
peakpos (find(peakpos<0))=[];

%Plot first QRS detection segment with 10 x ticks
peakseg = peakpos(find((peakpos<=seg*fs))); %%Get the corresponding indices in this figure


plotspecial(handles,handles.figecgpeak,origecgforpro,handles.settings.bfull,1,seg*fs,0,peakseg);

qrsslidecountmaxr = length(ecgforpro)/(fs*seg);

if qrsslidecountmaxr == floor(qrsslidecountmaxr)
    qrsslidecountmax = floor(qrsslidecountmaxr);
else
    qrsslidecountmax = floor(qrsslidecountmaxr)+1;
end

set(handles.plotslider,'Max',qrsslidecountmax);
set(handles.plotslider,'Min',1);
set(handles.plotslider,'SliderStep',[1/(qrsslidecountmax-1) 1]);
set(handles.plotslider,'Value',1);

guidata(hObject,handles);
    
% --- Executes on button press in rball.
function rball_Callback(hObject, eventdata, handles)
% hObject    handle to rball (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rball
if get(hObject,'Value')==1
    set(handles.rbsegment,'Value',0);
end

% --- Executes on slider movement.
function plotslider_Callback(hObject, eventdata, handles)
% hObject    handle to plotslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global peakpos;
pos = round(get(hObject,'Value'));

fs = handles.settings.fs;
seg = handles.settings.qrslength;
if handles.settings.bfull == 0
    ecgseg = handles.data.ecgsegment;
else
    ecgseg = handles.data.ecgraw;%%Full file
end

startpos = (seg*(pos-1))*fs+1;
endpos = seg*pos*fs;

if endpos > length(ecgseg)
    endpos = length(ecgseg);
end
       

peakseg = peakpos(find((peakpos<=seg*pos*fs)&(peakpos>(seg*(pos-1))*fs)))...
-(seg*(pos-1))*fs; %%%%Get the corresponding indices in this figure

%%special case?last page only have one point that do not need to plot
if startpos ~= endpos
    if isempty(peakseg) 
        plotspecial(handles,handles.figecgpeak,ecgseg,handles.settings.bfull,startpos,endpos,0);
    else
        plotspecial(handles,handles.figecgpeak,ecgseg,handles.settings.bfull,startpos,endpos,0,peakseg);
    end
end
    

% --- Executes during object creation, after setting all properties.
function plotslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to plotslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in btremove.
function btremove_Callback(hObject, eventdata, handles)
% hObject    handle to btremove (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global peakpos;
%%Wait until user choose the proper orignal peak
bcycle = 1;

sliderpos = round(get(handles.plotslider,'Value'));
seg = handles.settings.qrslength;

if handles.settings.bfull == 0
    ecgseg = handles.data.ecgsegment;
else
    ecgseg = handles.data.ecgraw;
end

fs = handles.settings.fs;

startpos = (seg*(sliderpos-1))*fs+1;
endpos = seg*sliderpos*fs;

if endpos > length(ecgseg)
    endpos = length(ecgseg);
end
       
peakseg = peakpos(find((peakpos<=seg*sliderpos*fs)&(peakpos>(seg*(sliderpos-1))*fs)))...
-(seg*(sliderpos-1))*fs;

prepeaknums = length(peakpos(find(peakpos<=(seg*(sliderpos-1))*fs)));

while bcycle==1
    [xi,yi] = getpts(handles.figecgpeak);
    for i=1:length(peakseg)
        if abs(xi-peakseg(i)-(seg*(sliderpos-1))*fs) < 10           
            %remove peakseg and update peakpos
            peakseg(i)=[];
            peakpos(prepeaknums+i)=[];
            %Replot and then delete old peak pos
            if isempty(peakseg) 
                plotspecial(handles,handles.figecgpeak,ecgseg,handles.settings.bfull,startpos,endpos,0);
            else
                plotspecial(handles,handles.figecgpeak,ecgseg,handles.settings.bfull,startpos,endpos,0,peakseg);
            end
            break; 
        end
    end  
              
    ax = gca;
    fig = ancestor(ax, 'figure');
    sel = get(fig, 'SelectionType');
    if strcmpi(sel, 'alt')
        break;
    end
end

handles.data.peakpos = peakpos; %update peakpos after delete
guidata(hObject,handles);


% --- Executes on button press in btadd.
function btadd_Callback(hObject, eventdata, handles)
% hObject    handle to btadd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%Wait until user choose the proper orignal peak
global peakpos;
bcycle = 1;

sliderpos = round(get(handles.plotslider,'Value'));
seg = handles.settings.qrslength;
if handles.settings.bfull == 0
    ecgseg = handles.data.ecgsegment;
else
    ecgseg = handles.data.ecgraw;
end

fs = handles.settings.fs;

startpos = (seg*(sliderpos-1))*fs+1;
endpos = seg*sliderpos*fs;

if endpos > length(ecgseg)
    endpos = length(ecgseg);
end

peakseg = peakpos(find((peakpos<=seg*sliderpos*fs)&(peakpos>(seg*(sliderpos-1))*fs)))...
-(seg*(sliderpos-1))*fs;

prepeaknums = length(peakpos(find(peakpos<=(seg*(sliderpos-1))*fs)));

%%%To plot out all points in o for easy selection of peaks

while bcycle==1
    
    %%Once click right button, stop selection
    ax = gca;
    fig = ancestor(ax, 'figure');
    sel = get(fig, 'SelectionType');
    if strcmpi(sel, 'alt')
        break;
    end
    
    [xi,yi] = getpts(handles.figecgpeak);
    
    if get(handles.cbrsr,'Value') == 1
       answer = questdlg('Confirm to add this SRS peak?', ...
        'Add SRS Peak Menu', ...
        'YES','NO','YES');
    else
       answer = questdlg('Confirm to add this QRS peak?', ...
        'Add QRS Peak Menu', ...
        'YES','NO','YES');
    end


    % Handle response
    
    selpos = round(xi(length(xi))); %%Only use the position of last selection/double click position
    
    startsegpos = selpos-10;
    posshift = 11;
    if startsegpos<1
        startsegpos = 1;
        posshift = 1;
    end
    
    endsegpos = selpos+10;
    if selpos+10>length(ecgseg)
        endsegpos = length(ecgseg);
    end
    
    selecgseg = ecgseg(startsegpos:endsegpos);%Only select nearby ecg segment (+-10) for later find QRS peak to add
    %    %%Search the nearby QRS peak by 10 and find the real peak nearby --- some are pure noise
    %pospeak = find(selecgseg == max(selecgseg));
    if get(handles.cbrsr,'Value') == 1 %%For RSR need to select minimum
        selecgseg = 2*max(selecgseg)-selecgseg;
    end
    
    [pks,locs] = findpeaks(selecgseg);
    minselecgseg = min(selecgseg);
    
    %%To avoid sharp noise change original minimal value of nearby
    %%peaks and find real minimal value
    selecgseg1 = selecgseg;
    while abs(mean(pks)-minselecgseg)>5*abs(mean(pks)-mean(selecgseg))
          minselloc = find(selecgseg1 == minselecgseg); 
          selecgseg1(minselloc) = [];
          minselecgseg = min(selecgseg1);
    end
    
    pointpossel=[];
    sumpkvalue = 0;
    k=1;%count for local maximum

    lastpeak = length(find(peakpos < selpos));
    if lastpeak>=1 %%In case that from start is too noisy to detect the peaks
        %%Get the amplitude of average 4 recent peaks by max-min, backward 2 and forward 2
        pksegstart = lastpeak-1;
        pksegend = lastpeak+2;
        if pksegstart < 1
            pksegstart = 1;
        end

        if pksegend > length(peakpos)
            pksegend = length(peakpos);
        end

        for j=pksegstart:pksegend
            nearbypeakstart = peakpos(j)-5;
            nearbypeakend = peakpos(j)+5;
            if nearbypeakstart<1
                nearbypeakstart = 1;
            end
            if nearbypeakend>length(ecgseg)
                nearbypeakend = length(ecgseg);
            end
            
            evalecgseg = ecgseg(nearbypeakstart:nearbypeakend);
            
            if get(handles.cbrsr,'Value') == 1 %%For RSR
                evalecgseg = 2*max(evalecgseg)-evalecgseg;
            end
            
            minnearpeak = min(evalecgseg);
            
            evalecgseg1 = evalecgseg;
            
            %%To avoid sharp noise change original minimal value of nearby
            %%peaks and find real minimal value
            while abs(evalecgseg(peakpos(j)-nearbypeakstart+1)-minnearpeak)>5*abs(evalecgseg(peakpos(j)-nearbypeakstart+1)-mean(evalecgseg1))
                  minloc = find(evalecgseg1 == minnearpeak); 
                  evalecgseg1(minloc) = [];
                  minnearpeak = min(evalecgseg1);
            end
            
            sumpkvalue = sumpkvalue+evalecgseg(peakpos(j)-nearbypeakstart+1)-minnearpeak;
            
        end
        avgpkvalue = sumpkvalue/(pksegend-pksegstart+1);

        for i=1:length(pks)
            if abs(pks(i)-minselecgseg-avgpkvalue)/avgpkvalue < 2 %set +/-200% as noise threshold
                pointpossel(k) = locs(i)+selpos-posshift;
                localmaxsel(k) = abs(pks(i)-minselecgseg);
                k = k + 1;
            end
        end
    else
        for i=1:length(pks)
            pointpossel(k) = locs(i)+selpos-posshift;
            localmaxsel(k) = abs(pks(i)-minselecgseg);
            k = k + 1;
        end 
    end


    %pointpossel = find(selecgseg == max(selecgseg))+selpos-posshift;
    if isempty(pointpossel)    %%For bad signal quality,the fluctutation maybe more than 50%
        %pointpos = find(selecgseg == max(selecgseg))+selpos-posshift;
        warndlg('Here has no distinct QRS/RSR peak!','Failed to add QRS/RSR peak');
        break;
    else
        pointpos = pointpossel(find(localmaxsel==max(localmaxsel)));%add the peak instead of other local maximum
        k = 1;%reset k
    end
    
    
    switch answer
        case 'YES'
            
             %%Find if pointpos is appropriate by checking if left and right has QRS peaks,
            %%if so, should pump out the alert
            if ~isempty(find(peakseg < (pointpos-seg*(sliderpos-1)*fs)))%%not the leftmost peak
                if length(find(peakseg < (pointpos-seg*(sliderpos-1)*fs))) < length(peakseg)-1 %%and not the right most peak,middle peak
                    leftpkpos = peakseg(length(find(peakseg < (pointpos-seg*(sliderpos-1)*fs))));
                    rightpkpos = peakseg(length(find(peakseg < (pointpos-seg*(sliderpos-1)*fs)))+1); %right peak next to left peak
                    if (abs(pointpos-seg*(sliderpos-1)*fs-leftpkpos)<(0.15*fs))||(abs(pointpos-seg*(sliderpos-1)*fs-rightpkpos)<(0.15*fs))
                        warndlg('There is existing QRS/RSR peak nearby!','Wrong selection of QRS/RSR peak');
                        break;
                    end
                else %rightmost peak
                    if length(peakseg)>1
                        leftpkpos = peakseg(length(peakseg)-1);
                    else
                        %%Speicial case, rightmost but left only has one (added
                        %%just now or just has one peak detected                       
                        leftpkpos = peakseg;
                    end
                    if abs(pointpos-seg*(sliderpos-1)*fs-leftpkpos)<(0.15*fs)
                        warndlg('There is existing QRS/RSR peak LEFT nearby!','Wrong selection of QRS/RSR peak');
                        break;
                    end
                end
           else %leftmost peak
               if length(find(peakseg < (pointpos-seg*(sliderpos-1)*fs))) < length(peakseg)-1
                    rightpkpos = peakseg(1); %right peak next to left peak
                    if abs(pointpos-seg*(sliderpos-1)*fs-rightpkpos)<(0.15*fs)
                        warndlg('There is existing QRS/RSR peak RIGHT nearby!','Wrong selection of QRS/RSR peak');
                        break;
                    end
               else
               %%Special case, ECG peaks undetected for whole segment because
               %%of previous or following large noise, which means is
               %%leftmost and also rightmost peak
               %%Or the peaks in this segment is all removed, then this
               %%peak should be the 1st and also leftmost/rightmost peak to
               %%be added. Do nothing here
                    test = 1;
               end
            end
           
           if size(peakseg,1)<size(peakseg,2)
               peakseg = peakseg';
           end

           if size(peakpos,1)<size(peakpos,2)
               peakpos = peakpos';
           end  
               
           if ~isempty(peakseg)
               insertpos = length(find(peakseg < (pointpos-seg*(sliderpos-1)*fs)));%Insert pos
           else
               %special case
               insertpos = 0;
           end
            
          
            if insertpos == 0%Insert to 1st position
                if ~isempty(peakseg)
                    peakseg = cat(1,pointpos-seg*(sliderpos-1)*fs,peakseg(1:length(peakseg)));
                else
                    peakseg = pointpos-seg*(sliderpos-1)*fs;
                end
                if sliderpos == 1 %means first overall QRS peak
                   peakpos = cat(1,pointpos,peakpos);
                else
                   if prepeaknums == length(peakpos) %%Special case, that all behind signals are noise and does not have peaks
                        peakpos = cat(1,peakpos(1:prepeaknums),pointpos);
                   else
                        peakpos = cat(1,peakpos(1:prepeaknums),pointpos,peakpos(prepeaknums+1:length(peakpos)));
                   end
                end
            else
                if insertpos == length(peakseg) %Insert to last position
                    peakseg=cat(1,peakseg(1:length(peakseg)),pointpos-seg*(sliderpos-1)*fs);
                    if sliderpos == get(handles.plotslider, 'max') %means last overall QRS peak
                        peakpos = cat(1,peakpos,pointpos);
                    else
                        %%peakseg already add 1, therefore the position
                        %%need to minus one
                        peakpos = cat(1,peakpos(1:prepeaknums+length(peakseg)-1),pointpos,peakpos(prepeaknums+length(peakseg):length(peakpos)));
                    end
                else %Insert to middle
                    peakseg = cat(1,peakseg(1:insertpos),pointpos-seg*(sliderpos-1)*fs,peakseg(insertpos+1:length(peakseg)));
                    peakpos = cat(1,peakpos(1:prepeaknums+insertpos),pointpos,peakpos(prepeaknums+insertpos+1:length(peakpos)));
                end
            %peakpos(prepeaknums+i)=[];
            end
            %Replot for add in new peak pos
%              reset(handles.figecgpeak);
%              plot(handles.figecgpeak,ecgtime,ecgseg(ecgtime),'-o','MarkerIndices',peakseg,...
%         'MarkerFaceColor','red','MarkerSize',6);
            plotspecial(handles,handles.figecgpeak,ecgseg,handles.settings.bfull,startpos,endpos,0,peakseg);
            break;
        case 'NO'
            break;
    end
    
end

handles.data.peakpos = peakpos; %update peakpos after delete
guidata(hObject,handles);


% --- Executes on slider movement.
function ecgslider_Callback(hObject, eventdata, handles)
% hObject    handle to ecgslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

%Disable end point selection
set(handles.btendpoint,'Enable','off');

pos = round(get(hObject,'Value'));

fs = handles.settings.fs;
seg = handles.settings.ecglength;
overlay = handles.settings.ecgoverlay;

startpos = (overlay*(pos-1))*60*fs+1;
endpos = ((overlay*(pos-1))+seg)*60*fs;
if endpos > length(handles.data.ecgraw)
    endpos = length(handles.data.ecgraw);
end

plotspecial(handles,handles.figecg,handles.data.ecgraw,handles.settings.bfull,startpos,endpos,1);
      
% plot(handles.figecg,ecgtime,handles.data.ecgraw(ecgtime));
% 
% xlim(handles.figecg,[(overlay*(pos-1))*60*fs+1 ((overlay*(pos-1))+seg)*60*fs]);
% xticks(handles.figecg,tickpos);
% xticklabels(handles.figecg,cellstr(string(ticklabel)));
% a = get(gca,'XTickLabel');
% set(gca,'XTickLabel',a,'FontName','Times','fontsize',10);


% --- Executes during object creation, after setting all properties.
function ecgslider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ecgslider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on selection change in popecglen.
function popecglen_Callback(hObject, eventdata, handles)
% hObject    handle to popecglen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popecglen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popecglen
contentslen = get(handles.popecglen,'String');
handles.settings.ecglength = str2num(contentslen(get(handles.popecglen,'Value'),:));

if length(handles.data.ecgraw)< handles.settings.ecglength * handles.settings.fs * 60
    plotecgendindex = length(handles.data.ecgraw);
else
    plotecgendindex = handles.settings.ecglength * handles.settings.fs * 60;
end
     
plotspecial(handles,handles.figecg,handles.data.ecgraw,handles.settings.bfull,1,plotecgendindex,1);
%%Update slider
slidecountmaxr = length(handles.data.ecgraw)/(handles.settings.fs * 60 * handles.settings.ecgoverlay);

if slidecountmaxr == floor(slidecountmaxr)
    slidecountmax = floor(slidecountmaxr);
else
    slidecountmax = floor(slidecountmaxr)+1;
end
set(handles.ecgslider,'Max',slidecountmax);
set(handles.ecgslider,'Min',1);
set(handles.ecgslider,'SliderStep',[1/(slidecountmax-1) 1]);
set(handles.ecgslider,'Value',1);

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popecglen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popecglen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popecgoverlay.
function popecgoverlay_Callback(hObject, eventdata, handles)
% hObject    handle to popecgoverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popecgoverlay contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popecgoverlay
contentsoverlay = get(handles.popecgoverlay,'String'); 
handles.settings.ecgoverlay = str2num(contentsoverlay(get(handles.popecgoverlay,'Value'),:));

if length(handles.data.ecgraw)< handles.settings.ecglength * handles.settings.fs * 60
    plotecgendindex = length(handles.data.ecgraw);
else
    plotecgendindex = handles.settings.ecglength * handles.settings.fs * 60;
end

%Replot
plotspecial(handles,handles.figecg,handles.data.ecgraw,handles.settings.bfull,1,plotecgendindex,1);

%%Update slider
slidecountmaxr = length(handles.data.ecgraw)/(handles.settings.fs * 60 * handles.settings.ecgoverlay);

if slidecountmaxr == floor(slidecountmaxr)
    slidecountmax = floor(slidecountmaxr);
else
    slidecountmax = floor(slidecountmaxr)+1;
end
set(handles.ecgslider,'Max',slidecountmax);
set(handles.ecgslider,'Min',1);
set(handles.ecgslider,'SliderStep',[1/(slidecountmax-1) 1]);
set(handles.ecgslider,'Value',1);

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popecgoverlay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popecgoverlay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in rbfull.
function rbfull_Callback(hObject, eventdata, handles)
% hObject    handle to rbfull (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbfull
if get(hObject,'Value') == 1
    set(handles.popecglen,'Enable','off');
    set(handles.popseglen,'Enable','off');
    set(handles.popecgoverlay,'Enable','off');
    set(handles.btselstart,'Enable','off');
    set(handles.ecgslider,'Enable','off');
    set(handles.plotslider,'Enable','off');

    set(handles.rbsegment,'Value',0);
    
    reset(handles.figecgpeak);
    
    handles.data.ecgraw = handles.data.origecgraw;
    handles.settings.bfull = 1;
    
    %plot(handles.figecg,1:length(handles.data.ecgraw),handles.data.ecgraw);
    plotspecial(handles,handles.figecg,handles.data.ecgraw,handles.settings.bfull,1,length(handles.data.ecgraw),1);
    
    guidata(hObject,handles);
end





% --- Executes on button press in rbsegment.
function rbsegment_Callback(hObject, eventdata, handles)
% hObject    handle to rbsegment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rbsegment
if get(hObject,'Value') == 1
    % Enable all popmenu  
    set(handles.popecglen,'Enable','on');
    set(handles.popseglen,'Enable','on');
    set(handles.popecgoverlay,'Enable','on');
    set(handles.btselstart,'Enable','on');
    set(handles.ecgslider,'Enable','on');

    set(handles.rbfull,'Value',0);
    
    handles.settings.bfull = 0;
    
    contentslen = get(handles.popecglen,'String');
    handles.settings.ecglength = str2num(contentslen(get(handles.popecglen,'Value'),:));
    
    if length(handles.data.ecgraw)< handles.settings.ecglength * handles.settings.fs * 60
        %warndlg('ECG signal length is shorter than display duration!','Display Duration Setting Error!');
        plotendindex = length(handles.data.ecgraw);
    else
%         plot(handles.figecg,1:length(plotecg),plotecg);
        
%         plotspecial(handles.figecg,plotecg,handles.settings.ecglength/10,0,...
%             handles.settings.ecglength * handles.settings.fs * 60,1);
        plotendindex = handles.settings.ecglength * handles.settings.fs * 60;
    end
    
    plotspecial(handles,handles.figecg,handles.data.ecgraw,handles.settings.bfull,1,plotendindex,1);
    
    plotecg = handles.data.ecgraw(1:plotendindex);
    handles.data.ecgseg = plotecg;

end

%%%%Save ECG segment length for analysis%%%
contentsseglen = get(handles.popseglen,'String'); 
handles.settings.ecgseglen = str2num(contentsseglen(get(handles.popseglen,'Value'),:));

%%%%Set ECG display slider%%%%
contentsoverlay = get(handles.popecgoverlay,'String'); 
handles.settings.ecgoverlay = str2num(contentsoverlay(get(handles.popecgoverlay,'Value'),:));

slidecountmaxr = length(handles.data.ecgraw)/(handles.settings.fs * 60 * handles.settings.ecgoverlay);

if slidecountmaxr == floor(slidecountmaxr)
    slidecountmax = floor(slidecountmaxr);
else
    slidecountmax = floor(slidecountmaxr)+1;
end
set(handles.ecgslider,'Max',slidecountmax);
set(handles.ecgslider,'Min',1);
set(handles.ecgslider,'SliderStep',[1/(slidecountmax-1) 1]);

guidata(hObject,handles);


% --- Executes on selection change in popseglen.
function popseglen_Callback(hObject, eventdata, handles)
% hObject    handle to popseglen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popseglen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popseglen

if length(handles.data.ecgraw)< handles.settings.ecgseglen * handles.settings.fs * 60
    %%Set back to 5 minutes
    set(handles.popseglen,'Value',1);
    warndlg('ECG signal length is shorter than segment duration!','Setting Error!')
end

%%%%Save ECG segment length for analysis%%%
contentsseglen = get(handles.popseglen,'String'); 
handles.settings.ecgseglen = str2num(contentsseglen(get(handles.popseglen,'Value'),:));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function popseglen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popseglen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in btselstart.
function btselstart_Callback(hObject, eventdata, handles)
% hObject    handle to btselstart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

seg = handles.settings.ecgseglen;
displayseg = handles.settings.ecglength;
overlay = handles.settings.ecgoverlay;
fs = handles.settings.fs;
ecgraw = handles.data.ecgraw;
bcycle = 1;
pos = get(handles.ecgslider,'Value');
startpos = (overlay*(pos-1))*60*fs+1;

%%display end pos
enddisplaypos = ((overlay*(pos-1))+displayseg)*60*fs;
%%Signal end pos
endpos = length(handles.data.ecgraw);



while bcycle==1
    
    %%Once click right button, stop selection
    ax = gca;
    fig = ancestor(ax, 'figure');
    sel = get(fig, 'SelectionType');
    if strcmpi(sel, 'alt')
        break;
    end
    
    [xi,yi] = getpts(handles.figecg);
    
   
    answer = questdlg('Confirm to select this start point for ECG segment?', ...
	'ECG Segment Selection Menu', ...
	'YES','NO','YES');
    % Handle response
    
    selpos = round(xi(length(xi))); %%Only use the position of last selection/double click position
   
    switch answer
        case 'YES'         
            set(handles.btendpoint,'Enable','on');
            %Enable clear button to clear selected start/end points
            set(handles.btclear,'Enable','on');

            insertpos = selpos- startpos + 1;%Insert pos
            endpointpos = selpos- startpos + seg*fs*60;
            
            if endpointpos + startpos > endpos
                warndlg('The rest ECG is less then required segment duration!','Wrong display duration!');
                break;
            else
                if endpointpos + startpos > enddisplaypos
                    warndlg('Please revise display duration first!','Wrong selection!');
                    break;
                end
            end
            %Replot for add in new peak pos
%             reset(handles.figecg);
%             plot(handles.figecg,ecgtime,ecgraw(ecgtime),'-o','MarkerIndices',insertpos,...
%         'MarkerFaceColor','red','MarkerSize',6);
            hold on;
            plot(handles.figecg,insertpos+startpos,ecgraw(insertpos+startpos),'-o', ...
                'MarkerFaceColor','red','MarkerEdgeColor','red','MarkerSize',6);
            hold on;
            plot(handles.figecg,endpointpos+startpos,ecgraw(endpointpos+startpos),'-o', ...
                'MarkerFaceColor','green','MarkerEdgeColor','green','MarkerSize',6);
            hold off;
%             xlim(handles.figecg,[startpos endpos]);
%             xticks(handles.figecg,tickpos);
%             xticklabels(handles.figecg,cellstr(string(ticklabel)));
%             a = get(gca,'XTickLabel');
%             set(gca,'XTickLabel',a,'FontName','Times','fontsize',10);
            
            handles.data.ecgsegment = ecgraw(insertpos+startpos:endpointpos+startpos);
            %save a copy
            handles.data.origecgsegment = handles.data.ecgsegment;
            break;
        case 'NO'
            break;
    end
end

guidata(hObject,handles);


% --- Executes on button press in btendpoint.
function btendpoint_Callback(hObject, eventdata, handles)
% hObject    handle to btendpoint (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

ecgseg = handles.data.ecgsegment;

%plot ECG segment for QRS peak analysis and selection
plotspecial(handles,handles.figecg,ecgseg,1,1,length(ecgseg),1); %Here is special, to plot as full signal
guidata(hObject,handles);



% --- Executes on selection change in popqrslen.
function popqrslen_Callback(hObject, eventdata, handles)
% hObject    handle to popqrslen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popqrslen contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popqrslen
%%%Get QRS segment length for plot
global peakpos;
contentsqrslen = get(handles.popqrslen,'String');
handles.settings.qrslength = str2num(contentsqrslen(get(handles.popqrslen,'Value'),:));
%if (~isempty(handles.data.ecgsegment))&&(~isempty(handles.data.peakpos))
if handles.settings.bfull == 0
    ecgseg = handles.data.ecgsegment;
else
    ecgseg = handles.data.ecgraw;
end

if ~isempty(peakpos)
    peakseg = peakpos(find((peakpos<=handles.settings.qrslength*handles.settings.fs))); %%Get the corresponding indices in this figure
    plotspecial(handles,handles.figecgpeak,ecgseg,handles.settings.bfull,1,handles.settings.qrslength*handles.settings.fs,0,peakseg); 

    %Enable slider if not enabled
    set(handles.plotslider,'Enable','on');
    qrsslidecountmaxr = length(ecgseg)/(handles.settings.qrslength*handles.settings.fs);

    if qrsslidecountmaxr == floor(qrsslidecountmaxr)
        qrsslidecountmax = floor(qrsslidecountmaxr);
    else
        qrsslidecountmax = floor(qrsslidecountmaxr)+1;
    end

    set(handles.plotslider,'Max',qrsslidecountmax);
    set(handles.plotslider,'Min',1);
    set(handles.plotslider,'SliderStep',[1/(qrsslidecountmax-1) 1]);
    set(handles.plotslider,'Value',1);
end

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function popqrslen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popqrslen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%%The function used for plot full/partial ecg data with or without marker
function plotspecial(handles,hfig,ecg,bfull,startindex,endindex,bmin,markerindex)
%%hobject: handles to figure, 
%%ecg: data for plot
%%ticknum: total ticknumbers
%%firstvalue: for segment/partial plot
%%bmin: unit in minutes or seconds
if bfull == 1
    ecglength = length(ecg);
else
    ecglength = handles.settings.ecglength; %For display
    ecgseg = handles.settings.qrslength; %qrs segment length in seconds
end

fs = handles.settings.fs;

if bmin == 1
    samplenum = fs*60;
else
    samplenum = fs;
end

ticktinterval = round((endindex-startindex)/(10*samplenum));

if ticktinterval == 0
    ticktinterval = 1; %Least interval is either 1 min or 1 second
end

endplotindex = endindex;%For signal plot

if (bfull == 0)&&((endindex-startindex)< samplenum*ecglength)
    if bmin == 1
        endindex = startindex + samplenum * ecglength;
    else
        endindex = startindex + samplenum * ecgseg;
    end   
end

ticknum = floor((endindex-startindex+1)/(samplenum*ticktinterval))+1;

tickpos(1) = startindex;
tickpos(2:ticknum) = startindex + (1:ticknum-1)* samplenum * ticktinterval-1;

if startindex == 1
    ticklabel(1) = 0;
else
    ticklabel(1) = (startindex-1)/ samplenum;
end

ticklabel(2:ticknum) = ticklabel(1)+(1:ticknum-1)*ticktinterval;

%plot ECG segment for QRS peak analysis and selection
reset(hfig);
switch nargin
    case 7
        plot(hfig,startindex:endplotindex,ecg(startindex:endplotindex));
    case 8
        %%in some cases, marker index < 0;
        plot(hfig,startindex:endplotindex,ecg(startindex:endplotindex),'-o','MarkerIndices',markerindex,...
    'MarkerFaceColor','red','MarkerSize',6);
end
xlim(hfig,[startindex endindex]);

if bmin == 1
    set(get(handles.figecg, 'xlabel'), 'string', 'Minutes'); 
else
    set(get(handles.figecgpeak, 'xlabel'), 'string', 'Seconds'); 
end
xticks(hfig,tickpos);
xticklabels(hfig,cellstr(string(ticklabel)));
a = get(gca,'XTickLabel');
set(gca,'XTickLabel',a,'FontName','Times','fontsize',10);


% --- Executes on button press in btfinishqrs.
function btfinishqrs_Callback(hObject, eventdata, handles)
% hObject    handle to btfinishqrs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%Define a global variable to save ibi value
global peakpos;
%%Save peakpos as vector
if size(peakpos,2)>size(peakpos,1)
    peakpos = peakpos';
end

%%Save ibi as vector
handles.ibi = diff(peakpos/handles.settings.fs);

if handles.settings.bfull == 0
    handles.ecgdata = handles.data.ecgsegment;
else
    handles.ecgdata = handles.data.ecgraw;
end

if size(handles.ecgdata,2)>size(handles.ecgdata,1)
    handles.ecgdata = handles.ecgdata';
end

ecglength = round(length(handles.ecgdata)/(60*handles.settings.fs));%%In minutes

%%IBI File Saving
defibiname = cat(2,char(handles.patientID),'_',num2str(ecglength),'mins_ibi');
[outputFileName,outputPathName] = uiputfile('*.csv','Save the processed IBI results to:',defibiname);
fullFileName = fullfile(outputPathName, outputFileName);
csvwrite(fullFileName,handles.ibi);

%%PC File Saving 
defpcname = cat(2,char(handles.patientID),'_',num2str(ecglength),'mins_ECG&Peakpos');
[outputpcFileName,outputpcPathName] = uiputfile('*.csv','Save the processed IBI results to:',defpcname);
fullpcFileName = fullfile(outputpcPathName, outputpcFileName);

ecgpeakpos =  zeros(length(handles.ecgdata),1);
ecgpeakpos(peakpos) = 1;
ecgpc(:,1) = handles.ecgdata;
ecgpc(:,2) = ecgpeakpos';
csvwrite(fullpcFileName,ecgpc);

guidata(hObject,handles);
%%Call HRnVm Parameters Setting
HRnVm_Params_Settings;

% --- Executes on button press in cbwavelet.
function cbwavelet_Callback(hObject, eventdata, handles)
% hObject    handle to cbwavelet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbwavelet
if get(hObject,'Value') == 1
    if ~isempty(handles.data.ecgsegment)
        ecg = handles.data.ecgsegment;
    else
        ecg = handles.data.ecgraw;
    end
    %w=50/(250/2);
    %bw=w;
    %[num,den]=iirnotch(w,bw); % notch filter implementation 
    %ecg_notch=filter(num,den,ecg);
    [e,f]=wavedec(ecg,10,'db6');% Wavelet implementation
    g=wrcoef('a',e,f,'db6',8); 
    ecg_wave=ecg-g; % subtracting 10th level aproximation signal
                   %from original signal 
                   
  
    %For KKH signal,change to >0
    denoiseecg = ecg_wave + abs(min(ecg_wave));

    if ~isempty(handles.data.ecgsegment)
        handles.data.ecgsegment = denoiseecg;
    else
        handles.data.ecgraw = denoiseecg;
    end
else
    if ~isempty(handles.data.ecgsegment)
        handles.data.ecgsegment = handles.data.origecgsegment;
    else
        handles.data.ecgraw = handles.data.origecgraw;
    end
end

if ~isempty(handles.data.ecgsegment)
    plotspecial(handles,handles.figecg,handles.data.ecgsegment,1,1,length(handles.data.ecgsegment),1); %Here is special, to plot as full signal
else
    if handles.settings.bfull == 1%Full signal
        plotspecial(handles,handles.figecg,handles.data.ecgraw,handles.settings.bfull,1,length(handles.data.ecgraw),1);
    else
        plotspecial(handles,handles.figecg,handles.data.ecgraw,handles.settings.bfull,1,handles.settings.ecglength * handles.settings.fs * 60,1);
    end
end

guidata(hObject,handles);

% --- Executes on button press in btclear.
function btclear_Callback(hObject, eventdata, handles)
% hObject    handle to btclear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fs = handles.settings.fs;
seg = handles.settings.ecglength;
overlay = handles.settings.ecgoverlay;
pos = round(get(handles.ecgslider,'Value'));
startpos = (overlay*(pos-1))*60*fs+1;
endpos = ((overlay*(pos-1))+seg)*60*fs;
if endpos > length(handles.data.ecgraw)
    endpos = length(handles.data.ecgraw);
end

plotspecial(handles,handles.figecg,handles.data.ecgraw,handles.settings.bfull,startpos,endpos,1);

guidata(hObject,handles);


% --- Executes on button press in cbrsr.
function cbrsr_Callback(hObject, eventdata, handles)
% hObject    handle to cbrsr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cbrsr


% --- Executes on button press in btnewqrs.
function btnewqrs_Callback(hObject, eventdata, handles)
% hObject    handle to btnewqrs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%Define a global variable to save ibi value
global peakpos;
%%Save peakpos as vector
if size(peakpos,2)>size(peakpos,1)
    peakpos = peakpos';
end

%%Save ibi as vector
handles.ibi = diff(peakpos/handles.settings.fs);

if handles.settings.bfull == 0
    handles.ecgdata = handles.data.ecgsegment;
else
    handles.ecgdata = handles.data.ecgraw;
end

if size(handles.ecgdata,2)>size(handles.ecgdata,1)
    handles.ecgdata = handles.ecgdata';
end

ecglength = round(length(handles.ecgdata)/(60*handles.settings.fs));%%In minutes

%%IBI File Saving
defibiname = cat(2,char(handles.patientID),'_',num2str(ecglength),'mins_ibi');
[outputFileName,outputPathName] = uiputfile('*.csv','Save the processed IBI results to:',defibiname);
fullFileName = fullfile(outputPathName, outputFileName);
csvwrite(fullFileName,handles.ibi);

%%PC File Saving 
defpcname = cat(2,char(handles.patientID),'_',num2str(ecglength),'mins_ECG&Peakpos');
[outputpcFileName,outputpcPathName] = uiputfile('*.csv','Save the processed IBI results to:',defpcname);
fullpcFileName = fullfile(outputpcPathName, outputpcFileName);

ecgpeakpos =  zeros(length(handles.ecgdata),1);
ecgpeakpos(peakpos) = 1;
ecgpc(:,1) = handles.ecgdata;
ecgpc(:,2) = ecgpeakpos';
csvwrite(fullpcFileName,ecgpc);

guidata(hObject,handles);
%%Call HRnVm_Calculation main
HRnVm_Calculation;


% --- Executes on button press in localcheck.
function localcheck_Callback(hObject, eventdata, handles)
% hObject    handle to localcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of localcheck
if get(handles.localcheck, 'Value') == 1
    set(handles.cbrsr, 'Enable', 'on');
else
    set(handles.cbrsr, 'Enable', 'off');
    set(handles.cbrsr, 'Value', 0);
end
