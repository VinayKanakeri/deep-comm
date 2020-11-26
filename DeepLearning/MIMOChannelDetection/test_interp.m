Nuser = 5;
Ncarr = 64;
[x,y] = meshgrid(1:1:2*Ncarr,1:1:Nuser);  % just to get some x and y values
z = [];
for i=1:Ncarr
    temp = [real(DeepMIMO_dataset{1,1}.user{1,100}.channel(:,i)) imag(DeepMIMO_dataset{1,1}.user{1,1}.channel(:,i))];
    z = [z temp];
end
pilot_columns = 1:6:Ncarr;
H_interp = pilot_interpolate(z,pilot_columns,Nuser,Ncarr);

%z = [real(DeepMIMO_dataset{1,1}.user{1,100}.channel) imag(DeepMIMO_dataset{1,1}.user{1,1}.channel)];
% surf(x,y,z)
% shading interp
% set(gca,'cameraposition',[0 0 180])  % this essentially turns a 3d surface plot into a 2d plot
% colormap(flipud(jet))
figure(1)
contourf(x,y,z)
colorbar
figure(2)
contourf(x,y,H_interp)
colorbar