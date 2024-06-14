%% KN

function [loglik] = twoB_fourA_oneQ(parameters, subj)

%get parameters
nd_beta_c = parameters(1);
beta_c = exp(nd_beta_c); %transformed to be > 0

nd_beta_e = parameters(2);
beta_e = exp(nd_beta_e); %transformed to be > 0

nd_alpha_cat_catCond = parameters(3); % normally distributed alpha
alpha_cat_catCond = 1/(1+exp(-nd_alpha_cat_catCond)); % alpha (transformed to be between zero and one)

nd_alpha_ex_catCond = parameters(4); % normally distributed alpha
alpha_ex_catCond = 1/(1+exp(-nd_alpha_ex_catCond)); % alpha (transformed to be between zero and one)

nd_alpha_cat_exCond = parameters(5); % normally distributed alpha
alpha_cat_exCond = 1/(1+exp(-nd_alpha_cat_exCond)); % alpha (transformed to be between zero and one)

nd_alpha_ex_exCond = parameters(6); % normally distributed alpha
alpha_ex_exCond = 1/(1+exp(-nd_alpha_ex_exCond)); % alpha (transformed to be between zero and one)

nd_Qinit = parameters(7); %normally distributed Qinit
q_init = nd_Qinit/10; 

%get relevant data variables
condition = subj.condition;
trial = subj.trial;
category = subj.category;
exemplar = subj.exemplar;
choices = subj.choice;
points = subj.points;

%number of total trials
T = size(choices, 1);

% save choice probabilities
p = nan(T, 1);

% Loop through trials
for trial_num = 1:T
    
    % On trial 1, initialize value estimates
    if trial_num == 1 || trial(trial_num) == 1 || trial(trial_num) < trial(trial_num - 1)
        exemp_ests = q_init .* ones(1, 15);
        cat_ests = q_init .* ones(1, 3);
    end
    
    %Determine stimulus value estimate by taking weighted sum of exemplar
    %and category
    
    %determine condition
    if condition(trial_num) == 1
       % beta_c = beta_cat_catCond;
       % beta_e = beta_ex_catCond;
        alpha_c = alpha_cat_catCond;
        alpha_e = alpha_ex_catCond;
    elseif condition(trial_num) == 2
        %beta_c = beta_cat_exCond;
        %beta_e = beta_ex_exCond;
        alpha_c = alpha_cat_exCond;
        alpha_e = alpha_ex_exCond;
    end
   
    % Determine choice probabilities
    ev = exp([beta_c .* cat_ests(category(trial_num)) + beta_e .* exemp_ests(exemplar(trial_num)), 0]);
    sev = sum(ev);
    choice_probs = ev/sev; 
    
    % Determine the choice the participant actually made on this trial
    trial_choice = choices(trial_num);
    
    %Determine the probability that the participant made the choice they
    %made
    p(trial_num) = choice_probs(trial_choice);
    
    %Compute  prediction error and update
    %value estimates
    %if trial_choice == 1
        category_PE = points(trial_num) - cat_ests(category(trial_num));
        exemplar_PE = points(trial_num) - exemp_ests(exemplar(trial_num));
        cat_ests(category(trial_num)) = cat_ests(category(trial_num)) + alpha_c*category_PE;
        exemp_ests(exemplar(trial_num)) = exemp_ests(exemplar(trial_num)) + alpha_e*exemplar_PE;
    %end
    
  
end

% compute log likelihood by summing the log probability of the choice data
loglik = sum(log(p + eps));

%add eps (very small number) to overcome very very small values of p

