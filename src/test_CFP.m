% poolobj = gcp ('nocreate');
% delete (poolobj);
% n=12;
% myCluster=parcluster('local'); myCluster.NumWorkers=n; parpool(myCluster,n)
% poolobj = gcp;
clear all;
Options.rng = 1;
load('dataset_CFP_PCA.mat')
Options.n_iter = 1;
m_vec = [40,25,20,16,10,5];
p.partitioning = 'random';
Options.flag_norm = false;
Options.preprocessing = true;
Options.L = 3*size(dataset.data,1);
er=0;
N = numel(dataset.data_id);

params.lambda1 = 0.5;
params.lambda2 = 900;
params.lambda3 = 900;
params.lambda4 = 900;
params.lambda5 = 0.05;
params.lambda6 = 0.1;
params.lambda7 = 0.005;
Options.params = params;
for i_c=1:numel(m_vec)
    Options.C = N/m_vec(i_c);
    tic
    [Perf_identification{i_c},Perf_verification{i_c}] = Perf_NLTR(dataset,Options);
    Perf_identification{i_c}.Pfn5
    toc
    save('res_CFP.mat')
end