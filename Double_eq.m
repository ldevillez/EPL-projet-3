function [xsi1, xsi2]=Double_eq(n1, n2, T1)


K1 = 10 ^(-11650 / T1 + 13.076);
K2 = 10 ^(1910 / T1 - 1.764);
P = 26;


options = optimset('Display','off');


fct = @(V)[(3*V(1)+V(2)).^3 .* (V(1)-V(2)) .* P.^2./((n1-V(1)).*(n2-V(1)-V(2)).*(n1+n2+V(1).*2).^2) - K1; V(2) .* (3*V(1) + V(2))/((V(1)-V(2)).*(n2-V(1)-V(2))) - K2];
sol = fsolve(fct,[50,30],options);
xsi1 = sol(1);
xsi2 = sol(2);

end
