% Prompts for some points. Press enter when finished.

function [md,nd] = promptForDiskCentre(rgb)

h = figure('units','normalized','outerposition',[0 0 1 1]);
imshow(rgb)

[x,y] = ginput(Inf);
md = round(y);
nd = round(x);

close(h);