function [scores,y] = ComputeScores(X,W,theta,Options)
    u = W*X;
    ti_c = theta.tau;
    vi_c = theta.vi;
    params = Options.params;
    C = Options.C;
    L = Options.L;
    
    %%---------------------------------------------------------------------
    h1 = repmat(sign(PosNeg(u,1)),[1,C]).*PosNeg(ti_c,1)-repmat(sign(PosNeg(u,-1)),[1,C]).*PosNeg(ti_c,-1);
    h2 = repmat(sign(PosNeg(u,1)),[1,C]).*PosNeg(vi_c,1)-repmat(sign(PosNeg(u,-1)),[1,C]).*PosNeg(vi_c,-1);

    sc = params.lambda5*(ti_c.*ti_c);
    gcm = params.lambda5*(h1-h2);
    u_abs=abs(u);

    y = repmat(sign(u),[1,C]).*PosNeg(repmat(u_abs,[1,C])-gcm-params.lambda1*ones(L,C),1)./(ones(L,C)+2*sc);

    %%%  Compute Scores
    yc = y;
    t1 = diag(PosNeg(yc,1)'*PosNeg(ti_c,1))+diag(PosNeg(yc,-1)'*PosNeg(ti_c,-1));
    t2 = diag((ti_c.*ti_c)'*(yc.*yc));
    t3 = diag(PosNeg(yc,1)'*PosNeg(vi_c,1))+diag(PosNeg(yc,-1)'*PosNeg(vi_c,-1));
    scores = t1+t2-t3;
end