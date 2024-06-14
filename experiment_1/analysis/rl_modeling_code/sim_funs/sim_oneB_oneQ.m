%% KN

function [sim_choices] = sim_oneB_oneQ(parameters, subj)

%get parameters
nd_beta = parameters(1);
beta = exp(nd_beta); %transformed to be > 0

nd_alpha = parameters(2); % normally distributed alpha
alpha = 1/(1+exp(-nd_alpha)); % alpha (transformed to be between zero and one)

nd_Qinit = parameters(3); %normally distributed Qinit
q_init = nd_Qinit/10; 

%get relevant data variables
condition = subj.condition;
trial = subj.trial;
category = subj.category;
exemplar = subj.exemplar;
%choices = subj.choice;
points = subj.points;

%number of total trials
T = size(points, 1);

% save choices
choices = nan(T, 1);

% set initial q values (if not a parameter)
%Qinit = 0;

% Loop through trials
for trial_num = 1:T
    
    % On trial 1, initialize value estimates
    if trial_num == 1 ||trial(trial_num) == 1 || trial(trial_num) < trial(trial_num - 1)
        exemp_ests = q_init * ones(1, 15);
        cat_ests = q_init * ones(1, 3);
    end
    
    %Determine stimulus value estimate by taking weighted sum of exemplar
    %and category

    % Determine choice probabilities
    ev = exp([beta .* cat_ests(category(trial_num)) + beta .* exemp_ests(exemplar(trial_num)), 0]);
    sev = sum(ev);
    choice_probs = ev/sev; 
    
    % Determine the choice with a coin flip the participant actually made on this trial
    coin_flip = rand();
    if coin_flip < choice_probs(1)
        trial_choice = 1;
    else
        trial_choice = 2;
    end
    
    %save choice
    choices(trial_num) = trial_choice;
    
    %Compute  prediction error and update
    %value estimates
    %if trial_choice == 1
        category_PE = points(trial_num) - cat_ests(category(trial_num));
        exemplar_PE = points(trial_num) - exemp_ests(exemplar(trial_num));
        cat_ests(category(trial_num)) = cat_ests(category(trial_num)) + alpha*category_PE;
        exemp_ests(exemplar(trial_num)) = exemp_ests(exemplar(trial_num)) + alpha*exemplar_PE;
    %end
    
  
end

sim_choices = choices;

