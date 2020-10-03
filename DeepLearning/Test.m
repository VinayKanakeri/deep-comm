[mod,demod] = OFDMConfig(64,16,20,1);
[waveform1,dat_pil]= OFDM_Tx(mod);
dat_pil_demod = demod(waveform1);