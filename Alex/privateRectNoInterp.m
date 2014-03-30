function [Irec] = privateRectNoInterp(I,~,f,c,k,alpha,KK_new)

[nr,nc] = size(I);

Irec = zeros(nr,nc);

[mx,my] = meshgrid(1:nc, 1:nr);
px = reshape(mx',nc*nr,1);
py = reshape(my',nc*nr,1);

rays = KK_new\[(px - 1)';(py - 1)';ones(1,length(px))];


% Affine transformation:

x = [rays(1,:)./rays(3,:);rays(2,:)./rays(3,:)];


% Add distortion:
xd = apply_distortion(x,k);


% Reconvert in pixels:

px2 = f(1)*(xd(1,:)+alpha*xd(2,:))+c(1);
py2 = f(2)*xd(2,:)+c(2);


% Interpolate between the closest pixels:

px_0 = floor(px2);
py_0 = floor(py2);


good_points = find((px_0 >= 0) & (px_0 <= (nc-2)) & (py_0 >= 0) & (py_0 <= (nr-2)));

px2 = px2(good_points);
py2 = py2(good_points);
px_0 = px_0(good_points);
py_0 = py_0(good_points);

% alpha_x = px2 - px_0;
% alpha_y = py2 - py_0;
% 
% a1 = (1 - alpha_y).*(1 - alpha_x)
% a2 = (1 - alpha_y).*alpha_x
% a3 = alpha_y .* (1 - alpha_x)
% a4 = alpha_y .* alpha_x

ind_lu = px_0 * nr + py_0 + 1;
% ind_ru = (px_0 + 1) * nr + py_0 + 1;
% ind_ld = px_0 * nr + (py_0 + 1) + 1;
% ind_rd = (px_0 + 1) * nr + (py_0 + 1) + 1;

ind_new = (px(good_points)-1)*nr + py(good_points);

Irec(ind_new) = I(ind_lu);

% Irec(ind_new) = a1 .* I(ind_lu) + a2 .* I(ind_ru) + a3 .* I(ind_ld) + a4 .* I(ind_rd);
