function [ ] = ShowMeYouSoul( )

%WGS

T1 = 470:670;

purete = zeros(size(T1));
prod = zeros(size(T1));
for i =1:length(T1)
[tab1 tab2 tab3 purete(i)] = Gestion(400,1500,1180,T1(i));
prod(i) = tab1(end,end)/1900;
%prod(i) = tab1(end,end);
end
figure;
hold on
yyaxis left
plot(T1,purete);
yyaxis right
plot(T1,prod);
yyaxis left
title('Production et purete de H2 en fonction de la temperature de sortie du second reacteur WGS')
xlabel('Temperature [K]')
ylabel('Purete [%]')
legend('Purete','Production')
yyaxis right
ylabel('Masse d H2 sur la Masse d entre')

hold off

figure;
%REF

T1 = 1020:1220;

purete = zeros(size(T1));
prod = zeros(size(T1));
for i =1:length(T1)
[tab1 tab2 tab3 purete(i)] = Gestion(400,1500,T1(i),470);
prod(i) = tab1(end,end)/1900;
%prod(i) = tab1(end,end);
end

hold on
yyaxis left
plot(T1,purete);
yyaxis right
plot(T1,prod);
yyaxis left
title('Production et purete de H2 en fonction de la temperature de sortie du Reformeur')
xlabel('Temperature [K]')
ylabel('Purete [%]')
legend('Purete','Production','Location','SouthEast')
yyaxis right
ylabel('Masse d H2 sur la Masse d entre')

hold off


figure;
%MOLL

R = 3:0.01:3.5;
H = R * 400 *18/16;

purete = zeros(size(H));
prod = zeros(size(H));
for i =1:length(H)
[tab1 tab2 tab3 purete(i)] = Gestion(400,H(i),1180,470);
prod(i) = tab1(end,end)/1900;
%prod(i) = tab1(end,end);
end

hold on
yyaxis left
plot(R,purete);
yyaxis right
plot(R,prod);
yyaxis left
title('Production et purete de H2 en fonction du rapport molaire H2O/CH4')
xlabel('Rapport molaire')
ylabel('Purete [%]')
legend('Purete','Production','Location','SouthEast')
yyaxis right
ylabel('Masse d H2 sur la Masse d entre')

hold off


