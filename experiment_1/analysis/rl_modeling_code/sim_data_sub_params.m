%% Simulate memory specificity choice data %%
% Kate Nussenbaum - katenuss@nyu.edu

function [] = sim_data_sub_params(model_name, n_sims)

%add cbm
addpath('cbm/codes');
addpath('sim_funs');

%load data
csv_data = readtable('../../data/e1_rl_data.csv');
sub_list = unique(csv_data.subject_id);
load('all_data', 'all_data');

%rename as data
data = all_data;

%read in model results and determine minimum and maximum parameter values for model
load(['cbm_lap_output/lap_', model_name], 'cbm');
%param_mins = min(cbm.output.parameters);
%param_maxs = max(cbm.output.parameters);

%determine simulation function name
function_name = ['sim_', model_name];

%create empty data structure
sim_data_set{n_sims} = struct();

%% Simulate model %%

%loop through subjects, taking their data and parameters
for sub = 1:length(sub_list)
    subj_data = data{sub};
    params = cbm.output.parameters(sub, :);
    subject_number = sub_list(sub);
    
    for sim = 1:n_sims
        %run simulation and save simulated data
        fh = str2func(function_name);
        choices = fh(params, subj_data);
        simulated_data = subj_data;
        simulated_data.choice = choices;
        simulated_data.params = params;
        sim_data_set{sim} = simulated_data;
    end
    
    %save simulated dataset
    save(['sim_data_sets_sub_params/sim_data_', model_name, '_sub_', int2str(sub)], 'sim_data_set');
    
end

end













