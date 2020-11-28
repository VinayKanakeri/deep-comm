
function [channels] = DeepMIMOReadData(nAnt,options)
load(options.rawDataFile)
disp('Track: loading completes!')
%nUsers = length(DeepMIMO_dataset{1}.user);
nUsers = 34000;
nCarr = options.numSubCarr;
channels = ones([nAnt,nCarr,nUsers,1]);
for i=1:nUsers
    channels(:,:,i,1) = (DeepMIMO_dataset{1}.user{i}.channel(1:nAnt,1:nCarr));
    %channels(:,:,i,2) = imag(DeepMIMO_dataset{1}.user{i}.channel(1:nAnt,1:nCarr));
end
