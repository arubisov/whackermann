function [Occ,Known,BinOcc] = promptRemoveFromOcc(Occ,Known,BinOcc)

% Prompt for point
h = figure('units','normalized','outerposition',[0 0 1 1]);
imagesc(BinOcc)
set(gca,'YDir','normal')
axis image
xlabel('X')
ylabel('Y')

[x,y] = ginput(1);
if isempty(x), return; end
m = round(y);
n = round(x);
close(h)

Eraser = false(size(Occ));
Eraser(m,n) = true;
Eraser = bwdist(Eraser,'chessboard') < 3;

Occ(Eraser) = 0;
Known(Eraser) = 0;

[BinOcc] = getBinaryOccupancyGrid(Occ,Known);