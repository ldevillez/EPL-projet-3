function [ output_args ] = Gestion(FMethRefIN, FhydrRefIN, Tref, TWGS )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Declaration et changement d'unite
FMethRefIN = RMethRefIN * 10^6 /86400 % Conversion T/j en mol/s
FHydrRefIN = FHydrRefIN * 10^6 /86400 % Conversion T/j en mol/s

[FMethWGSHTOUT FHydrWGSHTOUT] = Double_eq(

end

