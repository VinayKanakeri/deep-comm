
function [ofdm_mod,ofdm_demod] = OFDMConfig(nCarr,cp_len,nSym,n_tx,p_flag,pilot_idx)
% OFDMConfig: Configures the OFDM object
% nCarr : Number of carrier
% cp_len : Length of Cyclic Prefix
% nSym : Number of OFDM synbols (not data symbols == nCarr)
% n_tx : Number of transmitting antennaes
% p_flag : Are we providing pilots seperatley if so p_flag=1;
% pilot_idx : Pilot sub carrier index in each OFDM synbol 

nfft = nCarr; % Number of subcarriers
%cp_len = 16; % Length of CP
DC_null =0;
gaurdCarr = 0; % Number of gaurd carriers above and below

%numPilotCarr = nfft-DC_null-gaurdCarr ;% Number of pilot carriers we use block type pilot distribution
%numDataCarr = nfft-DC_null-gaurdCarr ; % Length of data carriers

%nSym_dat = 10 ; %Number of Data Symbols
%nSym_pil = 2 ; % Pilot symbols
%nSym = nSym_dat + nSym_pil; % Total number of symbols


ofdm_mod = comm.OFDMModulator; % Modulation Object

ofdm_mod.FFTLength = nfft;
ofdm_mod.PilotInputPort = p_flag; % We are providing the pilots with the data so this is made false

ofdm_mod.PilotCarrierIndices=pilot_idx; % Need to provide pilot subcarrier index
%across all symbols size is (numPilotcarrxnSymxNumTransmitAntennas)

ofdm_mod.CyclicPrefixLength = cp_len;
ofdm_mod.NumSymbols = nSym;
ofdm_mod.NumTransmitAntennas = n_tx;
ofdm_mod.InsertDCNull = DC_null;
ofdm_mod.NumGuardBandCarriers=[gaurdCarr;gaurdCarr];

ofdm_demod = comm.OFDMDemodulator; % Demodulation object

ofdm_demod.FFTLength = nfft;
ofdm_demod.PilotOutputPort = p_flag; % We are proving the pilots with the data so this is made false

ofdm_demod.PilotCarrierIndices=pilot_idx; % Need to provide pilot subcarrier index
%across all symbols size is (numPilotcarrxnSymxNumTransmitAntennas)

ofdm_demod.CyclicPrefixLength = cp_len;
ofdm_demod.NumSymbols = nSym;
ofdm_demod.NumReceiveAntennas = n_tx;
ofdm_demod.RemoveDCCarrier = DC_null;
ofdm_demod.NumGuardBandCarriers=[gaurdCarr;gaurdCarr];
