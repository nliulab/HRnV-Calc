function varargout = HRnVm_Result(varargin)
% HRNVM_RESULT MATLAB code for HRnVm_Result.fig
%      HRNVM_RESULT, by itself, creates a new HRNVM_RESULT or raises the existing
%      singleton*.
%
%      H = HRNVM_RESULT returns the handle to a new HRNVM_RESULT or the handle to
%      the existing singleton*.
%
%      HRNVM_RESULT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HRNVM_RESULT.M with the given input arguments.
%
%      HRNVM_RESULT('Property','Value',...) creates a new HRNVM_RESULT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HRnVm_Result_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HRnVm_Result_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HRnVm_Result

% Last Modified by GUIDE v2.5 02-Feb-2021 09:58:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HRnVm_Result_OpeningFcn, ...
                   'gui_OutputFcn',  @HRnVm_Result_OutputFcn, ...
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

% Update handles structure


% --- Executes just before HRnVm_Result is made visible.
function HRnVm_Result_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HRnVm_Result (see VARARGIN)

% Choose default command line output for hrnvmpreprocess
handles.output = hObject;

%%Get Info from HRnVmCal
% get the handle of HRnVmCal
hhrnvmsettings = findobj('Tag','HRnVmSettings');
% if exists (not empty)
if ~isempty(hhrnvmsettings)
    dhrnvmsettings = guidata(hhrnvmsettings);
    hrnvmname = dhrnvmsettings.hrnvmname;
    patientid = dhrnvmsettings.patientID;
    HRnVOutput = dhrnvmsettings.hrnvmoutput;
    ectopicBeats = dhrnvmsettings.ectopicBeats;
    percentClean = dhrnvmsettings.percentClean;
    
   
    %%Display PatientID
    set(handles.txtpatientid,'String',patientid);
    
    %%Display calculated HRnVm name
    set(handles.txthrnvm,'String',hrnvmname);
    
    %%Display Frequency Analysis Method
    set(handles.txtfreqmethod,'String',dhrnvmsettings.HRVParams.freq.method);
    
    %%Close HRnVmCal window once parameters transferred
    close(hhrnvmsettings);
    
    hrnvibi = dhrnvmsettings.prohrnvmibi;
    
    %%Display the IBI output result
    set(handles.txttotwin,'String',num2str(size(hrnvibi,1)+ectopicBeats));
    set(handles.txtlqwin,'String',num2str(ectopicBeats));
    set(handles.txtafwin,'String',num2str(0));
    set(handles.txtcleanper,'String',num2str(percentClean));

    %%Plot ibi
    plotIBI(handles.figibi,hrnvibi(:,2))
    
    %%Histogram
    plotHisto(handles.figibihisto,hrnvibi(:,2),HRnVOutput.td.histnum);
    plotPoincare(handles.figpoincare,hrnvibi(:,2),HRnVOutput.nl.sd1,HRnVOutput.nl.sd2);
    plotPSD(handles.figlsfd,HRnVOutput.fd.f,HRnVOutput.fd.psd,[0.0033 .04],[.04 .15],[.15 .4],[0 0.5],[]);
    
    %%Show results in tables
    cn = {'Value','Unit'};
    timetb1rn = {'MeanRR','SDRR','MeanHR','SDHR','RMSSD','Skewness'};
    timetb2rn = {'Kurtosis','HRVTi','NN50','pNN50','NN50x','pNN50x(%)'};
    freqtbrn = {'Tot.Power','VLF','LF','HF','LFNorm','HFNorm','LF/HF'};
    nltbrn = {'SD1','SD2','Appr Ent.','Samp Ent.','alpha1','alpha2'};

    timetb1rv(1,:) = {HRnVOutput.td.NNmean,HRnVOutput.td.SDNN,HRnVOutput.td.HRmean,HRnVOutput.td.SDHR,HRnVOutput.td.RMSSD, HRnVOutput.td.NNskew};
    timetb1rv(2,:) = {'ms','ms','1/min','1/min','ms',''};
    timetb2rv(1,:) = {HRnVOutput.td.NNkurt,HRnVOutput.td.HRVTi,HRnVOutput.td.nn50,HRnVOutput.td.pnn50,HRnVOutput.td.nn50x,HRnVOutput.td.pnn50x};
    timetb2rv(2,:) = {'','','count','%','count','%'};
    freqtbrv(1,:) = {HRnVOutput.fd.hrv_tp,HRnVOutput.fd.vlf,HRnVOutput.fd.lf,HRnVOutput.fd.hf,HRnVOutput.fd.lfnorm,HRnVOutput.fd.hfnorm,HRnVOutput.fd.lfhf};
    freqtbrv(2,:) = {'ms2','ms2','ms2','ms2','n.u.','n.u.',''};
    nltbrv(1,:)= {HRnVOutput.nl.sd1,HRnVOutput.nl.sd2,HRnVOutput.nl.ApEn,HRnVOutput.nl.SampEn,HRnVOutput.nl.DFA(2),HRnVOutput.nl.DFA(3)};
    nltbrv(2,:)= {'ms','ms','','','',''};
    
    set (handles.tbltd1,'ColumnWidth', {60,80,20});
    set (handles.tbltd2,'ColumnWidth', {60,80,20});
    set (handles.tblfd,'ColumnWidth', {60,80,20});
    set (handles.tblnld,'ColumnWidth', {60,80,20});

    set(handles.tbltd1,'data',timetb1rv','RowName',timetb1rn,'ColumnName',cn);
    set(handles.tbltd2,'data',timetb2rv','RowName',timetb2rn,'ColumnName',cn);
    set(handles.tblfd,'data',freqtbrv','RowName',freqtbrn,'ColumnName',cn);
    set(handles.tblnld,'data',nltbrv','RowName',nltbrn,'ColumnName',cn);
end




% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HRnVm_Result wait for user response (see UIRESUME)
% uiwait(handles.hrnvmresult);


% --- Outputs from this function are returned to the command line.
function varargout = HRnVm_Result_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%The Following is for plot
%%Plot IBI
function plotIBI(handles,ibidata)
plot(handles,ibidata);
  
ax = ancestor(handles,'axes');
ax.XAxis.FontSize = 8;
ax.YAxis.FontSize = 8;
axis(handles,'tight');

ylabel(handles,'RRI(s)','FontSize',8); 
xlabel(handles,'RRI Sequence','FontSize',8);


%%Plot histogram
function plotHisto(handles,rri,nbins)
histogram(handles,rri,nbins); 

ax = ancestor(handles,'axes');
ax.XAxis.FontSize = 8;
ax.YAxis.FontSize = 8;
axis(handles,'tight');

ylabel(handles,'Count','FontSize',8); 
xlabel(handles,'RRI(s)','FontSize',8);
hold(handles,'off');

%% Plot - PSD
function plotPSD(aH,F,PSD,VLF,LF,HF,limX,limY)

color.vlf=[.5 .5 1];    %vlf color
color.lf=[.7 .5 1];     %lf color
color.hf=[.5 1 1];      %hf color

% find the indexes corresponding to the VLF, LF, and HF bands
iVLF= find( (F>=VLF(1)) & (F<VLF(2)) );
iLF = find( (F>=LF(1)) & (F<LF(2)) );
iHF = find( (F>=HF(1)) & (F<HF(2)) );

%plot area under PSD curve
if F(end)<=0.5 %%Lomb
    area(aH,F(:),PSD(:),'FaceColor',[.8 .8 .8]); 
else %%Welch,FFT,Burg,resampling frequency is 7Hz - > F to 3.5Hz
    xindex = find(F<=0.5);
    area(aH,F(xindex),PSD(xindex),'FaceColor',[.8 .8 .8]);
end
hold(aH);
area(aH,F(iVLF(1):iVLF(end)+1),PSD(iVLF(1):iVLF(end)+1), ...
    'FaceColor',color.vlf);
area(aH,F(iLF(1):iLF(end)+1),PSD(iLF(1):iLF(end)+1), ...
    'FaceColor',color.lf);
area(aH,F(iHF(1):iHF(end)+1),PSD(iHF(1):iHF(end)+1), ...
    'FaceColor',color.hf);

if ~isempty(limX)
    set(aH,'xlim',limX);
    %xlim(limX);
else
    limX=[min(F) max(F)];
end
if ~isempty(limY)
    %ylim(limY);
    set(aH,'ylim',limY);
else
    limY=[min(PSD) max(PSD)];
end

%draw vertical lines around freq bands
line1=line([VLF(2) VLF(2)],[limY(1) limY(2)]);
set(line1,'color',[1 0 0],'parent',aH);
line2=line([LF(2) LF(2)],[limY(1) limY(2)]);
set(line2,'color',[1 0 0],'parent',aH);
line3=line([HF(2) HF(2)],[limY(1) limY(2)]);
set(line3,'color',[1 0 0],'parent',aH);
   
hold(aH);

ax = ancestor(aH,'axes');
ax.XAxis.FontSize = 8;
ax.YAxis.FontSize = 8;
axis(aH,'tight');
xlabel(aH,'Frequency (Hz)','FontSize',8); 
ylabel(aH,'PSD (S^2/Hz)','FontSize',8);
   
%% Plot - Poincare
function plotPoincare(handles,ibi,sd1,sd2)
   
    %create poincare plot
    x=ibi(1:end-1);
    y=ibi(2:end);
    dx=abs(max(x)-min(x))*0.05; xlim=[min(x)-dx max(x)+dx];
    dy=abs(max(y)-min(y))*0.05; ylim=[min(y)-dy max(y)+dy]; 
    hpc = plot(handles,x,y,'o','MarkerSize',3)

    %calculate new x axis at 45 deg counterclockwise. new x axis = a
    a=x./cos(pi/4);     %translate x to a
    b=sin(pi/4)*(y-x);  %tranlsate x,y to b
    ca=mean(a);         %get the center of values along the 'a' axis
    %tranlsate center to xyz
    [cx cy cz]=deal(ca*cos(pi/4),ca*sin(pi/4),0); 
    
    %%Round cx to three decimals
    cx = round(1000*cx)/1000;
    
    hold(handles,'on');   
    %draw y(x)=x (CD2 axis)
    %hEz=ezplot(handles,'x',[xlim(1),xlim(2),ylim(1),ylim(2)]);
    
    hEz = fplot(@(x) x,[xlim(1) xlim(2)],'Linewidth',1);
    set(hEz,'color','magenta');
    
    hold on
    %draw y(x)=-x+2cx (CD2 axis)
    eqn=['-x+' num2str(2*cx)];
    %hEz2=ezplot(handles,eqn,[xlim(1),xlim(2),ylim(1),ylim(2)]);
    %set(hEz2,'color','black');
    hEz2 = fplot(@(x) -x+2*cx,[xlim(1) xlim(2)],'Linewidth',1);
    t=title(eqn);
    t.FontSize = 8;
    t.Color = 'blue';
    hold on;
    %plot ellipse
    width=sd2/1000; %convert to s
    height=sd1/1000; %convert to s
    hE = ellipsedraw(handles,width,height,cx,cy,pi/4,'-r');
    set(hE,'linewidth', 2)                
    %plot SD2 inside of ellipse
    lsd2=line([cx-width cx+width],[cy cy],'color','r', ...
        'Parent',handles, 'linewidth',2);
    rotate(lsd2,[0 0 1],45,[cx cy 0])
    %plot SD1 inside of ellipse
    lsd1=line([cx cx],[cy-height cy+height],'color','r', ...
        'Parent',handles, 'linewidth',2);
    rotate(lsd1,[0 0 1],45,[cx cy 0])        

    hold(handles,'off');

  %  set(h.axesPoincare,'FontSize',7);
   % title(eqn,'FontSize',10)

    xlabel(handles,'IBI_N (s)','FontSize',8);
    ylabel(handles,'IBI_N_+_1 (s)','FontSize',8);
    h.text.p(1,1)=text(.05,.95,'SD1:','Parent',handles, ...
        'Units','normalized','Fontsize',8);
    h.text.p(2,1)=text(.05,.88,'SD2:','Parent',handles, ...
        'Units','normalized','Fontsize',8);
    h.text.p(1,2)=text(.20,.95,...
        [sprintf('%0.2f',sd1) ' ms'],...
        'Parent',handles,'Units','normalized','Fontsize',8);
    h.text.p(2,2)=text(.20,.88,...
        [sprintf('%0.2f',sd2) ' ms'],...
        'Parent',handles,'Units','normalized','Fontsize',8);

    ax = ancestor(handles,'axes');
    ax.XAxis.FontSize = 8;
    ax.YAxis.FontSize = 8;
    axis(handles,'tight');
 


% --- Executes on button press in btnewanalysis.
function btnewanalysis_Callback(hObject, eventdata, handles)
% hObject    handle to btnewanalysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HRnVm_Calculation;
