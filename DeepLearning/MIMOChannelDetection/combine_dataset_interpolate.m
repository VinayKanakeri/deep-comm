
% train_data = load('dataset_interp_1_15000.mat');
% train_data2 = load('dataset_interp.mat');
% disp('loading complets')
NantConfig = size(trainData{1,1},1);
combined_data = cell(NantConfig,1); % shape(NantConfig,Nant,Ncarr,Nuser)
combined_labels = cell(NantConfig,1); %shape(NantConfig,Nant,Ncarr,Nuser)
Nuser = size(trainData{1,1}{1,1},3);

for i=1:NantConfig
    temp = trainData{1,1}{i,1};
    temp2 = trainData{1,1}{i,2};
    combined_data{i,1} = temp;
    combined_labels{i,1} = temp2;
    disp('combining')
end