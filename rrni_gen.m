clear
clc
cwd = pwd;
addpath(genpath(cwd));
files = dir('./Demo_RRI/*.txt');
%i = 1
parfor i = 1:length(files)
    filename = strcat('./Demo_RRI/', files(i).name);
    formatSpec = '%f';
    fid = fopen(filename, 'r');
    inpt = fscanf(fid, formatSpec, [1 Inf]);
    time = cumsum(inpt);
    Hrvp = InitializeHRVparams(files(i).name);
    [NN, tNN, ectopicBeats] = RRIntervalPreprocess_Revised(inpt,time,Hrvp);
    rri = [tNN; NN];
    rri = rri';
    for hrnvm = 1:2
        rrni = hrnvoverlap(rri, 2,hrnvm);
        savefilename = strcat('./Demo_RRI/RRnI/', files(i).name(1:7),'hr2v',num2str(hrnvm),'.txt');
        writematrix(rrni(:,2), savefilename);
    end        
            
end

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
 end
 