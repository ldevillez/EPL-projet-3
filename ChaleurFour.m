function [mol]=ChaleurFour(Q, T1, T2)


cpFour = 1200;%[J/kgK]

options = optimset('Display','off');


fct = @(V)[Q + cpFour * (T2-T1) * V * (0.016 + 2*0.0296 *20/19* 100/21) + V * -803000];
mol= fsolve(fct,[200],options);


end
