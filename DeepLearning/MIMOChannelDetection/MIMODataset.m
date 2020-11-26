function [trainData] = MIMODataset()
options = struct();
options.numSubCarr = 4;
options.nPilotSymbols = [4];
options.p_num = size(options.nPilotSymbols,2);
options.bandWidth = 0.01; % unit: GHz
options.SNR_dB = 10; % unit: dB
options.rawDataFile = ...
    './DeepMIMO_dataset.mat'; % Path to dataset
options.ch = [2 3 4 5 6 7 10 20 30 50 70 100]; % Antenna numbers at BS
for i = 1:length(options.ch)
    options.antDimCodebook(i,:) = [1, options.ch(i), 1]; % setting patterns
end
options.pilot = uniformPilotsGen(options.numSubCarr);

% Generating shuffled the channels h and locations
dataset = DeepMIMOReadData(100,options);

options.numOfSamples = size(dataset,3); % A user (location) is a sample point and they all use same pilot.
shuffle_ind = randperm(options.numOfSamples);
options.shuffle_ind = shuffle_ind;
dataset_shuf = dataset(:,:,shuffle_ind,:); % Since #subcarriers is 64, channel is a matrix.

trainData = cell(options.p_num,1);
%trainLabel = cell(options.p_num,1);
for i = 1:options.p_num
    trainData{i} = cell(length(options.ch),2); 
end

for i = 1:options.p_num
    pilotSig = options.pilot{i};
    for j = 1:length(options.ch)
        dataOut = zeros([options.ch(j),options.numSubCarr,options.numOfSamples,1]);
        for k=1:options.numOfSamples
            h = dataset_shuf(1:options.ch(j),:,k,1)+ 1i*dataset_shuf(1:options.ch(j),:,k,2);
            Pr_avg = norm(abs(h))^2;
            SNR_dB = options.SNR_dB;
            SNR    = 10^(.1*SNR_dB);
            Pn     = (Pr_avg/SNR)/2;
            rec = h.*pilotSig.';
            rec = rec + sqrt(Pn)*randn(size(rec,1), size(rec,2)) +...
            1i*sqrt(Pn)*randn(size(rec,1), size(rec,2)); % Add noise ;
            dataOut(:,:,k,1) = rec;
        end
        trainData{i}{j,1} = dataOut(:,:,:,1);
        trainData{i}{j,2} = dataset_shuf(1:options.ch(j),:,:,1)+ 1i*dataset_shuf(1:options.ch(j),:,:,2);
    end
end
end