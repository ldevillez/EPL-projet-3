function [solutionEq] = solutionFonction(fun, depart)
%SOLUTIONFONCTION resout des equations non lineaires.
%
%   SOLUTIONFONCTION resout des equations du type f(x) = 0 
%   f est une fonction e une variable et x est un nombre
%
%   On utilise l'algorithme de Newton pour resoudre ces equations. 
%   L'algorithme de newton fonctionne grace e la formule suivante :
%
%              f(x) = f(x0) + f'(x0)*(x-x0)
%
%   On resout donc l'equation: 0 = f(x0) + f'(x0)*(x-x0)
%
%                                                f(x(k))
%   Avec la recurrence ca donne : x(k+1) = x(k)- -------
%                                                f'(x(k))

delt = 0.0001; %Tolerance de la solution
delta = repmat(delt,size(depart));%Il nous faut un vecteur de meme longueur que x dans f(x) = 0
x = depart;

%On utilise l'algorithme de Newton pour resoudre cette equation. On va donc
%estimer une reponse intermediaire qui e chaque etape sera un peu plus
%proche de la soltion. On s'arrete lorsque la solution est tres proche de 0
%(e delt*delt pres) ou que le gradients'approche de zero ce qui 
%signifierait que la fonction n'a pas de solution.
g = [fun(x-delta) fun(x) fun(x+delta)];
grad = gradient(g,delta);
while (fun(x) > 0 + delt*delt | fun(x) < 0 - delt*delt )&( grad > 10^(-15) | grad < -10^(-15))
    g = [fun(x-delta) fun(x) fun(x+delta)];%vecteur necessaire au calcul du gradient
    grad = gradient(g,delta);% gradient de la fonction
    x = x - fun(x)./grad(1:length(x));
end

%Si on arrete la boucle pcq le grad est trop petit, cela signifie peut-etre
%que 'depart' etait mal choisi et qu'on ne trouvera pas de solution.
if grad < 10^(-15) & grad > -10^(-15)
    d = fun(x);
    warning('La fonction n a peut-etre pas de solution, f(x) = '+ d);
end
%On ne prend que la dimension qui nous interesse
solutionEq = x(1:length(depart));
end