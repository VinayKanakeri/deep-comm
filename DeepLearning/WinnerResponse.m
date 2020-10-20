function  [winnerchan,h_coeff] = WinnerResponse(nSamples)
% Provides the channel coeffcients for the specified layout
% and parametr configurations.


[cfgWim,cfgLayout] = Winner2ChannelModelConfig(nSamples);
winnerchan = comm.WINNER2Channel(cfgWim,cfgLayout);
%chan_info=info(winnerchan);
%txSig = cellfun(@(x) [ones(1,x);zeros(cfgWim.NumTimeSamples-1,x)], ...
%                      num2cell(chan_info.NumBSElements)','UniformOutput',false);
%rxSig = winnerchan(txSig);
[h_coeff,~,~] = winner2.wim(cfgWim,cfgLayout);
end

