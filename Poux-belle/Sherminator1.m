function [x,y] = Sherminator1(A,B,Ax,Ay,Bx,By,X0,Y0)

    
    P = [X0,Y0]';
    seuil = 10;
    x = 1;
    while abs(A(P(1),P(2))) > seuil || abs(B(P(1),P(2))) > seuil
        [A(P(1),P(2)) B(P(1),P(2))];
        J = [Ax(P(1),P(2)) Ay(P(1),P(2));Bx(P(1),P(2)) By(P(1),P(2))];
        P = P - J\[A(P(1),P(2));B(P(1),P(2))];
        x = x+1;
    end
    x= P(1);
    y= P(2);
    

end

