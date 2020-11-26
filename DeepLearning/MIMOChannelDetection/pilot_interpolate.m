function [H_interp] = pilot_interpolate(H,pilot_columns,Nuser,Ncarr)
temp1 = 2*pilot_columns - 1;
temp2 = temp1 + 1;
pilot_cols = sort([temp2 temp1],'ascend');
x = pilot_cols;
y = 1:Nuser;
[X,Y] = meshgrid(x,y);
H_pilots = H(:,pilot_cols);
x_2d = 1:2*Ncarr;
y_2d = 1:Nuser;
[X_2d,Y_2d] = meshgrid(x_2d,y_2d);
H_interp = interp2(X,Y,H_pilots,X_2d,Y_2d,'spline');
end
