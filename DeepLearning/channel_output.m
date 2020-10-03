function [rx_sig] = channel_output(h,tx_sig,SNR)
% Gives the output after the transmitted OFDM waveform passes 
% through the channel.
    y= conv(tx_sig,h,'same');
    sigPow = y*y'; 
    noise_mag = sqrt((10.^(-SNR/10))*sigPow/2);
    rx_sig = y + noise_mag*(randn(size(y))+1j*randn(size(y)));
end