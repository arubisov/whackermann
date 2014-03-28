function [BinOcc] = getBinaryOccupancyGrid(Occ,Known)

pOcc = sum(Occ(:)) / sum(Known(:));

Occ = double(Occ);
Known = double(Known);
% Known(Known<3) = 0;

NanInd = isnan(Occ./Known);

% nz = Known ~= 0;

% GridLog = log10(double(Occ)./double(Known)) - log10(1-(double(Occ)./double(Known)));
% ppOcc = pOcc.^Occ;
% ppnOcc = (1-pOcc).^(Known-Occ);
% nCr, sum(
% BinOcc = factorial(Known)./factorial(Occ)./factorial(Known-Occ) .* ppOcc .* ppnOcc;

BinOcc = binocdf(Occ,Known,pOcc);

BinOcc(NanInd) = NaN;

% BinOcc = GridLog;