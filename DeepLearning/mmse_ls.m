% Estimation is done after ofdm demod
% inputs: 1.Received matrix of shape (Ncarr,Nsym)
%         2. pilot_index of shape (Ncarr,Nsym) with 1 at the pilot locations and 0 elsewhere 
%         3. Colums where pilots are located. Vector with column index
%         4. Ncarr and Nsym
%         5. FFT of channel
function [H_est_mmse,H_est_ls] = mmse_ls(Ncarr,Nsym,Rx_mat,Tx_mat,pilot_index,H,pilot_columns)
% Ncarr = 64;
% Nsym = 14;
% pilot_columns = ceil(sort((Nsym)*rand(5,1),'ascend'));
% pilot_index = zeros(Ncarr,Nsym);
% pilot_index(:,pilot_columns)  = randi([0,1],Ncarr,length(pilot_columns));
% Rx_mat = randn(Ncarr,Nsym);
% Tx_mat = randn(Ncarr,Nsym);

Hls_2d = [];
Hmmse_2d = [];
for i= pilot_columns
    Rx_col = Rx_mat(:,i);
    Tx_col = Tx_mat(:,i);
    Rx_pilot = Rx_col(pilot_index(:,i)==1);
    Tx_pilot = Tx_col(pilot_index(:,i)==1);
    PL = find(pilot_index(:,i)==1);
    % LS estimation
    Hls= Rx_pilot./Tx_pilot;
    % MMSE Channel Estimation
    R_HH = H((pilot_index(:,i)==1),i)*H((pilot_index(:,i)==1),i)';%toeplitz(H); 
    XX = toeplitz(Tx_pilot);     
    powerDB = 10*log10(var(Rx_pilot)); % Calculate Tx signal power
    sigmI = 10.^(0.1*(powerDB)); % Calculate the noise variance
    G=(R_HH)*(R_HH + (1/sigmI)*(XX))^(-1);
    Hmmse=((G)*(Hls));
    
    % 1D interpolation for columns
    Hls_i = interp1(PL,Hls,1:Ncarr,'spline');
    Hmmse_i = interp1(PL,Hmmse,1:Ncarr,'spline');
    
    Hls_2d = [Hls_2d Hls_i];
    Hmmse_2d = [Hmmse_2d Hmmse_i];
end

x = pilot_columns;
y = 1:Ncarr;
[X,Y] = meshgrid(x,y);

x_2d = 1:Nsym;
y_2d = 1:Ncarr;
[X_2d,Y_2d] = meshgrid(x_2d,y_2d);
H_est_ls = interp2(X,Y,Hls_2d,X_2d,Y_2d,'spline');
H_est_mmse = interp2(X,Y,Hmmse_2d,X_2d,Y_2d,'spline');
end
