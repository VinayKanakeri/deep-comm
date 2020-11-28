function [H_est_mmse,H_est_ls] = mimo_mmse_ls(Ncarr,Nant,Rx,pilots,pilot_channel,pilot_columns)

% LS estimation
Hls= Rx./pilots;
% MMSE Channel Estimation
R_HH = pilot_channel*pilot_channel'; 
XX = toeplitz(pilots);     
powerDB = 10*log10(var(Rx)); % Calculate Tx signal power
sigmI = 10.^(0.1*(powerDB)); % Calculate the noise variance
G=(R_HH)*(R_HH + (1/sigmI)*(XX))^(-1);
Hmmse=((G)*(Hls));
    

x = pilot_columns;
y = 1:Nant;
[X,Y] = meshgrid(x,y);

x_2d = 1:Ncarr;
y_2d = 1:Nant;
[X_2d,Y_2d] = meshgrid(x_2d,y_2d);
H_est_ls = interp2(X,Y,Hls,X_2d,Y_2d,'spline');
H_est_mmse = interp2(X,Y,Hmmse,X_2d,Y_2d,'spline');
end