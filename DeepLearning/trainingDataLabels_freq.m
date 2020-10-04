function [H_data_pred,H_actual] = trainingDataLabels_freq(nSym,nCarr,cp_len,n_tx,nSubFrame,SNR,Np)

channel_train = load('channel_train.mat'); % Loading the channel training data

% Allocating memory to the full training label structure
% The structure is 4D : Num of Symbols, Num of carriers, Real and Imag
% parts and number of subframes or examples.

H_data_pred = zeros([nSym nCarr 2 nSubFrame]);
H_actual = zeros([nSym nCarr 2 nSubFrame]);   

% Creating the OFDM configuration object
[ofdm_mod,ofdm_demod] = OFDMConfig(nCarr,cp_len,nSym,n_tx);

% To get the pilot vector initially 
[~,dat_pil] = OFDM_Tx(ofdm_mod);
Xp = dat_pil(:,1); % The first OFDM frame transmitted is the pilot block.

for i=1:nSubFrame % For every examples contruct the data and the label 
    h_subframe = channel_train.channel_train(1+(i-1)*nSym:nSym*i,:); % Take one subframe of channel data
    H_label = fft(h_subframe,nCarr,2); % Perform 64(nCarr) point FFT along the rows(2nd dimension) of the channel array
    H_actual(:,:,1,i) = real(H_label); % Extracting the real part of the 20x64 complex freq matrix
    H_actual(:,:,2,i) = imag(H_label); % Extracting the imag part of the above matrix
    [tx_sig,~] = OFDM_Tx(ofdm_mod);    % Creating the OFDM waveform which will be transmitted across the channel.
                                   
    
    rx_sig = zeros(size(tx_sig));      % Memory allocation for received signal 
    for j= 1:nSym                      % Iterating over the symbols in each subframe
        h= h_subframe(j,:);            % Channel 16 taps array for each OFDM frame
        rx_sig(1+(j-1)*80:(j)*80) = channel_output(h,tx_sig(1+(j-1)*80:(j)*80),SNR); % Length of one symbol with CP is 80
    end
    Y = ofdm_demod(rx_sig); % One subframe i.e. nSym taken together 
    
    H = LSE(Y,Xp,Np);       % Getting the LS estimate at the positions of the pilot
    H_data_pred(:,:,1,i) = real(H'); % Real part of LS predicted / input data
    H_data_pred(:,:,2,i) = imag(H'); % Imaginary part of the LS predicted / input data
end