function theta = UpdateTheta(X, W, Y, Idx, theta,params)
% K=100;L=16;N=32;C=10;
% rng(1);
% X = rand(N,K);
% W = randn(L,N); % initializeprojection matrix for the embedding
% 
% theta.tau = rand(L,C);
% theta.vi = rand(L,C);
% params.lambda1=1;
% params.lambda5=1;
% Options.params=params;
% Options.L=L;
vi = theta.vi;
tau = theta.tau;
C = size(vi,2); %number of groups
%% Update vi
parfor i=1:C
    vii = vi(:,i);
    Xc = X(:, find(Idx==i));
    n_c = size(Xc,2);
    u = sum(W*Xc,2)-n_c*tau(:,i);
    Yc = Y(:,find(Idx==i));
    
    t1 = sum(PosNeg(Yc,1).*repmat(sign(PosNeg(u,1)),[1,n_c]),2);
    t2 = sum(PosNeg(Yc,-1).*repmat(sign(PosNeg(u,-1)),[1,n_c]),2);
    hy = t1-t2;
    ff=i;
    tau_c = tau;
    tau_c(:,ff) = [];
    t1 = sum(PosNeg(tau_c,1).*repmat(sign(PosNeg(u,1)),[1,C-1]),2);
    t2 = sum(PosNeg(tau_c,-1).*repmat(sign(PosNeg(u,-1)),[1,C-1]),2);
    h1 = t1-t2;
    
    
    vi_c = vi;
    vi_c(:,ff) = [];
    t1 = sum(PosNeg(vi_c,1).*repmat(sign(PosNeg(u,1)),[1,C-1]),2);
    t2 = sum(PosNeg(vi_c,-1).*repmat(sign(PosNeg(u,-1)),[1,C-1]),2);
    h2 = t1-t2;
    
    sc = params.lambda6*(tau(:,i).*tau(:,i));
    gc = params.lambda6*(h1-h2);
    pc =  params.lambda5*hy;
    
    u_abs = abs(u);
    vij(:,i) = sign(u).* PosNeg(u_abs+pc-gc,1)./(n_c+2*sc);
end
vi=vij;
%% Update tau
parfor i=1:C
    tii = tau(:,i);
    Xc = X(:, find(Idx==i));
    n_c = size(Xc,2);
    u = sum(W*Xc,2)-n_c*vi(:,i);
    Yc = Y(:,find(Idx==i));
    
    t1 = sum(PosNeg(Yc,1).*repmat(sign(PosNeg(u,1)),[1,n_c]),2);
    t2 = sum(PosNeg(Yc,-1).*repmat(sign(PosNeg(u,-1)),[1,n_c]),2);
    hy = t1-t2;
    
    ff=i;
    tau_c = tau;
    tau_c(:,ff) = [];
    t1 = sum(PosNeg(tau_c,1).*repmat(sign(PosNeg(u,1)),[1,C-1]),2);
    t2 = sum(PosNeg(tau_c,-1).*repmat(sign(PosNeg(u,-1)),[1,C-1]),2);
    h1 = t1-t2;
    
    
    vi_c = vi;
    vi_c(:,ff) = [];
    t1 = sum(PosNeg(vi_c,1).*repmat(sign(PosNeg(u,1)),[1,C-1]),2);
    t2 = sum(PosNeg(vi_c,-1).*repmat(sign(PosNeg(u,-1)),[1,C-1]),2);
    h2 = t1-t2;
    
    sc = params.lambda6*(tau(:,i).*tau(:,i));
    gc = params.lambda6*(h1-h2);
    pc =  params.lambda5*hy;
    zc1 = params.lambda5*sum(Yc,2);
    
    u_abs = abs(u);
    tauj(:,i) = sign(u).* PosNeg(u_abs-pc-gc,1)./(n_c+2*sc+2*zc1);
end
tau=tauj;
%%

theta.vi = vi;
theta.tau = tau;

end



% function theta = UpdateTheta(X, W, Y, Idx, theta,params)
% % K=100;L=16;N=32;C=10;
% % rng(1);
% % X = rand(N,K);
% % W = randn(L,N); % initializeprojection matrix for the embedding
% % 
% % theta.tau = rand(L,C);
% % theta.vi = rand(L,C);
% % params.lambda1=1;
% % params.lambda5=1;
% % Options.params=params;
% % Options.L=L;
% vi = theta.vi;
% tau = theta.tau;
% C = size(vi,2); %number of groups
% %% Update vi
% for i=1:C
%     vii = vi(:,i);
%     Xc = X(:, find(Idx==i));
%     n_c = size(Xc,2);
%     u = mean(W*Xc,2)-tau(:,i);
%     Yc = Y(:,find(Idx==i));
%     
%     t1 = sum(PosNeg(Yc,1).*repmat(sign(PosNeg(vii,1)),[1,n_c]),2);
%     t2 = sum(PosNeg(Yc,-1).*repmat(sign(PosNeg(vii,-1)),[1,n_c]),2);
%     hy = t1+t2;
%     
%     tau_c = tau;
%     tau_c(:,i) = [];
%     t1 = sum(PosNeg(tau_c,1).*repmat(sign(PosNeg(vii,1)),[1,C-1]),2);
%     t2 = sum(PosNeg(tau_c,-1).*repmat(sign(PosNeg(vii,-1)),[1,C-1]),2);
%     h1 = t1+t2;
%     
%     
%     vi_c = vi;
%     vi_c(:,i) = [];
%     t1 = sum(PosNeg(vi_c,1).*repmat(sign(PosNeg(vii,1)),[1,C-1]),2);
%     t2 = sum(PosNeg(vi_c,-1).*repmat(sign(PosNeg(vii,-1)),[1,C-1]),2);
%     h2 = t1+t2;
%     
%     sc = params.lambda6*(tau(:,i).*tau(:,i));
%     gc = params.lambda6*(h1-h2);
%     pc =  params.lambda5*hy;
%     
%     u_abs = abs(u);
%     vi(:,i) = sign(u).* PosNeg(u_abs+pc-gc,1)./(1+2*sc);
% end
% 
% %% Update tau
% for i=1:C
%     tii = tau(:,i);
%     Xc = X(:, find(Idx==i));
%     n_c = size(Xc,2);
%     u = mean(W*Xc,2)-vi(:,i);
%     Yc = Y(:,find(Idx==i));
%     
%     t1 = sum(PosNeg(Yc,1).*repmat(sign(PosNeg(tii,1)),[1,n_c]),2);
%     t2 = sum(PosNeg(Yc,-1).*repmat(sign(PosNeg(tii,-1)),[1,n_c]),2);
%     hy = t1+t2;
%     
%     tau_c = tau;
%     tau_c(:,i) = [];
%     t1 = sum(PosNeg(tau_c,1).*repmat(sign(PosNeg(tii,1)),[1,C-1]),2);
%     t2 = sum(PosNeg(tau_c,-1).*repmat(sign(PosNeg(tii,-1)),[1,C-1]),2);
%     h1 = t1+t2;
%     
%     
%     vi_c = vi;
%     vi_c(:,i) = [];
%     t1 = sum(PosNeg(vi_c,1).*repmat(sign(PosNeg(tii,1)),[1,C-1]),2);
%     t2 = sum(PosNeg(vi_c,-1).*repmat(sign(PosNeg(tii,-1)),[1,C-1]),2);
%     h2 = t1+t2;
%     
%     sc = params.lambda6*(tau(:,i).*tau(:,i));
%     gc = params.lambda6*(h1-h2);
%     pc =  params.lambda5*hy;
%     zc1 = params.lambda5*sum(Yc,2);
%     
%     u_abs = abs(u);
%     tau(:,i) = sign(u).* PosNeg(u_abs-pc-gc,1)./(1+2*sc+2*zc1);
% end
% %%
% 
% theta.vi = vi;
% theta.tau = tau;
% 
% end