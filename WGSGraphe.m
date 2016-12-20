function [] = WGSGraphe( )

close all

T = 450:0.1:750;
K = @(T) 10 .^(1910 ./ T - 1.764);

dH = -40;
Cp = 2.9; %[KJ/KgK]

FMassique = 1900*10^3/86400;

alpha =  dH/(FMassique * Cp);

FIN1 = 175.66;
FOUT1 = 39.11;
FIN2 = 39.11;
FOUT2 = 3.11;

XSI1 = FIN1 - FOUT1;
XSI2 = FIN2 - FOUT2;



dT1 = XSI1 * alpha;
dT2 = XSI2 * alpha;
%{x
f=figure('Color',[1 1 1]);
plot(T,K(T),'k');
hold on
axis([450 750 0 K(450)])
plot([670 670-dT1], [0,K(670-dT1)],'r')
plot([670-dT1 470], [K(670-dT1),K(670-dT1)],'--k')
plot([470 470-dT2], [K(670-dT1),K(470-dT2)],'b')
title('Evolution de l equilibre dans les reacteur wgs')
xlabel('Température')
ylabel('Constante d équilibre')
legend('Constante d equilibre', 'equilibre dans le premier reacteur',...
    'refroidissement','equilibre dans le second reacteur','location','northeast')
saveas(f,'React.png');
%}x

%OU bien 

%{
f=figure('Color',[1 1 1]);
plot(T,K(T));
hold on
axis([430 700 0 K(430)])
plot([670 670+dT1], [K(670),0],'r')
plot([670 470+dT2], [K(670),K(670)],'--r')
plot([470 470+dT2], [K(470),K(670)],'r')
saveas(f,'React.png');
%}
end

