%%====== Modified by Duke-NUS Team
function HRnVOutput = Main_HRnVm_Analysis(NN,tNN,sqi,HRVparams,WinIdxs,hrnv)
%  ====== HRV Toolbox for PhysioNet Cardiovascular Signal Toolbox =========
%
%   Main_HRnVm_Analysis(InputSig,t,InputFormat,HRVparams,subID,ann,sqi,varargin)
%	OVERVIEW:
%       Main "HRV Toolbox for PhysioNet Cardiovascular Signal Toolbox" 
%       Configured to accept RR intervals as well as raw data as input file
%
%   INPUT:
%       InputSig    - Vector containing RR intervals data (in seconds) 
%                     or ECG/PPG waveform  
%       t           - Time indices of the rr interval data (seconds) or
%                     leave empty for ECG/PPG input
%       InputFormat - String that specifiy if the input vector is: 
%                     'RRIntervals' for RR interval data 
%                     'ECGWaveform' for ECG waveform
%                     'PPGWaveform' for PPG signal
%
%       hrnv - HRnV
%       subID       - subject ID, string to identify current subject


% 2. Calculate time domain HRV metrics - Using HRV Toolbox for PhysioNet 
%    Cardiovascular Signal Toolbox Toolbox Functions        
if HRVparams.timedomain.on 
    TimeMetrics = EvalTimeDomainHRVstats_Revised(NN,tNN,sqi,HRVparams,WinIdxs,hrnv);
    % Export results
    %HRnVOutput.td = struct2cell(TimeMetrics);
    HRnVOutput.td.NNmean = round(100*TimeMetrics.NNmean)/100;
    HRnVOutput.td.SDNN = round(100*TimeMetrics.SDNN)/100;
    HRnVOutput.td.HRmean = round(100*TimeMetrics.HRmean)/100;
    HRnVOutput.td.SDHR = round(100*TimeMetrics.SDHR)/100;
    HRnVOutput.td.NNskew = round(100*TimeMetrics.NNskew)/100;
    HRnVOutput.td.NNkurt = round(100*TimeMetrics.NNkurt)/100;
    HRnVOutput.td.RMSSD = round(100*TimeMetrics.RMSSD)/100;
    HRnVOutput.td.nn50 = TimeMetrics.nn50;
    HRnVOutput.td.pnn50 = round(10000*TimeMetrics.pnn50)/100;
    HRnVOutput.td.nn50x = TimeMetrics.nn50x;
    HRnVOutput.td.pnn50x = round(10000*TimeMetrics.pnn50x)/100;
    HRnVOutput.td.HRVTi = round(100*TimeMetrics.HRVTi)/100;
    HRnVOutput.td.histnum = TimeMetrics.histnum;
end

% 3. Frequency domain  metrics (LF HF TotPow) 
if HRVparams.freq.on 
    FreqMetrics = EvalFrequencyDomainHRVstats_Revised(NN,tNN,sqi,HRVparams,WinIdxs);
    % Export results
    HRnVOutput.fd.hrv_tp = round(100*FreqMetrics.ttlpwr)/100;
    HRnVOutput.fd.vlf = round(100*(FreqMetrics.vlf + FreqMetrics.ulf))/100;
    HRnVOutput.fd.lf = round(100*FreqMetrics.lf)/100;
    HRnVOutput.fd.hf = round(100*FreqMetrics.hf)/100;
    HRnVOutput.fd.lfnorm = round(10000*FreqMetrics.lf/(FreqMetrics.lf+FreqMetrics.hf))/100;
    HRnVOutput.fd.hfnorm = round(10000*FreqMetrics.hf/(FreqMetrics.lf+FreqMetrics.hf))/100;
    HRnVOutput.fd.lfhf = round(100*HRnVOutput.fd.lfnorm/HRnVOutput.fd.hfnorm)/100;
    
    HRnVOutput.fd.peakvlf = round(100*FreqMetrics.peakvlf)/100;
    HRnVOutput.fd.peaklf = round(100*FreqMetrics.peaklf)/100;
    HRnVOutput.fd.peakhf = round(100*FreqMetrics.peakhf)/100;
    
    HRnVOutput.fd.vlfper = round(10000*(FreqMetrics.vlf+FreqMetrics.ulf)/(FreqMetrics.ttlpwr))/100;
    HRnVOutput.fd.lfper = round(10000*FreqMetrics.lf/FreqMetrics.ttlpwr)/100;
    HRnVOutput.fd.hfper = round(10000*FreqMetrics.hf/FreqMetrics.ttlpwr)/100;
    
    HRnVOutput.fd.psd = FreqMetrics.psd;
    HRnVOutput.fd.f = FreqMetrics.f;
end


% 4.Poincare Features
if HRVparams.poincare.on
     [SD1, SD2, SD12Ratio] = EvalPoincareOnWindows(NN, tNN, HRVparams, WinIdxs, sqi);
     % Export results
     HRnVOutput.nl.sd1 = round(100.*SD1(:))/100;
     HRnVOutput.nl.sd2 = round(100.*SD2(:))/100;
     HRnVOutput.nl.sd12Ratio = round(100*SD12Ratio)/100;
     %D = [D, SD1(:),SD2(:),SD12Ratio(:)];
end

% 5.Entropy Features
if HRVparams.Entropy.on
    m = HRVparams.Entropy.patternLength;
    r = HRVparams.Entropy.RadiusOfSimilarity;

    [SampEn, ApEn] = EvalEntropyMetrics(NN, tNN, m ,r, HRVparams, WinIdxs, sqi);
    % Export results
    HRnVOutput.nl.SampEn = round(1000.*SampEn)/1000;
    HRnVOutput.nl.ApEn = round(1000.*ApEn)/1000;
    %D = [D, SampEn(:),ApEn(:)];
end

% 6. Multiscale Entropy (MSE)
if HRVparams.MSE.on 
    mse = EvalMSE(out.NN_gapFilled,out.tNN_gapFilled,sqi,HRVparams,out.WinIdxsMSE);
     % Save Results for MSE
    Scales = 1:HRVparams.MSE.maxCoarseGrainings;
    HRnVOutput.nl.MSE = [Scales' mse];
    for i=1:length(out.WinIdxsMSE)
        Windows{i} = strcat('t_', num2str(WindIdxs(i)));
    end
end   

% 7. DetrendedFluctuation Analysis (DFA)
if HRVparams.DFA.on
    %[alpha1, alpha2] = EvalDFA(out.NN_gapFilled,out.tNN_gapFilled,sqi,HRVparams,out.WinIdxsDFA); 
    
    %%%%---Duke-NUS---%%%%
    [alpha1, alpha2] = EvalDFA(NN,tNN,sqi,HRVparams,WinIdxs);
    
    HRnVOutput.nl.DFA = round(1000*[0 alpha1 alpha2])/1000;
end

% 8. Heart Rate Turbulence Analysis (HRT)
if HRVparams.HRT.on
    % Create analysis windows from original rr intervals
    WinIdxsHRT = CreateWindowRRintervals(t, rr, HRVparams,'HRT');
    [TO, TS, nPVCs] = Eval_HRT(rr,t,ann,sqi, HRVparams, WinIdxsHRT);
    % Save Results for DFA
    HRnVOutput.nl.HRT = [WinIdxsHRT' TO TS nPVCs];
    %D = [WinIdxsHRT' TO TS nPVCs];
end

%fprintf('HRV Analysis completed for subject ID %s \n',subID);

end %== function ================================================================

