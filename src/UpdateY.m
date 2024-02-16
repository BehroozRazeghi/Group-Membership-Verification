function [Y,Idx] = UpdateY(X, W, theta,Options)
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

K = size(X,2);
Idx = zeros(K,1);
parfor i=1:K
%     [scores,y] = ComputeScores(X(:,i),W,theta,Options);
%     [~,Idx(i)] = min(scores);
%     Y(:,i) = y(:,Idx(i));
    [scores(i,:),y1(i,:,:)] = ComputeScores(X(:,i),W,theta,Options);    
end
heap(:,1) = reshape(scores,[],1);
heap(:,2) = repmat(1:K,[1 ,Options.C])';
[~,ind] = sort(heap(:,1)); % sort just the first column
sorted_heap = heap(ind,:);
t = 1;
flag = ones(K,1);
while nnz(~Idx)
    i_x = sorted_heap(t,2);
    [~,minn] = min(scores(i_x,:));
    if numel(find(Idx==minn)) < K/Options.C & flag(i_x)
        Idx(i_x) = minn;
        Y(:,i_x) = y1(i_x,:,minn);
        flag(i_x) = 0; %this item has already been assigned to a group
    elseif flag(i_x) %if size of the nearest group is full, it should be assigned to the second nearest
        scores(i_x,minn) = inf;
    end
    t = t+1;
end