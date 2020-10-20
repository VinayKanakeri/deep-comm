function [ofdm_waveform,dat_pil_mod] = OFDM_Tx(ofdm_mod,p_flag)

% For now I am creating the data with the pilots where every 5th symbol is
% the pilot. We can also use the Modulator/Demoluator object but in that I
% am not sure how we can insert pilots across all the subcarriers for
% specific symbols and none in the others. If we can figure this out this
% becomes damn easy then.

M=4;                                           % QAM modulation
nfft = ofdm_mod.FFTLength;                     % Number of subcarriers
%cp_len = ofdm_mod.CyclicPrefixLength;         % Length of CP
DC_null = ofdm_mod.InsertDCNull;
gaurdCarr = ofdm_mod.NumGuardBandCarriers(1);  % Number of gaurd carriers above and below
nSym = ofdm_mod.NumSymbols;
numDataCarr = nfft-DC_null-gaurdCarr;  % Length of data carriers
switch p_flag % Checking if the pilots are embedded in data or have to be seperately passes, 0 means pilot is in data
    case 0 
        numPilotCarr = numDataCarr; % Number of pilot carriers we use block type pilot distribution

        nSym_pil = ceil(nSym/5);               % Number of pilots, inserting it in every 5th symbol
        dat_pil = randi([0 M-1], numDataCarr,nSym);      % data symbols

        for i=1:nSym_pil
            dat_pil(:,i+(5*(i-1))) = ones(1,numPilotCarr); % Inserting pilot symbols after every fifth symbol
        end

        dat_pil_mod = qammod(dat_pil,M);                 % QAM modulation of the data and pilot symbols

        ofdm_waveform = ofdm_mod(dat_pil_mod);
        
    case 1 % When pilots have to be sepearetely passed i.e. when pilots are present in each OFDM symbol
        numPilotCarr = length(ofdm_mod.PilotCarrierIndices);
        pilots =  ones(numPilotCarr,nSym);
        data = randi([0 M-1], nfft-numPilotCarr,nSym);
        dat_pil_mod = qammod(data,M);                 % QAM modulation of the data
        pilot_mod = qammod(pilots,M);                  % QAM modulation of pilots
        ofdm_waveform = ofdm_mod(dat_pil_mod,pilot_mod);

    otherwise
        warning('Unexpected input');
end

end
