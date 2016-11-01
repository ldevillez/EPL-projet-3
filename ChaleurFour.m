function [mol]=ChaleurFour(Q, T1, T2)


cpFour = 0.001200;%[J/kgK]

options = optimset('Display','off');


fct = @(V)[Q + cpFour * (T2-T1) * V * (0.016 + 2*0.02896 *20/19* 100/21) + V * -0.803];
mol= solutionFonction(fct,[100]);


end
