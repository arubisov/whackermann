function [Dx,Dy] = privateTestMeasure(n,v,rgb,depth,Oax,Xax,Yax,PARAMS)

[depth_m,depth_n] = size(depth);

h = figure('units','normalized','outerposition',[0 0 1 1]);
imshow(rgb)

% % For testing
% hold on
% figure(2)
% k = 137;
% scatter3(downsample(X,k),downsample(Y,k),downsample(Z,k),'.')
% xlabel('X')
% ylabel('Y')
% zlabel('Z')
% axis equal

while true
    
    [x,y] = ginput(1);
    if isempty(x) break; end
    md = round(y);
    nd = round(x);

    [Dx,Dy] = privateRGBToWorld(md,nd,n,v,depth_m,depth_n,Oax,Xax,Yax,PARAMS);
    
    
    figure(h)
    title(['x = '  sprintf('%2.2f',Dx) '; y = ' sprintf('%2.2f',Dy) ';']) 
    
    % For testing
%     figure(2)
%     hold on
%     scatter(Dx,Dy,'red','*')
    
end

close(h)