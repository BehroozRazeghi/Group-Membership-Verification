function [Y, Idxx, Ww, thetaa] = NLTransRepLearn(X,Options)

% learns the linear transform matrix (W), similarity and dissimilarity
% parameters theta (vi and tau), representations (Y), assignments (Idx)
% partitions the vectors in matrix X into C clusters
% X : N-by-K, W: L-by-N

rng(Options.rng);%FEI 10
[N,K] = size(X);
C = Options.C;
M = K/C;
% Initialize W and theta
W = randn(Options.L,N); % initializeprojection matrix for the embedding
W = UnitNorm(W);
Y = W*X;
Y = UnitNorm(Y);
% % Y = sparsityEncoding(Y, sparsityEncodingType, sparsityLevel);
% % Y = unitOneNorm(YtD, 2, eps);
%%-----------------------------------------------------------
params = Options.params;
% if ~isfield(params, 'lambda')
%     params.lambda=1;
% end
Options.params = params;

%%-----------------------------------------------------------
group = partition(X,C,'random');
for c = 1:C
   Idx(group{c}) = c;
   theta.tau(:,c) = -2*mean(W*X(:,group{c}),2);
   theta.vi(:,c) = mean(W*X(:,group{c}),2);
end


for iter = 1:Options.n_iter
    % given Y and theta update W
    tau = theta.tau;
    vi = theta.vi;
    Y1 = Y - params.lambda7*(tau(:,Idx)+vi(:,Idx));
    W = UpdateW(X, W, Y1, Options.params);
    
    Y = W*X;
    Y = UnitNorm(Y);   
    % given W and theta update Y and Idx
    [Y,Idx] = UpdateY(X, W, theta,Options);
     % given W and Y update theta
    theta = UpdateTheta(X, W, Y, Idx, theta,Options.params);
%     for i=1:C
%         numel(find(Idx==i))
%     end
    Idxx{iter}=Idx;
    thetaa{iter}=theta;
    Ww{iter}=W;
     
end


end