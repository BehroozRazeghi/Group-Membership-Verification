function [Perf_identification,Perf_verification] = Perf_NLTR(dataset,Options)
% function [Pfn_v,Pfn_i,AUCC] = Perf_NLTR(dataset,Options)
%% data preparation
data = dataset.data;
H1_data = dataset.H1_data;
H0_data = dataset.H0_data;
data_id = dataset.data_id;
H1_id = dataset.H1_id;
H0_id = dataset.H0_id;
H1_ind = dataset.H1_ind;
H0_ind = dataset.H0_ind;
%% Setting-----------------------------------------------------------------
X = data;
[N K] = size(X);
if ~isfield(Options, 'L')
    Options.L = N;
end
%% Normalization ----------------------------------------------------------
if Options.preprocessing
    X=zscore(X,0,2);
end
if Options.flag_norm
    X = UnitNorm(X);
end
%% learning group representations------------------------------------------
[X_New, Idxx, Ww, thetaa] = NLTransRepLearn(X,Options);
for iter=1:Options.n_iter
    Idx = Idxx{iter};
    W = Ww{iter};
    theta = thetaa{iter};
    
    
    tau = theta.tau;
    vi = theta.vi;
    C = Options.C;
    for i= 1:C
        group{i} = find(Idx==i);
    end
    %% Identification----------------------------------------------------------
    Pfp1 = 10^-2;
    Pfp5 = 5*10^-2;
    %%---Negative query--------------------------------------------------------
    NqueryH0 = length(H0_id);
    D0 = zeros(1,NqueryH0);
    Y = H0_data;

    if Options.preprocessing
        Y = zscore(Y,0,2);
    end
    if Options.flag_norm
        Y = UnitNorm(Y);
    end
    parfor i=1:NqueryH0
        [scores,~] = ComputeScores(Y(:,i),W,theta,Options);
        D00(i) = min(scores); 
    end
    %%---Positive query--------------------------------------------------------
    for ii=1:numel(H1_id)
        NqueryH1 = length(H1_id{ii});
        D1 = zeros(1,NqueryH1);
        Y = H1_data{ii};
        if Options.preprocessing && size(Y,2)>1
            Y = zscore(Y,0,2);
        end
        if Options.flag_norm
            Y = UnitNorm(Y);
        end
        parfor i=1:NqueryH1
            [scores,~] = ComputeScores(Y(:,i),W,theta,Options);
            [D11(i),pred_group(i)] = min(scores); 
        end
        %%---------------------------------------------------------------------
        D0 = sort(D00(:));
        D1 = sort(D11(:));
        %%---- Compute Ptp @ Pfp=1%--------------------------------------------
        Pfp=0.01;
        thr = D0(ceil(Pfp*NqueryH0));
        Perf_identification.Pfn1(ii) = 1-nnz(D1<=thr)/NqueryH1;
        %%% 2nd step of identification : compute DIR @ Pfp
        identified=0;
        for i=1:numel(H1_id{ii})
            for j=1:numel(group{pred_group(i)})
                if D11(i)<=thr % accepted at the first step
                    match_flag=strcmp(H1_id{ii}{i},data_id{group{pred_group(i)}(j)});
                    if match_flag
                        identified=identified+1;
                        break;
                    end
                end
            end
        end
        Perf_identification.False_id_fp1(ii)=1-identified/NqueryH1;
        %%---- Compute Ptp @ Pfp=5%--------------------------------------------
        Pfp=0.05;
        thr = D0(ceil(Pfp*NqueryH0));
        Perf_identification.Pfn5(ii) = 1-nnz(D1<=thr)/NqueryH1;
        %%% 2nd step of identification : compute DIR @ Pfp
        identified=0;
        for i=1:numel(H1_id{ii})
            for j=1:numel(group{pred_group(i)})
                if D11(i)<=thr % accepted at the first step
                    match_flag=strcmp(H1_id{ii}{i},data_id{group{pred_group(i)}(j)});
                    if match_flag
                        identified=identified+1;
                        break;
                    end
                end
            end
        end
        Perf_identification.False_id_fp5(ii)=1-identified/NqueryH1;
        %%%Compute   DIR vs. Pfp
        thr = linspace(D1(1),D0(end),100);
        for kt=1:length(thr)
            Pfp_vec(ii,kt) = nnz(D0<=thr(kt))/NqueryH0;
            identified=0;
            for i=1:NqueryH1
                for j=1:numel(group{pred_group(i)})
                    if D11(i)<=thr(kt) % accepted at the first step
                        match_flag=strcmp(H1_id{ii}{i},...
                            data_id{group{pred_group(i)}(j)});
                        if match_flag
                            identified=identified+1;
                            break;
                        end
                    end
                end
            end
            DIR_vec(ii,kt)=identified/NqueryH1;
        end   
    end
    Perf_identification.DIR_vec=DIR_vec;
    Perf_identification.Pfp_vec=Pfp_vec;

    %% Verification------------------------------------------------------------

    %%---Negative query--------------------------------------------------------
    NqueryH0 = length(H0_id);
    D0 = zeros(1,NqueryH0);
    Y = H0_data;
    if Options.preprocessing
        Y=zscore(Y,0,2);
    end
    if Options.flag_norm
        Y = UnitNorm(Y);
    end
    H0_group_id = randi(C,[NqueryH0,1]);
    parfor i=1:NqueryH0
            [scores,~] = ComputeScores(Y(:,i),W,theta,Options);
            D00(i) = scores(H0_group_id(i)); 
    end
    D0 = sort(D00(:));
    %%---Positive query--------------------------------------------------------
    for ii=1:numel(H1_id)
        NqueryH1 = length(H1_id{ii});
        D11 = zeros(1,NqueryH1);
        Y = H1_data{ii};
        if Options.preprocessing && size(Y,2)>1
            Y=zscore(Y,0,2);
        end
        if Options.flag_norm
            Y = UnitNorm(Y);
        end
        %%--Determine the group identity of positive queryies------------------
        NqueryH1 = length(H1_id{ii});
        H1_group_id=[];
        for i=1:numel(H1_id{ii})
            for j=1:numel(group)
               for k=1:numel(group{j})
                   if strcmp(H1_id{ii}{i},data_id{group{j}(k)}) 
                       H1_group_id(i)=j;
                   end
               end
            end
        end
        parfor i=1:NqueryH1
            [scores,~] = ComputeScores(Y(:,i),W,theta,Options);
            D11(i) = scores(H1_group_id(i)); 
        end
        D1 = sort(D11(:));
        %%% Compute Ptp @ Pfp=1%-----------------------------------------------
        Pfp=0.01;
        thr = D0(ceil(Pfp*NqueryH0));
        Perf_verification.Pfn1(ii) = 1-nnz(D1<=thr)/NqueryH1;
        %%% Compute Ptp @ Pfp=5%-----------------------------------------------
        Pfp=0.05;
        thr = D0(ceil(Pfp*NqueryH0));
        Perf_verification.Pfn5(ii) = 1-nnz(D1<=thr)/NqueryH1;
        %%% auc----------------------------------------------------------------
        thr = linspace(D1(1),D0(end),100);
        Pfp_vecc = zeros(size(thr));
        Ptp_vec = zeros(size(thr));
        for kt=1:length(thr)
            Pfp_vecc(kt) = nnz(D0<=thr(kt))/NqueryH0;
            Ptp_vec(kt) = nnz(D1<=thr(kt))/NqueryH1;
        end
        Perf_verification.auc(ii) = AUC(Pfp_vecc,Ptp_vec);
    end
%     Pfn_v(iter)=Perf_verification.Pfn5(1);
%     Pfn_i(iter)=Perf_identification.Pfn5(1);
%     AUCC(iter)=Perf_verification.auc(1);
    
end
    
end