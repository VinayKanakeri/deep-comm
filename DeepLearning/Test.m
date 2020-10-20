
nCarr =128;
cp_len=16;
nSamples=100;
n_tx= 1;
p_flag = 1;
pilot_idx = (1:64)';
SNR =20;
%[mod,demod]= OFDMConfig(nCarr,cp_len,nSym,n_tx,p_flag,pilot_idx);

%[x, data] = OFDM_Tx(mod,p_flag);

[d,l] = trainingData(nCarr,cp_len,n_tx,p_flag,nSamples,pilot_idx,SNR);