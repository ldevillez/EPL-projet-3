function [ output_args ] = Gestion(FMethRefIN, FHydrRefIN, Tref, TWGS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% On met des parametre par default si besoin
if(isempty(FMethRefIN))
    FMethRefIN = 400;
end
if(isempty(FHydrRefIN))
    FHydrRefIN = 1500;
end
if(isempty(Tref))
    Tref = 1108;
end
if(isempty(TWGS))
    TWGS = 650;
end


%% Declaration et changement d'unite
FMethRefIN = FMethRefIN * 10^6 /86400; % Conversion T/j en mol/s
FHydrRefIN = FHydrRefIN * 10^6 /86400; % Conversion T/j en mol/s

%% Double equilibre
[XSI1, XSI2] = Double_eq(FMethRefIN,FHydrRefIN,Tref);

FMethRefOUT = FMethRefIN - XSI1;
FHydrRefOUT = FHydrRefIN - XSI1 - XSI2;
FH2RefOUT = 3 * XSI1 + XSI2;
FCoRefOUT = XSI1 - XSI2;
FCo2RefOUT = XSI2;

FQRefOUT = XSI1 * 224 + XSI2 * -34;

%% SECOND REACTEUR WGS

[XSI3] = WGS(FMethRefOUT,FHydrRefOUT,FH2RefOUT,FCo2RefOUT,TWGS);

FMethWGSOUT = FMethRefOUT - XSI3;
FHydrWGSOUT = FHydrRefOUT- XSI3;
FH2WGSOUT = FH2RefOUT + XSI3;
FCo2WGSOUT = FCo2RefOUT + XSI3;

FQWGSOUT = XSI3 * -34;



end

