function [ XSI1 ] = WGS(a, b, c, d, T)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

K = 10 ^(1910 / T - 1.764);
P = 24;

options = optimset('Display','off');

Fct = @(XSI1)[(c+XSI1).*(d+XSI1)./((a-XSI1).*(b-XSI1))- K];
XSI1 = fsolve(Fct,20,options);

end

