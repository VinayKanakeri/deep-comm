function [train_interp] = pilot_interpolate(train_data,pilot_cols,Nant,Ncarr)
% takes 2d images and gived 2d expanded images
% temp1 = 2*pilot_columns - 1;
% temp2 = temp1 + 1;
% pilot_cols = sort([temp2 temp1],'ascend');
x = pilot_cols;
y = 1:Nant;
[X,Y] = meshgrid(x,y);
x_2d = 1:Ncarr;
y_2d = 1:Nant;
[X_2d,Y_2d] = meshgrid(x_2d,y_2d);
train_interp = interp2(X,Y,train_data,X_2d,Y_2d,'spline');
% val_interp = interp2(X,Y,val_data,X_2d,Y_2d,'spline');
% test_interp = interp2(X,Y,test_data,X_2d,Y_2d,'spline');
end
