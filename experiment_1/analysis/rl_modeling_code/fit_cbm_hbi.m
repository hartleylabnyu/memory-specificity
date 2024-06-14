%% Run CBM HBI for memory specificity %%
% Experiment 1 Version
% Kate Nussenbaum - katenuss@nyu.edu
% Last edited: 4/23/24

%cbm
addpath 'cbm/codes';
addpath(genpath('lik_funs'));

%load data for all subjects
fdata = load('all_data.mat');
data = fdata.all_data;

%determine which models to compare (1, 2, 3, 4)
model_compare_set = 5;

%% Model comparison sets
% 1.) How many choice weights did participants use?
% 2.) How were values initialized?
% 3.) How did participants learn from counterfactual information?
% 4.) Do participants weight exemplar information at all in category-predictive blocks?
% 5.) Multiple alphas?


if model_compare_set == 1
    models = {@oneB, @twoB, @fourB};
    fcbm_filenames =  {'lap_oneB', 'lap_twoB', 'lap_fourB'};
    fname_hbi = 'cbm_hbi_output/hbi_beta';
elseif model_compare_set == 2
    models = {@fourB, @fourB_oneQ, @fourB_twoQ};
    fcbm_filenames =  {'lap_fourB', 'lap_fourB_oneQ', 'lap_fourB_twoQ'};
    fname_hbi = 'cbm_hbi_output/hbi_init_q';
 elseif model_compare_set == 3
    models = {@fourB_oneQ, @fourB_oneQ_CF, @fourB_oneQ_noCF};
    fcbm_filenames =  {'lap_fourB_oneQ', 'lap_fourB_oneQ_CF', 'lap_fourB_oneQ_noCF'};
    fname_hbi = 'cbm_hbi_output/hbi_cf';
elseif model_compare_set == 4
    models = {@threeB_oneQ, @fourB_oneQ};
    fcbm_filenames =  {'lap_threeB_oneQ', 'lap_fourB_oneQ'};
    fname_hbi = 'cbm_hbi_output/hbi_three_four_beta';
elseif model_compare_set == 5
     models = {@oneB_oneA_oneQ, @oneB_twoA_oneQ, @oneB_fourA_oneQ,@twoB_oneA_oneQ, @twoB_twoA_oneQ, @twoB_fourA_oneQ, @fourB_oneA_oneQ, @fourB_twoA_oneQ, @fourB_fourA_oneQ};
    fcbm_filenames =  {'lap_oneB_oneA_oneQ', 'lap_oneB_twoA_oneQ', 'lap_oneB_fourA_oneQ', ...
        'lap_twoB_oneA_oneQ', 'lap_twoB_twoA_oneQ', 'lap_twoB_fourA_oneQ', ...
        'lap_fourB_oneA_oneQ', 'lap_fourB_twoA_oneQ', 'lap_fourB_fourA_oneQ'};
    fname_hbi = 'cbm_hbi_output/hbi_alpha_beta';
end

% Results:
% 1 XPs: [0 0 1]
% 2 XPs: [0 1 0]
% 3 XPs: [1 0 0]
% 4 XPs: [0 1]
% 5 XPs: [0 0 .31 0 0 0 .69 0 0]
  

%% Do Bayesian inference with cbm hbi%%

% get the first-level fits
for m = 1:length(fcbm_filenames)
    fcbm_maps{m} = ['cbm_lap_output/', fcbm_filenames{m}];
end

% run cbm hbi
cbm_hbi(data, models, fcbm_maps, fname_hbi);
