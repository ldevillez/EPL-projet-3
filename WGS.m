function [ XSI1 ] = WGS(a, b, c, d, T)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

K = 10 .^(1910 ./ T - 1.764);
P = 24;

options = optimset('Display','off');

Fct = @(XSI1)[(c+XSI1).*(d+XSI1)./((a-XSI1).*(b-XSI1))- K];
Pol = conv([1 c], [1 d]) - K*conv([-1 a],[-1 b]);
XSI1 = min(roots(Pol));
%XSI1 = solutionFonction(Fct,[20])

end

