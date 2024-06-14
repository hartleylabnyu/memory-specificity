%% Run CBM HBI for memory specificity (separately per age group)%%
% Experiment 1 Version
% Kate Nussenbaum - katenuss@nyu.edu
% Last edited: 4/23/24

%cbm
addpath 'cbm/codes';
addpath(genpath('lik_funs'));

%load data for all subjects
fdata = load('all_data.mat');
data = fdata.all_data;

%load subject ages
sub_ages = readtable("../../data/e1_sub_ages.csv");
child_ids = sub_ages(sub_ages.age < 13, 'subject_id').subject_id;
adolescent_ids = sub_ages(sub_ages.age < 18 & sub_ages.age > 12.999, 'subject_id').subject_id;
adult_ids = sub_ages(sub_ages.age > 17.999, 'subject_id').subject_id;

%divide data into age groups
child_data = [];
adolescent_data = [];
adult_data = [];
child_index = 1;
adolescent_index = 1;
adult_index = 1;

for sub = 1:length(data)
    if ismember(data{sub}.sub_id, child_ids)
        child_data{child_index} = data{sub};
        child_index = child_index + 1;
    elseif ismember(data{sub}.sub_id, adolescent_ids)
        adolescent_data{adolescent_index} = data{sub};
        adolescent_index = adolescent_index + 1;
    elseif ismember(data{sub}.sub_id, adult_ids)
        adult_data{adult_index} = data{sub};
        adult_index = adult_index + 1;
    end
end

%%

%determine which models to compare (1, 2, or 3)
model_compare_set = 4;

%% Model comparison sets
% 1.) How many choice weights did participants use?
% 2.) How were values initialized?
% 3.) How did participants learn from counterfactual information?
% 4.) multiple alphas

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
     models = {@oneB_oneA_oneQ, @oneB_twoA_oneQ, @oneB_fourA_oneQ,@twoB_oneA_oneQ, @twoB_twoA_oneQ, @twoB_fourA_oneQ, @fourB_oneA_oneQ, @fourB_twoA_oneQ, @fourB_fourA_oneQ};
    fcbm_filenames =  {'lap_oneB_oneA_oneQ', 'lap_oneB_twoA_oneQ', 'lap_oneB_fourA_oneQ', ...
        'lap_twoB_oneA_oneQ', 'lap_twoB_twoA_oneQ', 'lap_twoB_fourA_oneQ', ...
        'lap_fourB_oneA_oneQ', 'lap_fourB_twoA_oneQ', 'lap_fourB_fourA_oneQ'};
    fname_hbi = 'cbm_hbi_output/hbi_alpha_beta';
end


%% Do Bayesian inference with cbm hbi%%

% get the first-level fits
for m = 1:length(fcbm_filenames)
    fcbm_maps{m} = ['cbm_lap_output/', fcbm_filenames{m}];
end

% run cbm hbi for each age group
cbm_hbi(child_data, models, fcbm_maps, [fname_hbi, '_children']);
cbm_hbi(adolescent_data, models, fcbm_maps, [fname_hbi, '_adolescents']);
cbm_hbi(adult_data, models, fcbm_maps, [fname_hbi, '_adults']);