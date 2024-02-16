function [group,vec] = partition(X,M,method)
    rng(1)
    N=size(X,2);
    vec = zeros(1,N,'single');
    switch method
        case 'random'
            idx = randperm(N);
            m=fix(N/M);
            for j=1:M
                group{j}=idx((j-1)*m+1:j*m)';
                vec(idx((j-1)*m+1:j*m)) = j;
            end
            for k=1:mod(N,M)
                group{k}=[group{k};idx(j*m+k)];
                vec(idx(j*m+k)) = k;
            end
                
        case 'clustering'
            idx=kmeans(X',M); %matlab kmeans
%             idx=kmeans2(X',M,'ternary',0,'S_x',0); %matlab kmeans
            for j=1:M
                group{j}=find(idx==j);
            end
        case 'anti-clustering'
            mydistance = @(X)  pdist(X','cosine');
            Dist=mydistance(X);
            dissimilarity = 2*ones(size(Dist))-Dist;
            Z = linkage(dissimilarity,'complete');
            idx= cluster(Z,'maxclust',M);
            for j=1:M
                group{j}=find(idx==j);
            end
    end
            
end