function [Occ,Known,BinOcc] = undrawOccWall(Occ,Known,pt)

% Prompt for point
m = round(pt(2));
n = round(pt(1));

Eraser = false(size(Occ));
Eraser(m,n) = true;
Eraser = bwdist(Eraser,'chessboard') < 3;

Occ(Eraser) = 0;
Known(Eraser) = 0;

[BinOcc] = getBinaryOccupancyGrid(Occ,Known);