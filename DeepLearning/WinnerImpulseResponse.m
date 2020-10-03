%function impulse_response = WinnerImpulseResponse(cfgWim,cfgLayout)
% Provides the channel coeffcients for the specified layout
% and parametr configurations.


[cfgWim,cfgLayout] = Winner2ChannelModelConfig();
winnerchan = comm.WINNER2Channel(cfgWim,cfgLayout);
chan_info=info(winnerchan);
impulse = cellfun(@(x)[ones(1:x);zeros(cfgWim.NumTimeSamples-1,x)],...
                 num2cell(chan_info.NumBSElements)','UniformOutput',false);
impulse_response = winnerchan(impulse);
%end

