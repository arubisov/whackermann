function [BinOcc] = getBinaryOccupancyGrid(Occ,Known)

pOcc = sum(Occ(:)) / sum(Known(:));

Occ = double(Occ);
Known = double(Known);

NanInd = isnan(Occ./Known);

BinOcc = binocdf(Occ,Known,pOcc);

BinOcc(NanInd) = NaN;