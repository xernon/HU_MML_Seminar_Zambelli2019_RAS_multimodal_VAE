close all
clear

title_names = {'q_0','q_1','q_2','q_3','x_L','y_L','x_R','y_R','p','s','u_0','u_1','u_2','u_3'};
mod_names={'all','joint pos','visual pos','tact','sound','motor commands'};
modalities = {[1,2,3,4,5,6,7,8];[9,10,11,12,13,14,15,16];[17,18];[19,20];[21,22,23,24,25,26,27,28]};

Dir=dir('./run_*');
scenarios=[];
toignore=[
    "scenario_orig/run_1/results/";
    "scenario_orig/run_10_aus_mvae/results/";
    ];
for d = dir('scenario*')'
    disp([d.name])
    scenario_data=cell([5 1]);
    runs=[];
    for r = dir([d.name, '/run*'])'
        results_path=[d.name,'/',r.name,'/results/'];
        if ismember(results_path,toignore)
            continue
        end
        test_1=load([results_path,'mvae_final_completeloss_test1.mat']);
        test_2=load([results_path,'mvae_final_completeloss_test2.mat']);
        test_3=load([results_path,'mvae_final_completeloss_test3.mat']);
        test_4=load([results_path,'mvae_final_completeloss_test4.mat']);
        test_pred=load([results_path,'mvae_final_completeloss_testPred.mat']);
        
        scenario_data{1}=[scenario_data{1} ; test_1];
        scenario_data{2}=[scenario_data{2} ; test_2];
        scenario_data{3}=[scenario_data{3} ; test_3];
        scenario_data{4}=[scenario_data{4} ; test_4];
        scenario_data{5}=[scenario_data{5} ; test_pred];
    end
    scenario_struct=struct('name', [d.name], 'data',{scenario_data});
    scenarios=[scenarios; {scenario_struct}];
end
    