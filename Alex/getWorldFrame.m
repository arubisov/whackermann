% Returns the 3D Points representing the axes which define the world frame.

function [Oax,Xax,Yax,Oax3,Xax3,Yax3] = getWorldFrame(X,Y,Z,ImInd,n,v,depth,rgb)

% Find the tip of the cones manually (Current) or automatically (TODO). Tip
% of cones returned with respect to 2D images.
[Od,Xd,Yd] = promptFor3DAxes(depth,rgb);

% Find the 3D points associated with the cone tops
for i = 1:3,
    switch i
        case 1,
            ind = find(ImInd == Od);
            Oax3 = [X(ind); Y(ind); Z(ind)];
        case 2,
            ind = find(ImInd == Xd);
            Xax3 = [X(ind); Y(ind); Z(ind)];
        case 3,
            ind = find(ImInd == Yd);
            Yax3 = [X(ind); Y(ind); Z(ind)];
        otherwise,
            error('switch error')
    end
    if length(ind) ~= 1, error('find index error'); end
end

% Project 3D Points onto the ground plane
Oax = (Oax3 - v) - ((Oax3 - v)'*n)/(n'*n)*n + v;
Xax = (Xax3 - v) - ((Xax3 - v)'*n)/(n'*n)*n + v;
Yax = (Yax3 - v) - ((Yax3 - v)'*n)/(n'*n)*n + v;

