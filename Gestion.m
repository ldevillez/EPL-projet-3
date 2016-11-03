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
[XSI3] = WGS(FCoRefOUT,FEauRefOUT,FH2RefOUT,FCo2RefOUT,670);


FMethWGS1OUT = FMethRefOUT;
FEauWGS1OUT = FEauRefOUT- XSI3;
FH2WGS1OUT = FH2RefOUT + XSI3;
FCoWGS1OUT = FCoRefOUT  - XSI3;
FCo2WGS1OUT = FCo2RefOUT + XSI3;


%% SECOND REACTEUR WGS

[XSI4] = WGS(FCoWGS1OUT,FEauWGS1OUT,FH2WGS1OUT,FCo2WGS1OUT,TWGS);


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
FQRefWGSFroid = cpProc * (TWGS - TRefOUT) * (FMethRefOUT * MMeth + FEauRefOUT * MEau ...
    + FH2RefOUT * MH2 + FCoRefOUT * MCo + FCo2RefOUT * MCo2);

%Energie WGS1
FQWGS1OUT = XSI3 * -0.040000;

%refroidir gaz WGS1 - WGS2
FQWGS1WGS2Froid = cpProc * (470 -TWGS) * (FMethWGS1OUT * MMeth + FEauWGS1OUT * MEau ...
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

