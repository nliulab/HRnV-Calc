function HRVparams_kb = Modify_params_kb(HRVparams)
%% Modify the software profile according to the default settings of Kubios
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
HRVparams_kb = HRVparams;


%% Change frequency domain settings according to Kubios
% this should not make any difference, as we already combine ULF and VLF
ULF = [0 0];%.0033];                % Requires window > 300 s
VLF = [0 .04];%[0.0033 .04];        % Requires at least 300 s window
LF = [.04 .15];                     % Requires at least 25 s window
HF = [0.15 0.4];                    % Requires at least 7 s window
HRVparams_kb.freq.limits = [ULF; VLF; LF; HF];
% sampling rate may cause some difference
HRVparams_kb.freq.resampling_freq = 4;%7;    % Default: 7, Hz


%% Change entropy settings according to Kubios

HRVparams_kb.Entropy.RadiusOfSimilarity = 0.2;%0.15;  
% Default: 0.15, Radius of similarity (% of std)


%% Change DFA settings
HRVparams_kb.DFA.maxBoxSize = 64;%[];      
% Largest box width (default in DFA code: signal length/4) 


end