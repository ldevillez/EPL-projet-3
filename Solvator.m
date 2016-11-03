function [x,y] = Solvator(A,B)
%Solvator est une fonction permettant d'approximer les solutions du
%systeme:
%
%   |A(x,y) = 0
%   |B(x,y) = 0
%
%   INPUT:  - A: fonction sous forme de polynome a deux variables
%           - B: fonction sous forme de polynome a deux variables
%
%   OUTPUT: - (x,y) les  valeurs d'approximation des fonction
%
%   Forme polynomial a deux variables:
%
%         X^n \ X ^n-1 \ ... \ X \ 1
%   1
%   Y
%   .
%   Y^n-1
%   Y^n
%
% On utilisera la methode de Newton-Raphson:
%
%   (xK,yK) = [xk-1,yk-1] - J(xk-1,yk-1) * [A(xk-1,yk-1), B(xk-1,yk-1)]

% On derive A et B
[Ax Ay] = devPol(A);
[Bx By] = devPol(B);

% On met a 0 l'approximation precedente
xprev = 0;
yprev = 0; 

% On initialise le nombre d'iteration
ds = 1;

% On donne l'approximation initial
x = 20;
y = 30;

% On donne le seuil admisible pour l'appromation
seuil = 0.01;

% On donne le nombre max d'iteration
limite = 2000;

% On boucle jusqu'avoir une bonne approximation
while ds<=limite && (abs(x-xprev)>=seuil && abs(y-yprev)>=seuil)
    % On remplace l'approximation precedente
    xprev=x;
    yprev=y;
    
    % On calcule la jacobienne de notre systeme
    J = [ComputePol(Ax,xprev,yprev) ComputePol(Ay,xprev,yprev); ComputePol(Bx,xprev,yprev) ComputePol(By,xprev,yprev)];
    
    % On calcul la valeur approche de la sol
    sol = [ComputePol(A,xprev,yprev);ComputePol(B,xprev,yprev)];
    
    %Via la formule de Newton rafton 
    z = [xprev  ; yprev] - (J\sol);
    
    %On remplace x,y par notre nouvelle approximation
    x=z(1);
    y=z(2);
    % On rajoute une iteration
    ds=ds+1;
end

end


function [dX dY] = devPol(A)
%Fonction derivant un polynome a deux var
    dX = A;
    dX(:,end) = [];
    m = size(dX,2);
    n = size(dX,1);
    dX = dX .* repmat(m:-1:1,n,1);
    
    dY = A;
    dY(1,:) = [];
    m = size(dY,2);
    n = size(dY,1);
    dY = dY .* repmat((1:n)',1,m);
    
end

function p = ComputePol(A,x,y)
%Calcule la valeur du'n polynome a deux var
    m = size(A,2);
    n = size(A,1);
    
    X = (x* ones(1,m)).^(m-1:-1:0);
    Y = (y*ones(n,1)).^((0:n-1)');
    
    p=sum(sum((Y*X).*A));
    
end
