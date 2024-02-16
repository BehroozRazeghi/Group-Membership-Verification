function W = UpdateW(X, W, Y, params)
lambda2 = params.lambda2;
lambda3 = params.lambda3;
lambda4 = params.lambda4;
N = size(X,1);
P = sparse(N,N); 
for i=1:N    
    P(i,N+1-i) = 1;
end
[Ux,Sx]=eig(X*( eye(size(X,2)) )*X'+lambda2*(1*eye(N)+0*ones(N)) );
Sx=real(Sx^(1/2));
UxX=Ux'*X;
SdR=(P*eye(size(X,1))*P);  
SMat=(UxX*Y');
AConstrint = W';
[Uxy,Sxy,Vxy]=svd(SMat+0.15*AConstrint);
Ub=(Uxy*((Sxy>0))*Vxy')';
dimMin=min(size(Sxy,1), size(Sxy,2))+1;
if size(Sxy,1)<size(Sxy,2)
    Sxy(:,dimMin:end)=[];
elseif size(Sxy,1)>size(Sxy,2)
    for jFill=dimMin:size(Sxy,1)
        Sxy(jFill,jFill)=(min(diag(Sxy))-min(diag(Sxy))./15);
    end
end
SxyA=[];
for i=1:max(size(Sxy,1),size(Sxy,2))
    SxyA(i,i)=Sxy(i,i);
end
for i=1:N
    varibles=[ lambda4*Sx(i,i)^(-4), 0,+2*(-2*lambda4*Sx(i,i)^(-2)+SdR(i,i)),-2*(Sxy(i,i)).*Sx(i,i)^(-1), -2*lambda3];
    tmp=roots(varibles);
    z=0;
    sol=[];
    for j=1:size(tmp,1)
        t=isreal(tmp(j));
        if t==1
            z=z+1;
            sol(z)=tmp(j);
        end
    end
    sol=min( sol(sol>0) );
    Sa(i,i)=sol(1);
end
W = Ub*Sa*Sx^(-1)*Ux';

end