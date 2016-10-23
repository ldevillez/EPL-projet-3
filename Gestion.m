function [Tab1 Tab2] = Gestion(FMethRefIN, FEauRefIN, TRefOUT, TWGS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


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
if(~isnumeric(FMethRefIN))
    FMethRefIN = 400;
end
if(~isnumeric(FEauRefIN))
    FEauRefIN = 1500;
end
if(~isnumeric(TRefOUT))
    TRefOUT = 1108;
end
if(~isnumeric(TWGS))
    TWGS = 650;
end


%% Declaration et changement d'unite

cpFour = 1200;%[J/kgK]
cpProc = 2900 ;%[J/kgK]
TFourIN = 300; %[K]
TFourOUT = 1300; %[K]
TRefIN = 300; %[K]

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

%MEC LE PREMIER REACTEUR WGS C'EST PAS DANS LE REFORMEUR DONC IL T'EN
%MANQUE UN CONNARD

%% SECOND REACTEUR WGS

[XSI3] = WGS(FCoRefOUT,FEauRefOUT,FH2RefOUT,FCo2RefOUT,TWGS);

%Si complete alors
%{
    XSI3 = min (FMethRefOUT, FEauRefOUT);
%}

FMethWGSOUT = FMethRefOUT;
FEauWGSOUT = FEauRefOUT- XSI3;
FH2WGSOUT = FH2RefOUT + XSI3;
FCoWGSOUT = FCoRefOUT  - XSI3;
FCo2WGSOUT = FCo2RefOUT + XSI3;


%% ENERGIE
%chauffer gaz reformeur
FQRefChauffe = cpProc * (TRefOUT - TRefIN) * (FMethRefIN * MMeth + FEauRefIN * MEau ) ;

%Energie reformeur
FQRefOUT = XSI1 * 224000 + XSI2 * -34000;

%refroidir gaz refromeur - WGS
FQRefWGSFroid = cpProc * (TRefOUT-TWGS) * (FMethRefOUT * MMeth + FEauRefOUT * MEau ...
    + FH2RefOUT * MH2 + FCoRefOUT * MCo + FCo2RefOUT * MCo2);

%Energie reformeur
FQWGSOUT = XSI3 * -34000;

%Calcul de l'enerige necessaire
FmolFourIN = ChaleurFour((FQRefChauffe + FQRefOUT + FQRefWGSFroid + FQWGSOUT),TFourIN, TFourOUT);

%chauffer gaz four
FQFourChauffe = cpFour * (TFourOUT - TFourIN) *  FmolFourIN * (MMeth + MAir*20/19);

%Energie combustion
FQFour = FmolFourIN *-803000;

FMethFourIN = FmolFourIN;
FO2FourIN = FmolFourIN * 2 * 20/19;
FN2FourIN = FO2FourIN *79/21;
FAirFourIN = FO2FourIN *100/21;

FO2FourOUT = FmolFourIN * 2 * 1/19;
FEauFourOUT = 2 * FmolFourIN;
FCo2FourOUT = FmolFourIN;

%% Metanation
%CHANGER PAR LE MIN FAIS PAS LE CON PHILIPPE

FMethMethOUT = FMethWGSOUT + FCoRefOUT;
FH2MethOUT = FEauWGSOUT - 3*FCoRefOUT;
FEauMethOUT = FCoRefOUT;

%% Resultat

%Meth Eau Co Co2 H2
Tab1 = [FMethRefIN FEauRefIN 0 0 0;...
    FMethRefOUT FEauRefOUT FCoRefOUT FCo2RefOUT FH2RefOUT;...
    FMethWGSOUT FEauWGSOUT FCoWGSOUT FCo2WGSOUT FH2WGSOUT;...
    FMethWGSOUT 0 FCoWGSOUT 0 FH2WGSOUT;...
    FMethMethOUT FEauMethOUT 0 0 FH2MethOUT;...
    FMethMethOUT FEauMethOUT 0 0 FH2MethOUT];
Tab1(end,:) = Tab1(end,:) * 86400  .*[MMeth, MEau, MCo, MCo2, MH2] / 10^3;

%Meth Eau Air
format bank
Tab2 = [FMethFourIN 0 FAirFourIN; FMethFourIN 0 FAirFourIN; FMethFourIN+FMethRefIN FEauRefIN FAirFourIN; FMethFourIN+FMethRefIN FEauRefIN FAirFourIN];
Tab2(2,:) = Tab2(2,:) * 86400  .*[MMeth MEau MAir] / 10^3;
Tab2(4,:) = Tab2(4,:)* 86400  .*[MMeth MEau MAir] / 10^3;
end

