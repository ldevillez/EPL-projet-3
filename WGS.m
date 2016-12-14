function [ XSI1 ] = WGS(a, b, c, d, T,P)

%Constante d'equilibre

dH = -40;
Cp = 2.9; %[KJ/KgK]

FMassique = 1900*10^3/86400;

alpha =  dH/(FMassique * Cp);

K = @(T)10 .^(1910 ./ T - 1.764);

%Fonction sous forme de polynome
fct = @(x)(c+x)(d+x) - K(T+alpha*x)* (a-x) * (b-x);
%{
Pol = conv([1 c], [1 d]) - K(T+alpha*)*conv([-1 a],[-1 b]);
%Racide de ce polynome
XSI1 = min(roots(Pol));
%}
XSI1 = fsolve(fct,20);

end

