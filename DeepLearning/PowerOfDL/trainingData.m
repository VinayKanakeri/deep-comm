function [train_data,train_label] = trainingData(nCarr,cp_len,n_tx,p_flag,nSamples,pilot_idx,SNR)

M=2;
nSym = 1;
[ofdm_mod,ofdm_demod]= OFDMConfig(nCarr,cp_len,nSym,n_tx,p_flag,pilot_idx);
[~,h_coeff] = WinnerResponse(nSamples);
h_coeff = squeeze(h_coeff{1});
train_data = zeros(2*nCarr,nSamples);
train_label = zeros(16,nSamples);
for i=1:nSamples 
    [txSig,data] = OFDM_Tx(ofdm_mod,p_flag);
    train_label(:,i) = qamdemod(data(1:16),M);
    
    % Getting data
    h = h_coeff(:,i);
    y = channel_output(h,txSig,SNR);
    y = y(1:nCarr+cp_len);
    [rxSig,pilot_mod] = ofdm_demod(y);
    
    % Real Part
    train_data(1:length(pilot_mod),i) = real(pilot_mod);
    train_data(length(pilot_mod)+1:length(pilot_mod)+length(rxSig),i) = real (rxSig);
    
    %Imag Part
    train_data(nCarr+1:nCarr+length(pilot_mod),i) = imag(pilot_mod);
    train_data(nCarr+1+length(pilot_mod):end,i) = imag(rxSig);
    
end
end