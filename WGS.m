function [ XSI1 ] = WGS(a, b, c, d, T)

%Constante d'equilibre

K = 10 .^(1910 ./ T - 1.764);
P = 24;

%Fonction sous forme de polynome
Pol = conv([1 c], [1 d]) - K*conv([-1 a],[-1 b]);
%Racide de ce polynome
XSI1 = min(roots(Pol));


end

