function [layers2,options2] = dncnn_model(input_size,batchSize,valData,valLabels,valFrequency)
layers = [ ...
        imageInputLayer(input_size,'Normalization','none','Name','Input')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_1')
        reluLayer('Name','relu_1')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_2')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_2')
        reluLayer('Name','relu_2')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_3')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_3')
        reluLayer('Name','relu_3')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_4')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_4')
        reluLayer('Name','relu_4')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_5')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_5')
        reluLayer('Name','relu_5')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_6')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_6')
        reluLayer('Name','relu_6')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_7')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_7')
        reluLayer('Name','relu_7')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_8')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_8')
        reluLayer('Name','relu_8')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_9')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_9')
        reluLayer('Name','relu_9')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_10')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_10')
        reluLayer('Name','relu_10')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_11')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_11')
        reluLayer('Name','relu_11')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_12')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_12')
        reluLayer('Name','relu_12')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_13')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_13')
        reluLayer('Name','relu_13')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_14')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_14')
        reluLayer('Name','relu_14')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_15')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_15')
        reluLayer('Name','relu_15')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_16')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_16')
        reluLayer('Name','relu_16')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_17')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_17')
        reluLayer('Name','relu_17')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_18')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_18')
        reluLayer('Name','relu_18')
        convolution2dLayer(3,64,'Padding','same','Name','Conv_19')
        batchNormalizationLayer('Epsilon',1e-3,'Name','batnorm_19')
        reluLayer('Name','relu_19')
        convolution2dLayer(3,1,'Padding','same','Name','Conv_20')
        invertLayer('invert')
    ];

add = additionLayer(2,'Name','add_1');
reglayer = regressionLayer('Name','output');
lgraph = layerGraph;
lgraph = addLayers(lgraph,layers);
lgraph = addLayers(lgraph,add);
lgraph = connectLayers(lgraph,'Input','add_1/in1');
lgraph = connectLayers(lgraph,'invert','add_1/in2');
lgraph = addLayers(lgraph,reglayer);
lgraph = connectLayers(lgraph,'add_1','output');
layers2 = lgraph.Layers;

options2 = trainingOptions('adam', ...
    'ExecutionEnvironment','multi-gpu',...
    'InitialLearnRate',0.01, ...
    'MaxEpochs',100, ...
    'Shuffle','every-epoch', ...
    'Verbose',false, ...
    'Plots','training-progress', ...
    'MiniBatchSize',batchSize, ...
    'ValidationData',{valData, valLabels}, ...
    'ValidationFrequency',valFrequency, ...
    'ValidationPatience',5);
end

