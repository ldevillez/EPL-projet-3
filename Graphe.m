function [ ] = ShowMeYourSoul( )
close all;

%WGS

T1 = 470:670;

purete = zeros(size(T1));
prod = zeros(size(T1));
ch4 = zeros(size(T1));
for i =1:length(T1)
[tab1 tab2 tab3 purete(i)] = Gestion(400,1500,1180,T1(i));
prod(i) = tab1(end,end)/1900;
ch4(i) = tab2(2,1);
%prod(i) = tab1(end,end);
end
a = figure('Color',[1 1 1]);
plottools(a,'on');
hold on
yyaxis left
plot(T1,purete);
yyaxis right
plot(T1,prod);
yyaxis left
title({'Production et purete de H_{2} en fonction de la temperature';' de sortie du second reacteur WGS'})
xlabel('Temperature [K]')
ylabel('Purete [%]')
legend('Purete','Production')
yyaxis right
ylabel('Masse d H_{2} sur la Masse d entre')
saveas(a,'Tref.png');
hold off

b = figure('Color',[1 1 1]);
plottools(b,'on');
hold on
plot(T1,ch4);

title({'Flux de CH_{4} entrant dans le four en fonction de la temperature';' de sortie du second reacteur WGS'})
xlabel('Temperature [K]')
ylabel('CH_{4} [T/J]')
legend('CH_{4} entrant dans le four')
hold off
saveas(b,'CH4Ref.png');

c = figure('Color',[1 1 1]);
plottools(c,'on');
%REF

T1 = 1020:1220;

purete = zeros(size(T1));
prod = zeros(size(T1));
for i =1:length(T1)
[tab1 tab2 tab3 purete(i)] = Gestion(400,1500,T1(i),470);
prod(i) = tab1(end,end)/1900;
ch4(i)=tab2(2,1);
%prod(i) = tab1(end,end);
end

hold on
yyaxis left
plot(T1,purete);
yyaxis right
plot(T1,prod);
yyaxis left
title({'Production et purete de H_{2} en fonction de la temperature';' de sortie du Reformeur'})
xlabel('Temperature [K]')
ylabel('Purete [%]')
legend('Purete','Production','Location','SouthEast')
yyaxis right
ylabel('Masse d H_{2} sur la Masse d entre')
saveas(c,'TWgs.png');
hold off

d=figure('Color',[1 1 1]);
plottools(d,'on');
hold on
plot(T1,ch4);

title({'Flux de CH_{4} entrant dans le four en fonction de la temperature';' du Reformeur'})
xlabel('Temperature [K]')
ylabel('CH_{4} [T/J]')
legend('CH_{4} entrant dans le four','location','southeast')
hold off
saveas(d,'CH4Wgs.png');

e=figure('Color',[1 1 1]);
plottools(e,'on');
%MOLL

R = 3:0.01:3.5;
H = R * 400 *18/16;

purete = zeros(size(H));
prod = zeros(size(H));
ch4 = zeros(size(H));
for i =1:length(H)
[tab1 tab2 tab3 purete(i)] = Gestion(400,H(i),1180,470);
prod(i) = tab1(end,end)/1900;
%prod(i) = tab1(end,end);
ch4(i) = tab2(2,1);
end

hold on
yyaxis left
plot(R,purete);
yyaxis right
plot(R,prod);
yyaxis left
title('Production et purete de H_{2} en fonction du rapport molaire H_{2}O/CH_{4}')
xlabel('Rapport molaire')
ylabel('Purete [%]')
legend('Purete','Production','Location','SouthEast')
yyaxis right
ylabel('Masse d H_{2} sur la Masse d entre')
saveas(e,'Rapport.png');
hold off

f=figure('Color',[1 1 1]);
plottools(f,'on');
hold on
plot(R,ch4);

title('Flux de CH_{4} entrant dans le four en fonction du rapport molaire H_{2}O/CH_{4}')
xlabel('Rapport molaire')
ylabel('CH_{4} [T/J]')
legend('CH_{4} entrant dans le four','location','southeast')
hold off
saveas(f,'CH4Rapport.png');


