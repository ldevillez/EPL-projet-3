function [Tab1, Tab2,Tab3,Purete] = Gestion(FMethRefIN, FEauRefIN, TRefOUT, TWGS )
% Gestion est une fonction permettant de calculer tout les flux present
% dans notre usine de production d'H2. Il faut lui fournir le flux de Ch4
% et le flux de H2O rentrant dans le reformeur sous forme de T/J. Il faut
% aussi lui fournir la température de sortie du reformeur et du second
% réacteur Wgs.
%
%   INPUT:  -FMethRefIN: Flux de Ch4 rentrant dans le reformeur [T/j]
%           -FEauRefIN: Flux d'H2O rentrant dans le reformeur [T/j]
%           -TRefOUT: Temperature de sortie du reformeur [K]
%           -TWGS: Temperature de sortie du 2eme reacteur WGS [K]
% 
%   OUTPUT: -Tab1: Tableau contenant les flux entrant des != composes aux
%       differentes etapes:
%                         CH4  \  H2O  \ CO  \  CO2  \  H2
%   Reformeur[mol/s]
%   1er WGS[mol/s]
%   2eme WGS[mol/s]
%   Refroidissent[mol/s]
%   Methanation[mol/s]
%   sortie[mol/s]
%   sortie[T/j]
%
%           -Tab2: Tableau contenant les Flux entrant des != composes dans 
%           le four et au total:
%                       CH4  \ H2O  \ O2  \  N2  \ Air
%   Four[mol/s]
%   Four[T/J]
%   Total[mol/s]
%   Total[T/J]
%
%           -Tab3: Tableau contenant les flux de chaleur au sein du procede
%           et indique si ils sont recu ou cede [MJ]
%   Four: Augmenter la temprature 
%   Four: Combustion
%   Reformeur: Augmenter la temperature
%   Reformeur: Reaction
%   WGS1: Diminuer la temperature
%   WGS1: Reaction
%   WGS2: Diminuer la temperature
%   WGS2: Reaction
%
%           -Purete: Indique la purete d'H2 c'est a dire le flux molaire de
%           H2 sortant sur le flux molaire de Ch4 et H2 sortant
%


%% Indication Notation
%F = flux
%Q = chaleur
%ref = reformateur
%WGS = watergazshift
%Meth = methane
%Eau = eau
%H2 = H2
%C0 = CO
%CO2 = CO2

%% On met des parametre par default si besoin
if(~isnumeric(FMethRefIN)|isempty(FMethRefIN))
    FMethRefIN = 400;
end
if(~isnumeric(FEauRefIN)|isempty(FEauRefIN))
    FEauRefIN = 1500;
end
if(~isnumeric(TRefOUT)|isempty(TRefOUT))
    TRefOUT = 1108;
end
if(~isnumeric(TWGS)|isempty(TWGS))
    TWGS = 650;
end

format long
%% Declaration et changement d'unite

cpFour = 0.001200;%[MJ/kgK]
cpProc = 0.002900 ;%[MJ/kgK]
TFourIN = 300; %[K]
TFourOUT = 1300; %[K]
TRefIN = 300; %[K]

% Masse molaire [Kg]
MMeth = 0.016;
MEau = 0.018;
MH2 = 0.002;
MCo = 0.028;
MCo2 = 0.044;
MAir = 0.0296;
MO2 = 0.032;
MN2 = 0.028;

FMethRefIN = FMethRefIN * 10^3 /86400 / MMeth; % Conversion T/j en mol/s
FEauRefIN = FEauRefIN * 10^3 /86400 / MEau; % Conversion T/j en mol/s

%% Double equilibre
[XSI1, XSI2] = Double_eq(FMethRefIN,FEauRefIN,TRefOUT);

FMethRefOUT = FMethRefIN - XSI1;
FEauRefOUT = FEauRefIN - XSI1 - XSI2;
FH2RefOUT = 3 * XSI1 + XSI2;
FCoRefOUT = XSI1 - XSI2;
FCo2RefOUT = XSI2;

%% PREMIER REACTEUR WGS
[XSI3] = WGS(FCoRefOUT,FEauRefOUT,FH2RefOUT,FCo2RefOUT,670,26);


FMethWGS1OUT = FMethRefOUT;
FEauWGS1OUT = FEauRefOUT- XSI3;
FH2WGS1OUT = FH2RefOUT + XSI3;
FCoWGS1OUT = FCoRefOUT  - XSI3;
FCo2WGS1OUT = FCo2RefOUT + XSI3;


%% SECOND REACTEUR WGS

[XSI4] = WGS(FCoWGS1OUT,FEauWGS1OUT,FH2WGS1OUT,FCo2WGS1OUT,TWGS,24);


FMethWGS2OUT = FMethWGS1OUT;
FEauWGS2OUT = FEauWGS1OUT- XSI4;
FH2WGS2OUT = FH2WGS1OUT + XSI4;
FCoWGS2OUT = FCoWGS1OUT  - XSI4;
FCo2WGS2OUT = FCo2WGS1OUT + XSI4;


%% ENERGIE
%chauffer gaz reformeur
FQRefChauffe = cpProc * (TRefOUT - 800) * (FMethRefIN * MMeth + FEauRefIN * MEau ) ;

%Energie reformeur
FQRefOUT = XSI1 * 0.224000 + XSI2 * -0.034000;

%refroidir gaz refromeur - WGS1
FQRefWGSFroid = cpProc * (670 - TRefOUT) * (FMethRefOUT * MMeth + FEauRefOUT * MEau ...
    + FH2RefOUT * MH2 + FCoRefOUT * MCo + FCo2RefOUT * MCo2);

%Energie WGS1
FQWGS1OUT = XSI3 * -0.040000;

%refroidir gaz WGS1 - WGS2
FQWGS1WGS2Froid = cpProc * (670 -TWGS) * (FMethWGS1OUT * MMeth + FEauWGS1OUT * MEau ...
    + FH2WGS1OUT * MH2 + FCoWGS1OUT * MCo + FCo2WGS1OUT * MCo2);

%Energie WGS2
FQWGS2OUT = XSI4* -0.040000;

%Calcul de l'enerige necessaire
FmolFourIN = ChaleurFour((FQRefChauffe + FQRefOUT),TFourIN, TFourOUT);

%chauffer gaz four
FQFourChauffe = cpFour * (TFourOUT - TFourIN) *  FmolFourIN * (0.016 + 2*0.02896 *20/19* 100/21);

%Energie combustion
FQFour = FmolFourIN *-0.803000;

FMethFourIN = FmolFourIN;
FO2FourIN = FmolFourIN * 2 * 20/19;
FN2FourIN = FO2FourIN *79/21;
FAirFourIN = FO2FourIN *100/21;

FO2FourOUT = FmolFourIN * 2 * 1/19;
FEauFourOUT = 2 * FmolFourIN;
FCo2FourOUT = FmolFourIN;

%% Metanation

FMethMethOUT = FMethWGS2OUT + FCoWGS2OUT;
FH2MethOUT = FH2WGS2OUT - 3*FCoWGS2OUT;
FEauMethOUT = FCoWGS2OUT;

%% Resultat

%On stock dans les tableaux

%Meth Eau Co Co2 H2
Tab1 = [FMethRefIN FEauRefIN 0 0 0;...
    FMethRefOUT FEauRefOUT FCoRefOUT FCo2RefOUT FH2RefOUT;...
    FMethWGS1OUT FEauWGS1OUT FCoWGS1OUT FCo2WGS1OUT FH2WGS1OUT;...
    FMethWGS2OUT FEauWGS2OUT FCoWGS2OUT FCo2WGS2OUT FH2WGS2OUT;...
    FMethWGS2OUT 0 FCoWGS2OUT 0 FH2WGS2OUT;...
    FMethMethOUT FEauMethOUT 0 0 FH2MethOUT;...
    FMethMethOUT FEauMethOUT 0 0 FH2MethOUT];
Tab1(end,:) = Tab1(end,:) * 86400  .*[MMeth, MEau, MCo, MCo2, MH2] / 10^3;

%Meth Eau O2 N2 Air
format bank
Tab2 = [FMethFourIN 0 FO2FourIN FN2FourIN FAirFourIN;...
    FMethFourIN 0 FO2FourIN FN2FourIN FAirFourIN;...
    FMethFourIN+FMethRefIN FEauRefIN FO2FourIN FN2FourIN FAirFourIN;...
    FMethFourIN+FMethRefIN FEauRefIN FO2FourIN FN2FourIN FAirFourIN];
Tab2(2,:) = Tab2(2,:) * 86400  .*[MMeth MEau MO2 MN2 MAir] / 10^3;
Tab2(4,:) = Tab2(4,:)* 86400  .*[MMeth MEau MO2 MN2 MAir] / 10^3;

%Chaleur
Tab3 = {FQFourChauffe FQFour FQRefChauffe FQRefOUT FQRefWGSFroid FQWGS1OUT FQWGS1WGS2Froid FQWGS2OUT;...
    'Donnee', 'Reçue', 'Donnee', 'Donnee', 'reçue', 'reçue', 'reçue', 'reçue'}';

%Purete
Purete =FH2MethOUT/(FMethMethOUT + FH2MethOUT);

end

function [mol]=ChaleurFour(Q, T1, T2)

%Cp du four
cpFour = 0.001200;%[J/kgK]
%Fonction dont on chercher la solution =0
fct = @(V)[Q + cpFour * (T2-T1) * V * (0.016 + 2*0.02896 *20/19* 100/21) + V * -0.803];
mol= solutionFonction(fct,[100]);


end

function [ XSI1 ] = WGS(a, b, c, d, T,P)

%Constante d'equilibre

K = 10 .^(1910 ./ T - 1.764);

%Fonction sous forme de polynome
Pol = conv([1 c], [1 d]) - K*conv([-1 a],[-1 b]);
%Racide de ce polynome
XSI1 = min(roots(Pol));


end

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
