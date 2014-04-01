function [X,Y,Z] = privateRotateAboutVFromTo(X,Y,Z,n,v)

tar_o = [0; 0; 1];
R = privateRotateFromTo(tar_o,n);
XYZ = R * [X' - v(1); Y' - v(2); Z' - v(3)];
X = XYZ(1,:);
Y = XYZ(2,:);
Z = XYZ(3,:);