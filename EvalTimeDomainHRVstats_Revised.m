function out = EvalTimeDomainHRVstats_Revised(NN,tNN,sqi,HRVparams,tWin, hrnv)

%%Modified by Duke-NUS team for short-term HRnVm time-domain parameters
%%calculation

% Add Input: hrnv -- To calculate nn50x and pnn50x
% Add Output: Triangular Index -- HRVTi
% Add Output: HRmean,sdHR, NN50, NN50x,pNN50x

% [NNmean,NNmedian,NNmode,NNvariance,NNskew,NNkurt,SDNN,NNiqr,RMSSD, pnn50
% btsdet,avgsqi] = EvalTimeDomainHRVstats(NN,tNN,sqi,HRVparams,windows_all)
%
%   OVERVIEW:   This function returns time domain HRV metrics calculated on
%               input NN intervals.
%
%   INPUT:      MANDATORY:
%               NN             : a single row of NN (normal normal) interval 
%                                data in seconds
%               tNN            : the time of the rr interval data 
%                                (seconds)
%               sqi            : (Optional )Signal Quality Index; Requires 
%                                a matrix with at least two columns. Column 
%                                1 should be timestamps of each sqi measure, 
%                                and Column 2 should be SQI on a scale from 0 to 1.
%               HRVparams      : struct of settings for hrv_toolbox analysis
%               tWin           : vector containing the starting time of each
%                                windows (in seconds) 
%                
%   OUTPUT:     
%               out.NNmean      : mean
%               out.NNmedian    : median
%               out.NNmode      : mode
%               out.NNvariace   : variance
%               out.NNskew      : skewness
%               out.NNkurt      : kurtosis
%               out.SDNN        : standard deviation
%               out.NNiqr       : intra quartil range
%               out.RMSSD       : root mean square difference
%               out.pnn50       : the fraction of consecutive beats that differ by
%                                 more than a specified time.
%               out.btsdet      : number of detected beats
%               out.avgsqi      : average signal quality
%               out.tdflag      : 2 - Not enough high SQI data
%                                 3 - Not enough data in the window to analyze
%                                 5 - Success
%
%	REPO:       
%       https://github.com/cliffordlab/PhysioNet-Cardiovascular-Signal-Toolbox
%   ORIGINAL SOURCE AND AUTHORS:     
%       Written by Adriana N. Vest     
%	COPYRIGHT (C) 2016 
%   LICENSE:    
%       This software is offered freely and without warranty under 
%       the GNU (v3 or later) public license. See license file for
%       more information
%
%   10-25-2017 Modified by Giulia Da Poian, convert results in ms and 
%   removed code for writing results on file
%

% Verify input arguments

if nargin< 5
    error('no input argument!!!!')
end
if isempty(sqi) 
     sqi(:,1) = tNN;
     sqi(:,2) = ones(length(tNN),1);
end



% Set Defaults

windowlength = HRVparams.windowlength;
alpha = HRVparams.timedomain.alpha;
threshold1 = HRVparams.sqi.LowQualityThreshold;
threshold2 = HRVparams.RejectionThreshold;


% Preallocate arrays (all NaN) before entering the loop
out.NNmean     = nan(1,length(tWin));
out.NNmedian   = nan(1,length(tWin));
out.NNmode     = nan(1,length(tWin));
out.NNvariance = nan(1,length(tWin));
out.NNskew     = nan(1,length(tWin));
out.NNkurt     = nan(1,length(tWin));
out.NNiqr      = nan(1,length(tWin));
out.SDNN       = nan(1,length(tWin));
out.RMSSD      = nan(1,length(tWin));
out.pnn50      = nan(1,length(tWin));
out.btsdet     = nan(1,length(tWin));
out.avgsqi     = nan(1,length(tWin));
out.tdflag     = nan(1,length(tWin));

%Analyze by Window

% Loop through each window of RR data
for i_win = 1:length(tWin)
    % Check window for sufficient data
    if ~isnan(tWin(i_win))
        % Isolate data in this window
        idx_NN_in_win = find(tNN >= tWin(i_win) & tNN < tWin(i_win) + windowlength);
        idx_sqi_win = find(sqi(:,1) >= tWin(i_win) & sqi(:,1) < tWin(i_win) + windowlength);
        
        sqi_win = sqi(idx_sqi_win,:);
        t_win = tNN(idx_NN_in_win);
        nn_win = NN(idx_NN_in_win);

        % Analysis of SQI for the window
        lowqual_idx = find(sqi_win(:,2) < threshold1);

        % If enough data has an adequate SQI, perform the calculations
        if numel(lowqual_idx)/length(sqi_win(:,2)) < threshold2

            out.NNmean(i_win) = mean(nn_win.* 1000); % compute and convert to ms
            out.NNmedian(i_win) = median(nn_win.* 1000); % compute and convert to ms
            out.NNmode(i_win) = mode(nn_win.* 1000); % compute and convert to ms
            out.NNvariance(i_win) = var(nn_win.* 1000); % compute and convert to ms^2
            out.NNskew(i_win) = skewness(nn_win); 
            out.NNkurt(i_win) = kurtosis(nn_win); 
            out.NNiqr(i_win) = iqr(nn_win.* 1000); % compute and convert to ms
            out.SDNN(i_win) = std(nn_win.* 1000); % compute and convert to ms % SDNN should only be done on longer data segments

            HR = 60./nn_win;
            out.HRmean(i_win)= mean(HR);   
            out.SDHR(i_win)= std(HR);
            
            % RMSSD
            out.RMSSD(i_win) = runrmssd(nn_win.* 1000); % compute and convert to ms

            % pNN50 andNN50 --- Duke-NUS
            out.pnn50(i_win) = pnna(nn_win, alpha); % 
            out.nn50(i_win) = round(out.pnn50(i_win)*(length(nn_win)-1));
            
            % pNN50x and NN50x --- Duke-NUS
            out.pnn50x(i_win) = pnna(nn_win, alpha*hrnv); % 
            out.nn50x(i_win) = round(out.pnn50x(i_win)*(length(nn_win)-1));
            
            % HRVTi --- Duke-NUS
            [out.HRVTi(i_win),out.calhistibi] = HRVTi(nn_win);
            out.histnum(i_win)=length(out.calhistibi(:,1));

            out.btsdet(i_win) = length(nn_win);
            out.avgsqi(i_win) = mean(sqi_win(:,2));
            
            out.tdflag(i_win) = 5; % 5 : 'sucess';
          
        else
            % 2: low SQI
            out.tdflag(i_win) = 2; 
        end % end of conditional statements that run if SQI is above threshold2
        
    else
        % 3: Not enough data in the window to analyze;
        out.tdflag(i_win) = 3; 
    end % end check for sufficient data
    
end % end of loop through window

end % end of function

%%----------------Add by Duke-NUS-------------------%%
function [HRVTi,calhistibi] = HRVTi(tdibi)
%hrvti: HRV triangular index, 
    %GEOMETRIC HRV
    %calculate number of bins to use in histogram    
    dt=max(tdibi)-min(tdibi);
    %1/128 seconds. Reference: (1996) Heart rate variability:
    %standards of measurement, physiological interpretation and
    %clinical use.
    binWidth=1/128; 
    nBins=round(dt/binWidth)+1;
    
    %temp
    %nBins=32;
    [calhistibi,calHRVTi] = hrvti(tdibi,nBins);
    HRVTi=round(calHRVTi*10)/10; %Triangular Index
end

function [histibi,outputhrvti]=hrvti(ibi,nbin)

%histibi: hist parameters for ibi 
    histibi = ones(nbin,2);%Initialization
    %calculate samples in bin (n) and x location of bins (xout)
    %Due to code generation to c problem, using histc instead of hist in
    %matlab - Dagang
    %maxedge = max(ibi)-max(ibi)/nbin;
    maxedge = max(ibi);
    hrvlinspace = linspace (min(ibi),maxedge,nbin);
    %hrvlinspace(nbin)=1500; %use 1500ms as inf as common sense - GDG
    nhrv = histc(ibi,hrvlinspace);    
    outputhrvti=length(ibi)/max(nhrv); %hrv ti
    histibi(:,2) = nhrv;
    histibi(:,1) = hrvlinspace; 
end
