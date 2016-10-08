function Double_eq()

T1 = 800;
K1 = 10 ^(-11650 / 800 + 13.076);
K2 = 10 ^(1910 / 800 - 1.764);
P = 30;
n1 = 289.36;
n2 = 964;

options = optimset('Display','off');

fct = @(x)[(27.*x.^4) .* P.^2./((n1+n2+x.*2).^2.*(n1-x).*(n2-x)) - K1];

solx = fsolve(fct,27.4,options)
fct(solx)

fct2 = @(x)[x .* (3*solx + x)/((solx-x).*(n2-solx-x)) - K2];

solx = fsolve(fct2,27.1,options)
fct2(solx)
end

