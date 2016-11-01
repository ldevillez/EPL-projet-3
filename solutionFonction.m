function [solutionEq] = solutionFonction(fun, depart)
%SOLUTIONFONCTION r�sout des �quations non lin�aires.
%
%   SOLUTIONFONCTION r�sout des �quations du type f(x) = 0 
%   f est une fonction � une ou plusieurs variables et x est un vecteur
%   dont la dimension correspond au nombre de variables de f.
%
%   On utilise l'algorithme de Newton pour r�soudre ces �quations. 
%   L'algorithme de newton fonctionne grace � la formule suivante :
%
%              f(x) ? f(x0) + f'(x0)*(x-x0)
%
%   On r�sout donc l'�quation: 0 = f(x0) + f'(x0)*(x-x0)
%
%                                                f(x(k))
%   Avec la r�currence �a donne : x(k+1) = x(k)- -------
%                                                f'(x(k))

delt = 0.0001; %Tol�rance de la solution
delta = repmat(delt,size(depart));%Il nous faut un vecteur de m�me longueur que x dans f(x) = 0
x = depart;

%On utilise l'algorithme de Newton pour r�soudre cette �quation. On va donc
%estimer une r�ponse interm�diaire qui � chaque �tape sera un peu plus
%proche de la soltion. On s'arr�te lorsque la solution est tr�s proche de 0
%(� delt*delt pr�s) ou que le gradients'approche de z�ro ce qui 
%signifierait que la fonction n'a pas de solution.
g = [fun(x-delta) fun(x) fun(x+delta)];
grad = gradient(g,delta);
while (fun(x) > 0 + delt*delt | fun(x) < 0 - delt*delt )&( grad > 10^(-15) | grad < -10^(-15))
    g = [fun(x-delta) fun(x) fun(x+delta)];%vecteur n�cessaire au calcul du gradient
    grad = gradient(g,delta);% gradient de la fonction
    x = x - fun(x)./grad(1:length(x));
end

%Si on arr�te la boucle pcq le grad est trop petit, cela signifie peut-�tre
%que 'depart' �tait mal choisi et qu'on ne trouvera pas de solution.
if grad < 10^(-15) & grad > -10^(-15)
    d = fun(x);
    warning('La fonction n a peut-etre pas de solution, f(x) = ');
end
%On ne prend que la dimension qui nous int�resse
solutionEq = x(1:length(depart));
end