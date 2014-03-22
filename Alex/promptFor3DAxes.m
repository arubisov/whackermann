% Prompts the user to click on the tip of the cones definining the world
% reference frame, may be automated later.

function [Od,Xd,Yd] = promptFor3DAxes(depth,rgb)

h = figure('units','normalized','outerposition',[0 0 1 1]);
subplot(1,2,1)
imagesc(depth)
axis image off
subplot(1,2,2)
imshow(rgb)
subplot(1,2,1)

for i = 1:3,
    switch i,
        case 1,
            title('Get Origin');
        case 2,
            title('Get X Axis');
        case 3,
            title('Get Y Axis');
        otherwise,
            error('switch error')
    end

    [x,y] = ginput(1);
    x = round(x);
    y = round(y);
    s = sub2ind(size(depth),y,x);

    switch i,
        case 1,
            Od = s;
        case 2,
            Xd = s;
        case 3,
            Yd = s;
        otherwise,
            error('switch error')
    end

end

close(h);