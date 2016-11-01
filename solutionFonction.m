function [solutionEq] = solutionFonction(fun, depart)
%SOLUTIONFONCTION résout des équations non linéaires.
%
%   SOLUTIONFONCTION résout des équations du type f(x) = 0 
%   f est une fonction à une ou plusieurs variables et x est un vecteur
%   dont la dimension correspond au nombre de variables de f.
%
%   On utilise l'algorithme de Newton pour résoudre ces équations. 
%   L'algorithme de newton fonctionne grace à la formule suivante :
%
%              f(x) ? f(x0) + f'(x0)*(x-x0)
%
%   On résout donc l'équation: 0 = f(x0) + f'(x0)*(x-x0)
%
%                                                f(x(k))
%   Avec la récurrence ça donne : x(k+1) = x(k)- -------
%                                                f'(x(k))

delt = 0.0001; %Tolérance de la solution
delta = repmat(delt,size(depart));%Il nous faut un vecteur de même longueur que x dans f(x) = 0
x = depart;

%On utilise l'algorithme de Newton pour résoudre cette équation. On va donc
%estimer une réponse intermédiaire qui à chaque étape sera un peu plus
%proche de la soltion. On s'arrête lorsque la solution est très proche de 0
%(à delt*delt près) ou que le gradients'approche de zéro ce qui 
%signifierait que la fonction n'a pas de solution.
g = [fun(x-delta) fun(x) fun(x+delta)];
grad = gradient(g,delta);
while (fun(x) > 0 + delt*delt | fun(x) < 0 - delt*delt )&( grad > 10^(-15) | grad < -10^(-15))
    g = [fun(x-delta) fun(x) fun(x+delta)];%vecteur nécessaire au calcul du gradient
    grad = gradient(g,delta);% gradient de la fonction
    x = x - fun(x)./grad(1:length(x));
end

%Si on arrête la boucle pcq le grad est trop petit, cela signifie peut-être
%que 'depart' était mal choisi et qu'on ne trouvera pas de solution.
if grad < 10^(-15) & grad > -10^(-15)
    d = fun(x);
    warning('La fonction n a peut-etre pas de solution, f(x) = '+ d);
end
%On ne prend que la dimension qui nous intéresse
solutionEq = x(1:length(depart));
end