function [] = plot_random_samples(data,labels,plot_type,filename)

[x,y] = meshgrid(1:1:size(data,2),1:1:size(data,1));
samples = randi(size(data,4),1,4);

if(strcmp(plot_type,'surf'))
    subplot(4,2,1)
    surf(x,y,data(:,:,1,samples(1,1)))
    xlabel('subcarriers');
    ylabel('antennas');
    title('data')
    
    subplot(4,2,2)
    surf(x,y,labels(:,:,1,samples(1,1)))
    xlabel('subcarriers');
    ylabel('antennas');
    title('labels')
    
    subplot(4,2,3)
    surf(x,y,data(:,:,1,samples(1,2)))
    xlabel('subcarriers');
    ylabel('antennas');
    
    subplot(4,2,4)
    surf(x,y,labels(:,:,1,samples(1,2)))
    xlabel('subcarriers');
    ylabel('antennas');
    
    subplot(4,2,5)
    surf(x,y,data(:,:,1,samples(1,3)))
    xlabel('subcarriers');
    ylabel('antennas');
    
    subplot(4,2,6)
    surf(x,y,labels(:,:,1,samples(1,3)))
    xlabel('subcarriers');
    ylabel('antennas');
    
    
    
    subplot(4,2,7)
    surf(x,y,data(:,:,1,samples(1,4)))
    xlabel('subcarriers');
    ylabel('antennas');
    
    subplot(4,2,8)
    surf(x,y,labels(:,:,1,samples(1,4)))
    xlabel('subcarriers');
    ylabel('antennas');
end

if(strcmp(plot_type,'contour'))
    subplot(4,2,1)
    contourf(x,y,data(:,:,1,samples(1,1)))
    xlabel('subcarriers');
    ylabel('antennas');
    title('data')
    colorbar
    
    subplot(4,2,2)
    contourf(x,y,labels(:,:,1,samples(1,1)))
    xlabel('subcarriers');
    ylabel('antennas');
    title('labels')
    colorbar
    
    subplot(4,2,3)
    contourf(x,y,data(:,:,1,samples(1,2)))
    xlabel('subcarriers');
    ylabel('antennas');
    colorbar
    
    subplot(4,2,4)
    contourf(x,y,labels(:,:,1,samples(1,2)))
    xlabel('subcarriers');
    ylabel('antennas');
    colorbar
    
    subplot(4,2,5)
    contourf(x,y,data(:,:,1,samples(1,3)))
    xlabel('subcarriers');
    ylabel('antennas');
    colorbar
    
    subplot(4,2,6)
    contourf(x,y,labels(:,:,1,samples(1,3)))
    xlabel('subcarriers');
    ylabel('antennas');
    colorbar
    
    
    subplot(4,2,7)
    contourf(x,y,data(:,:,1,samples(1,4)))
    xlabel('subcarriers');
    ylabel('antennas');
    colorbar
    
    subplot(4,2,8)
    contourf(x,y,labels(:,:,1,samples(1,4)))
    xlabel('subcarriers');
    ylabel('antennas');
    colorbar
end
saveas(gcf,filename)
end
