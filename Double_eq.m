function [xsi1, xsi2]=Double_eq(n1, n2, T1)


K1 = 10 .^(-11650 ./ T1 + 13.076);
K2 = 10 .^(1910 ./ T1 - 1.764);
P = 26;


options = optimset('Display','off');


%fct = @(V)[(3*V(1)+V(2)).^3 .* (V(1)-V(2)) .* P.^2./((n1-V(1)).*(n2-V(1)-V(2)).*(n1+n2+V(1).*2).^2) - K1;V(2) .* (3*V(1) + V(2))/((V(1)-V(2)).*(n2-V(1)-V(2))) - K2];

a = diag([27 27 9 1]);
b = diag([1 -1]);
c = [-1 n1];
d = [-1 n2;0 -1; 0 0; 0 0; 0 0];
pop = (n1+n2)^2;
e = [4 4*n1+4*n2 pop];

Q = (conv2(a,b).*P^2)-K1*(conv2(conv2(c,d),e));
R = ([0 0 0;0 3 0;0 0 1]-K2*[-1 n2 0; 0 0 -n2; 0 0 1]);

[xsi1 xsi2]=Sherminator2(Q,-R);


end
