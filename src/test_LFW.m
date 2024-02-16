clear all;
Options.rng = 20;
% load('../../Build_datasets/dataset_LFW_PCA.mat')
load('dataset_LFW_PCA.mat')
Options.n_iter = 1;
m_vec = [40,24,20,16,10,5];
p.partitioning = 'random';
Options.flag_norm = false;
Options.preprocessing = true;
Options.L = 3*size(dataset.data,1);
er=0;
N = numel(dataset.data_id);

params.lambda1 = 0.05;
params.lambda2 = 900;
params.lambda3 = 900;
params.lambda4 = 900;
params.lambda5 = 0.1;
params.lambda6 = 0.01;
params.lambda7 = 0.05;
Options.params = params;
for i_c=1:numel(m_vec)
    Options.C = N/m_vec(i_c);
    tic
    [Perf_identification{i_c},Perf_verification{i_c}] = Perf_NLTR(dataset,Options);
    Perf_identification{i_c}.Pfn5
    toc
    save('res_LFW.mat')
end