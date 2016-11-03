function [xsi1, xsi2]=Double_eq(n1, n2, T1)

%Calcul des constantes d'équilibre
K1 = 10 .^(-11650 ./ T1 + 13.076);
K2 = 10 .^(1910 ./ T1 - 1.764);
P = 26;


%Forme matriciel de nos fonction tel que:
%   Forme polynomial a deux variables:
%
%         X^n \ X ^n-1 \ ... \ X \ 1
%   1
%   Y
%   .
%   Y^n-1
%   Y^n
%



%Diverse varaible permettant de construire les polynomes sous forme
%matriciel
a = diag([27 27 9 1]);
b = diag([1 -1]);
c = [-1 n1];
d = [-1 n2;0 -1; 0 0; 0 0; 0 0];
pop = (n1+n2)^2;
e = [4 4*n1+4*n2 pop];

Q = (conv2(a,b).*P^2)-K1*(conv2(conv2(c,d),e));
R = ([0 0 0;0 3 0;0 0 1]-K2*[-1 n2 0; 0 0 -n2; 0 0 1]);

[xsi1, xsi2]=Solvator(Q,-R);


end
