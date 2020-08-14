close all
clear

title_names = {'q_0','q_1','q_2','q_3','x_L','y_L','x_R','y_R','p','s','u_0','u_1','u_2','u_3'};
write_data = false; %should tables be created and writen to file?
write_barplots =true; %should barplots be plotted and writen to file?

Dir=dir('./scenario_*');
max_runs = 6; %arbitrary chosen TODO: variable number of runs
results=nan(2,4,length(Dir),max_runs);
results_gdoc=nan(2,3,length(Dir),max_runs);
% results_per_modality = [MSE-Type, Test 1 to 4, Modality, Scenario, Run)
results_per_modality=nan(2,4,5,length(Dir),max_runs);

mod_names={'all','joint pos','visual pos','tact','sound','motor commands'};
modalities = {[1,2,3,4,5,6,7,8];[9,10,11,12,13,14,15,16];[17,18];[19,20];[21,22,23,24,25,26,27,28]};
run_names=[];
%%
disp('--------  ---------')


for rep=1:length(Dir) %over all scenarios
    Run_dir =dir([Dir(rep).name '/run_*']);
    for run_n = 1:length(Run_dir) %for each run in a scenario
        load([Dir(rep).name '/' Run_dir(run_n).name '/results/mvae_final_completeloss_test1.mat'])
        ref=x_sample;
        err_droniou_martina_test1 = immse(double(x_reconstruct),ref);
        err_droniou_martina_test1_perc = err_droniou_martina_test1/4;
        results(1,1,rep,run_n)=err_droniou_martina_test1;
        results(2,1,rep,run_n)=err_droniou_martina_test1_perc;
            for i = 1:5 %calculate mse for each modality, case 1
                sub = immse(double(x_reconstruct(:,cell2mat(modalities(i)))),ref(:,cell2mat(modalities(i))));
                results_per_modality(1,1,i,rep,run_n) = sub;
                results_per_modality(2,1,i,rep,run_n) = sub/4;
            end
        
        
        load([Dir(rep).name '/' Run_dir(run_n).name '/results/mvae_final_completeloss_test2.mat'])
        err_droniou_martina_test2 = immse(double(x_reconstruct),ref);
        err_droniou_martina_test2_perc = err_droniou_martina_test2/4;
        results(1,4,rep,run_n)=err_droniou_martina_test2;
        results(2,4,rep,run_n)=err_droniou_martina_test2_perc;
            for i = 1:5 %calculate mse for each modality, case 4 -> only data at time t
                sub = immse(double(x_reconstruct(:,cell2mat(modalities(i)))),ref(:,cell2mat(modalities(i))));
                results_per_modality(1,4,i,rep,run_n) = sub;
                results_per_modality(2,4,i,rep,run_n) = sub/4;
            end
        
        results_gdoc(1,1,rep,run_n)= immse(double(x_reconstruct(:,end-3:end)),ref(:,end-3:end));
        results_gdoc(2,1,rep,run_n)= results_gdoc(1,1,rep,run_n)/4;
        
        load([Dir(rep).name '/' Run_dir(run_n).name '/results/mvae_final_completeloss_test3.mat'])
        err_droniou_martina_test3 = immse(double(x_reconstruct),ref);
        err_droniou_martina_test3_perc = err_droniou_martina_test3/4;
        results(1,3,rep,run_n)=err_droniou_martina_test3;
        results(2,3,rep,run_n)=err_droniou_martina_test3_perc;
        index=[1 2 3 4 9 10 11 12 17 19];
        results_gdoc(1,3,rep,run_n)= immse(double(x_reconstruct(:,index)),ref(:,index));
        results_gdoc(2,3,rep,run_n)= results_gdoc(1,3,rep,run_n)/4;
        
            for i = 1:5 %calculate mse for each modality, case 3 -> joint (t) and vision
                sub = immse(double(x_reconstruct(:,cell2mat(modalities(i)))),ref(:,cell2mat(modalities(i))));
                results_per_modality(1,3,i,rep,run_n) = sub;
                results_per_modality(2,3,i,rep,run_n) = sub/4;
            end
        
        load([Dir(rep).name '/' Run_dir(run_n).name '/results/mvae_final_completeloss_test4.mat'])
        err_droniou_martina_test4 = immse(double(x_reconstruct),ref);
        err_droniou_martina_test4_perc = err_droniou_martina_test4/4;
        results(1,2,rep,run_n)=err_droniou_martina_test4;
        results(2,2,rep,run_n)=err_droniou_martina_test4_perc;
        
        results_gdoc(1,2,rep,run_n)= immse(double(x_reconstruct(:,index)),ref(:,index));
        results_gdoc(2,2,rep,run_n)= results_gdoc(1,2,rep,run_n)/4;
        run_names=[run_names; string([Dir(rep).name '\' Run_dir(run_n).name])];
        
            for i = 1:5 %calculate mse for each modality, case 2 ->vision only
                sub = immse(double(x_reconstruct(:,cell2mat(modalities(i)))),ref(:,cell2mat(modalities(i))));
                results_per_modality(1,2,i,rep,run_n) = sub;
                results_per_modality(2,2,i,rep,run_n) = sub/4;
            end
        
      end
end


%% statistics over multiple runs
averages_all =mean(results, 4,'omitnan');
averages = mean(results_per_modality,[5],'omitnan');
variances_all = var(results,0,[4],'omitnan');
variances = var(results_per_modality,0,[5],'omitnan');
stdevs_all= std(results,0,[4],'omitnan');
stdevs = std(results_per_modality,0,[5],'omitnan');

r_names = {'Test with all', 'only data at t', 'join(t)+vision', 'vision only'};
%% Create Tables and write to file

if write_data
    filename= "output.txt";
    if exist(filename,"file")
        disp(['deleting old ' filename])
        delete(filename);
    end
    
    disp('start writing data\n')
    fid =fopen(filename,'a');
    fprintf( fid, 'results\n');
    for i = 1:length(Dir)
        temptext= "------------scenario_"+i+"------------------\n";
        fprintf( fid, temptext );
        for r =1:max_runs
            if(sum(isnan(results_per_modality(1,:,1,i,r)))>0)
                break;
            end
            temptext= "------------run_"+r+"---\n";
            fprintf( fid, temptext );
            T1 = table(results(1,:,i,r).',results_per_modality(1,:,1,i,r).',results_per_modality(1,:,2,i,r).',results_per_modality(1,:,3,i,r).',results_per_modality(1,:,4,i,r).',results_per_modality(1,:,5,i,r).','VariableNames',mod_names, 'RowNames', r_names );   
            T2 = table(results(2,:,i,r).',results_per_modality(2,:,1,i,r).',results_per_modality(2,:,2,i,r).',results_per_modality(2,:,3,i,r).',results_per_modality(2,:,4,i,r).',results_per_modality(2,:,5,i,r).','VariableNames',mod_names, 'RowNames', r_names );
            %fprintf( fid, '%s\n', T1 );
            %fprintf( fid, '%s\n', T2 );
            fprintf(fid,"normal MSEs:\n");
            writetable(T1,filename,'Delimiter','\t','WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append');
            fprintf(fid,"percentage values(1/4 MSE):\n");
            writetable(T2,filename,'Delimiter','\t','WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append');
        end
        temptext= "------------statistics"+"---\n";
        fprintf( fid, temptext );
        temptext= "------------averages"+"---\n";
        fprintf( fid, temptext );
        T1 = table(averages_all(1,:,i).',averages(1,:,1,i).',averages(1,:,2,i).',averages(1,:,3,i).',averages(1,:,4,i).',averages(1,:,5,i).','VariableNames',mod_names, 'RowNames', r_names );   
        T2 = table(averages_all(2,:,i).',averages(2,:,1,i).',averages(2,:,2,i).',averages(2,:,3,i).',averages(2,:,4,i).',averages(2,:,5,i).','VariableNames',mod_names, 'RowNames', r_names );
        fprintf(fid,"normal MSEs:\n");
        writetable(T1,filename,'Delimiter','\t','WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append');
        fprintf(fid,"percentage values(1/4 MSE):\n");
        writetable(T2,filename,'Delimiter','\t','WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append');
        temptext= "------------variances"+"---\n";
        fprintf( fid, temptext );
        T1 = table(variances_all(1,:,i).',variances(1,:,1,i).',variances(1,:,2,i).',variances(1,:,3,i).',variances(1,:,4,i).',variances(1,:,5,i).','VariableNames',mod_names, 'RowNames', r_names );   
        T2 = table(variances_all(2,:,i).',variances(2,:,1,i).',variances(2,:,2,i).',variances(2,:,3,i).',variances(2,:,4,i).',variances(2,:,5,i).','VariableNames',mod_names, 'RowNames', r_names );
        fprintf(fid,"normal MSEs:\n");
        writetable(T1,filename,'Delimiter','\t','WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append');
        fprintf(fid,"percentage values(1/4 MSE):\n");
        writetable(T2,filename,'Delimiter','\t','WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append');
        temptext= "------------stdevs"+"---\n";
        fprintf( fid, temptext );
        T1 = table(stdevs_all(1,:,i).',stdevs(1,:,1,i).',stdevs(1,:,2,i).',stdevs(1,:,3,i).',stdevs(1,:,4,i).',stdevs(1,:,5,i).','VariableNames',mod_names, 'RowNames', r_names );   
        T2 = table(stdevs_all(2,:,i).',stdevs(2,:,1,i).',stdevs(2,:,2,i).',stdevs(2,:,3,i).',stdevs(2,:,4,i).',stdevs(2,:,5,i).','VariableNames',mod_names, 'RowNames', r_names );
        fprintf(fid,"normal MSEs:\n");
        writetable(T1,filename,'Delimiter','\t','WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append');
        fprintf(fid,"percentage values(1/4 MSE):\n");
        writetable(T2,filename,'Delimiter','\t','WriteVariableNames',true,'WriteRowNames',true,'WriteMode','append');
        
    end
    fclose(fid);
    disp('file closed\n')
end




%%% Graphic plotting, TODO: Plot for each run??

if write_barplots
    picture_dir = 'graphics';
    %create folder structure if it doesnt already exists
    if ~exist(picture_dir, 'dir')
       mkdir(picture_dir)
       mkdir([picture_dir '/1'])
       mkdir([picture_dir '/2'])
       mkdir([picture_dir '/3'])
       mkdir([picture_dir '/4'])
    end
    
    
    for test_case = 1:4
        if ~exist([picture_dir '/' int2str(test_case)], 'dir')
            mkdir([picture_dir '/' int2str(test_case)])
        end
        y0= reshape(averages_all(2,test_case,:),[],1);
        y1= reshape(averages(2,test_case,1,:),[],1);
        y2= reshape(averages(2,test_case,2,:),[],1);
        y3= reshape(averages(2,test_case,3,:),[],1);
        y4= reshape(averages(2,test_case,4,:),[],1);
        y5= reshape(averages(2,test_case,5,:),[],1);
        y= [y1 y2 y3 y4 y5];
        labels= categorical({'Without Joint Positions', 'Without Visual Psoitions','Without Touch','Without Sound', 'Without Motor Commands', 'With all'});
        labels= reordercats(labels,{'Without Joint Positions', 'Without Visual Psoitions','Without Touch','Without Sound', 'Without Motor Commands', 'With all'});
        b=bar(labels,y,'FaceColor','flat');
        l = cell(1,5);
        l{1}='Joint Positions'; l{2}='Visiual Positions'; l{3}='Touch'; l{4}='Sound'; l{5}='Motor Commands';    
        legend(b,l,'Location','northeastoutside');
        
        saveas(gcf,[picture_dir '/' int2str(test_case) '/AllModalities.png']);
        
        bar(labels,y1);
        hold on
        errlow = reshape(stdevs(2,test_case,1,:),[],1);
        errhigh = reshape(stdevs(2,test_case,1,:),[],1);
        er = errorbar(1:6,y1,errlow,errhigh);
        er.Color = [0 0 0];                            
        er.LineStyle = 'none';  
        
        hold off
        
        saveas(gcf,[picture_dir '/' int2str(test_case) '/JointPositions.png']);
       
        bar(labels,y2,'FaceColor', [0.8500 0.3250 0.0980]);
        hold on
        errlow = reshape(stdevs(2,test_case,2,:),[],1);
        errhigh = reshape(stdevs(2,test_case,2,:),[],1);
        er = errorbar(1:6,y2,errlow,errhigh);
        er.Color = [0 0 0];                            
        er.LineStyle = 'none';  
        
        hold off
        
        saveas(gcf,[picture_dir '/' int2str(test_case) '/VisualPositions.png']);
        
        bar(labels,y3,'FaceColor', [0.9290 0.6940 0.1250]);
        hold on
        errlow = reshape(stdevs(2,test_case,3,:),[],1);
        errhigh = reshape(stdevs(2,test_case,3,:),[],1);
        er = errorbar(1:6,y3,errlow,errhigh);
        er.Color = [0 0 0];                            
        er.LineStyle = 'none';  
        
        hold off
        
        saveas(gcf,[picture_dir '/' int2str(test_case) '/Touch.png']);
        
        bar(labels,y4,'FaceColor', [0.4940 0.1840 0.5560]);
        hold on
        errlow = reshape(stdevs(2,test_case,4,:),[],1);
        errhigh = reshape(stdevs(2,test_case,4,:),[],1);
        er = errorbar(1:6,y4,errlow,errhigh);
        er.Color = [0 0 0];                            
        er.LineStyle = 'none';  
        
        hold off
       
        saveas(gcf,[picture_dir '/' int2str(test_case)  '/Sound.png']);
       
        bar(labels,y5,'FaceColor', [0.4660 0.6740 0.1880]);
        hold on
        errlow = reshape(stdevs(2,test_case,5,:),[],1);
        errhigh = reshape(stdevs(2,test_case,5,:),[],1);
        er = errorbar(1:6,y5,errlow,errhigh);
        er.Color = [0 0 0];                            
        er.LineStyle = 'none';  
        
        hold off
        
        saveas(gcf,[picture_dir '/' int2str(test_case) '/MotorCommands.png']);
        
    end
end

    




%run_names
%disp('-------- case_based ---------')
%results(:,:,1)
%results_per_modality(:,:,:,1)
%disp('-------- googledoc_based ---------')
%results_gdoc
%table(run_names', results, results_gdoc)


%Qresults = quantile(results,[.05 .25 .50 .75 .95],3)
%Qresults_gdoc = quantile(results_gdoc,[.05 .25 .50 .75 .95],3)