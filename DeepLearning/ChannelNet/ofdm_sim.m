function [H_est_mat,H_actual] = ofdm_sim(ofdm_mod,ofdm_demod,channel_mat,nCarr,nSym,nFrames,cp_len,SNR)
M = 4; % QPSK modulation
tx_data = randi([0 M-1],nFrames,nCarr,nSym); % random data generated to get the channel data
tx_sym = qammod(tx_data,M);
ofdm_waveform = zeros(nFrames,(nCarr+cp_len)*nSym);
ofdm_wave_tx = zeros(nFrames,nCarr+cp_len,nSym,1);
channel_matrix = permute(reshape(channel_mat,[nFrames,nSym,16]),[1 3 2]);
ofdm_wave_rx = zeros(nFrames,nCarr+cp_len,nSym,1);
ofdm_waveform_rx = zeros(nFrames,(nCarr+cp_len)*nSym,1);
rx_frame = zeros(nFrames,nCarr,nSym);
tx_frame = zeros(nFrames,nCarr,nSym);
H_est_mat = zeros(nFrames,nCarr,nSym);
for i=1:nFrames
    tx_frame(i,:,:) = shiftdim(tx_sym(i,:,:),1);
    ofdm_waveform(i,:) = ofdm_mod(shiftdim(tx_sym(i,:,:),1));
    ofdm_wave_tx(i,:,:,:) = reshape(ofdm_waveform(i,:),[nCarr+cp_len,nSym,1]);
    for j=1:nSym
        rx_time = channel_output(channel_matrix(i,:,j),ofdm_wave_tx(i,:,j,:),SNR);
        ofdm_wave_rx(i,:,j,:) = rx_time;
    end
    ofdm_waveform_rx(i,:,:) = reshape(ofdm_wave_rx(i,:,:,:),[(nCarr+cp_len)*nSym,1]);
    rx_frame(i,:,:) = ofdm_demod(shiftdim(ofdm_waveform_rx(i,:,:),1));
    H_est_mat(i,:,:) = LSest(squeeze(rx_frame(i,:,:)),squeeze(tx_frame(i,:,:)));
    
end
H_actual = fft(channel_matrix,nCarr,2);



