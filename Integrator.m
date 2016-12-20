function [] =Integrator()
Ha = 3000;
kl = 25/3600;
kg = 80/(3600*10.^2);
CO2In = 245381/3600;
CO2Out = 81793/3600;
VNaOH = 6*10^6/(3600*10^3);
CBIn = 100;
NaOHIn = VNaOH * CBIn;
CBOut = 45.5;
PaIn = 15199;
PaOut = 5629;
G = 34000 * 101325 /(298.15 * 8.314 * 3600 * pi * 1.5^2);
nInerte = 34000 * 101325/(8.314*298.15*3600);

DenomRa = 1/kg +Ha/kl;

syms Ya;
close all
Pa = Ya /(1 + Ya) .* 101325;
CB = (NaOHIn + 2*CO2Out - 2*Ya .* nInerte)./VNaOH;

dh = G .* DenomRa./(Pa + Ha .*CB);

dyaIn = 15/85;
dyaOut = 1/18;
H = double(int(dh,dyaOut,dyaIn));

Hid = sqrt(50);
X = round(H/Hid);
H100 = H;
Xp = 1:X*2;
Hp = H./Xp;
C = Xp .* (50000 + 1000 .* Hp.^2);
Cf = X.*(50000 + 1000 .* (H./X).^2);
a = figure('Color',[1 1 1]);
hold on
yyaxis('left')
plot(Xp,C,'-o')
title('Variation du prix de construction en fonction du nombre de colonne');
xlabel('Nombre de colonnes')
ylabel('Prix [euros]');
yyaxis('right')
plot(Xp,Hp,'-o');
ylabel('Hauteur des colonnes [m]')
hold off
W = [Hp;Xp;C]';
fprintf('Hauteur | Nombre de colonne |  prix \n')
fprintf(' %6.2f | %17.2f | %4.2f \n',W(1,:),W(2,:),W(3,:))


CBInV = linspace(70,130,200);
NaOHIn = VNaOH * CBInV;
CB = (NaOHIn + 2*CO2Out - 2*Ya .* nInerte)./VNaOH;
dh = G .* DenomRa./(Pa + Ha .*CB);
Hauteur = double(int(dh,dyaOut,dyaIn));
figure('Color',[1 1 1])
plot(CBInV/1000,Hauteur,'-r');hold on;
plot(100/1000,H,'.b','MarkerSize',30);
plot(0.1.*ones(1,100),linspace(8,H,100),'-.b');
plot(linspace(0.07,0.1,100),H.*ones(1,100),'-. black');
title('Hauteur de la colonne en fonction de la concentration de NaOH entrant');
xlabel('Concentration [mol/l]');
ylabel('Hauteur de la colonne [m]');
hold off
H = Hauteur;

Cf2 = (50000 + 1000 * (Hauteur(181)).^2);
Cf3 = 3*(50000 + 1000 * (Hauteur(44)/3).^2);
c = figure('Color',[1 1 1]);
hold on
Xfinal = round(H./Hid);
Hfinal = H./Xfinal;
C = Xfinal .*(50000 + 1000 .* Hfinal.^2);
plot(CBInV/1000,(50000 + 1000 .* H.^2));
plot(CBInV/1000,2*(50000 + 1000 .* (H/2).^2));
plot(CBInV/1000,3*(50000 + 1000 .* (H/3).^2));
plot(100/1000,Cf,'.b','MarkerSize',30);
plot([0, 0.1 0.1],[Cf Cf 0],'-.b');
plot(CBInV(181)/1000,Cf2,'.r','MarkerSize',30);
plot([0, CBInV(181) CBInV(181)]/1000,[Cf2 Cf2 0],'-.r');
plot(CBInV(44)/1000,Cf3,'.m','MarkerSize',30);
plot([0, CBInV(44) CBInV(44)]/1000,[Cf3 Cf3 0],'-.m');
xlim([0.07 0.13])
title('Variation du prix de construction en fonction de la concentration de NaOH');
xlabel('Concentration [mol/l]');
ylabel('Prix [euro]');
legend('1 colonne','2 colonnes','3 colonnes');
fprintf('\n\nConcentration | Hauteur |  prix \n')
fprintf(' %12.3f | %7.2f | %4.2f \n',[CBInV(44)/1000,Hauteur(44),Cf3],[0.1,H100,Cf],[CBInV(181)/1000,Hauteur(181),Cf2])

figure('Color',[1 1 1])
plot(CBInV/1000,Hauteur);hold on;
plot(CBInV/1000,Hauteur./2);
plot(CBInV/1000,Hauteur./3);
title('Variation de la hauteur en fonction de la concentration de NaOH');
xlabel('Concentration [mol/l]');
ylabel('Hauteur [m]');
legend('1 colonne','2 colonnes','3 colonnes');
%% INTEG
dh = G ./(Pa.*kg);
h = double(int(dh,dyaOut,dyaIn))

CB = linspace(190,488,100);
pamax = CB * kl ./kg

end

