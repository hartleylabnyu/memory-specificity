%% Compile sub simulations %%


%load each simulated subject
for sub = 1:73
    
    %determine model name
    model_name = 'fourB_oneQ_CF';
    
    %load data
    sub_data = load(['sim_data_sets_sub_params/sim_data_', model_name, '_sub_', int2str(sub)]);
    
    all_sim_ids = [];
    for sim_num = 1:1000
        sim_choices = sub_data.sim_data_set{sim_num}.choice;
        sub_choices(:, sim_num) = sim_choices;
        sim_points = sub_data.sim_data_set{sim_num}.points;
        sub_points(:, sim_num) = sim_points;
        sim_optimal = sub_data.sim_data_set{sim_num}.optimal_choice;
        sub_optimal(:, sim_num) = sim_optimal;
        sim_trial = sub_data.sim_data_set{sim_num}.trial;
        sub_trial(:, sim_num) = sim_trial;
        sim_id = sim_num .* ones(length(sim_trial), 1);
        all_sim_ids = [all_sim_ids; sim_id];
    end
    
    %convert to column vectors
    sub_choices = reshape(sub_choices, [], 1);
    sub_points = reshape(sub_points,[], 1);
    sub_optimal = reshape(sub_optimal, [], 1);
    sub_trial = reshape(sub_trial, [], 1);
    
    %get vector of sub id
    sub_id = sub_data.sim_data_set{1}.sub_id;
    sub_id_vec = sub_id .* ones(length(sub_choices), 1);
    
    
    %add block number info
    block_order = ones(length(sub_trial), 1);
    block_number = 0;
    
    for trial = 1:length(sub_trial)
        if trial == 1 || sub_trial(trial) < sub_trial(trial -1)
            block_number = block_number + 1;
        end
        block_order(trial) = block_number;
    end
    
    %write CSV of simulated subject choices
    headers = {'subject_id', 'sim_num', 'block_order', 'learning_trial', 'sim_choice', 'sim_points', 'optimal_choice'};
    csvwrite_with_headers(['../../data/sim_data/sim_sub_choices_', model_name, '_sub_', int2str(sub_id), '.csv'], [sub_id_vec, all_sim_ids, block_order, sub_trial, sub_choices, sub_points, sub_optimal], headers);
    
    %clear sub choices for next sub
    clear all;
end
