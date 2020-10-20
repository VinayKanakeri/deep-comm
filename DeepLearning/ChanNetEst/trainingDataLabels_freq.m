function [H_data_pred,H_actual] = trainingDataLabels_freq(nSym,nCarr,cp_len,n_tx,nSubFrame,SNR,Np,p_flag)
% This function generates the 4D output of labels and data for the 
%channel estimation in frequency domain. It takes in the input as :
% nSym : Number of symbols in each subframe
% nCarr : Number of carriers in each subframe
% cp_len : Cyclic Prefix length for the OFDM config
% n_tx : Number of transmitting antennaes
% nSubFrame : Number of subframes / examples
% SNR : To generate the noise power
% p_flag : If pilot is embedded in data (0) if not (0)
channel_train = load('channel_train.mat'); % Loading the channel training data

% Allocating memory to the full training label structure
% The structure is 4D : Num of Symbols, Num of carriers, Real and Imag
% parts and number of subframes or examples.

H_data_pred = zeros([nSym nCarr 2 nSubFrame]);
H_actual = zeros([nSym nCarr 2 nSubFrame]);   

% Creating the OFDM configuration object
p_idx=1;
[ofdm_mod,ofdm_demod] = OFDMConfig(nCarr,cp_len,nSym,n_tx,p_flag,p_idx);

% To get the pilot vector initially 
[~,dat_pil] = OFDM_Tx(ofdm_mod,p_flag);
Xp = dat_pil(:,1); % The first OFDM frame transmitted is the pilot block.

nOFDMSym = cp_len+nCarr;
for i=1:nSubFrame % For every examples contruct the data and the label 
    h_subframe = channel_train.channel_train(1+(i-1)*nSym:nSym*i,:); % Take one subframe of channel data
    H_label = fft(h_subframe,nCarr,2); % Perform 64(nCarr) point FFT along the rows(2nd dimension) of the channel array
    H_actual(:,:,1,i) = real(H_label); % Extracting the real part of the 20x64 complex freq matrix
    H_actual(:,:,2,i) = imag(H_label); % Extracting the imag part of the above matrix
    [tx_sig,~] = OFDM_Tx(ofdm_mod,p_flag);    % Creating the OFDM waveform which will be transmitted across the channel.
                                   
    
    rx_sig = zeros(size(tx_sig));      % Memory allocation for received signal 
    for j= 1:nSym                      % Iterating over the symbols in each subframe
        h= h_subframe(j,:);            % Channel 16 taps array for each OFDM frame
        temp = channel_output(h,tx_sig(1+(j-1)*nOFDMSym:(j)*nOFDMSym),SNR); % Length of one symbol with CP is 80
        temp =temp(1:nOFDMSym);
        rx_sig(1+(j-1)*nOFDMSym:(j)*nOFDMSym) = temp ;
    end
    Y = ofdm_demod(rx_sig); % One subframe i.e. nSym taken together 
    
    H = LSE(Y,Xp,Np);       % Getting the LS estimate at the positions of the pilot
    H_data_pred(:,:,1,i) = real(H'); % Real part of LS predicted / input data
    H_data_pred(:,:,2,i) = imag(H'); % Imaginary part of the LS predicted / input data
end