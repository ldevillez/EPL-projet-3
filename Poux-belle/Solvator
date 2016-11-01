function [x,y] = Solvator(A,B)

[Ax Ay] = devPol(A);
[Bx By] = devPol(B);


xprev = 0;
yprev = 0; 
ds = 1;
x = 20;
y = 30;
seuil = 0.01;
limite = 2000;
while ds<=limite && (abs(x-xprev)>=seuil && abs(y-yprev)>=seuil)
    xprev=x;
    yprev=y;
    J = [ComputePol(Ax,xprev,yprev) ComputePol(Ay,xprev,yprev); ComputePol(Bx,xprev,yprev) ComputePol(By,xprev,yprev)];
    sol = [ComputePol(A,xprev,yprev);ComputePol(B,xprev,yprev)];
    z = [xprev  ; yprev] - (J\sol);
    x=z(1);
    y=z(2);
    ds=ds+1;
end

end

function [dX dY] = devPol(A)
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
    m = size(A,2);
    n = size(A,1);
    
    X = (x* ones(1,m)).^(m-1:-1:0);
    Y = (y*ones(n,1)).^((0:n-1)');
    
    p=sum(sum((Y*X).*A));
    
end
