
% computes measures of performance  and dynamics as a
% function of time constants of single neuron readout of E and I neurons (tau_re and tau_ri)
% two-dimensional parameter search

% measures of performance: error, cost
% measures of dynamics: firing rate,
% coefficient of variation, instantaneous and average E-I balance


close all
clear
clc

saveres=0;
showfig=0;

disp('computing balance measures as a function of the adaptation current in E and I neurons')

addpath('code/function/')
%% parameters

nsec=1;                                % duration of the trial in seconds   
dt=0.02;                               % time step in ms 

M=3;                                   % number of input variables (stimulus features) 
N=400;                                 % number of E neurons                                  

sigma_s=2;                             % strength of the noise for defining the stimulus features (OU processes)
tau_s=10;                              % time constant of the stimuls (OU process)
tau_x=10;                              % time constant of the target signal  

tau_e=10;                              % time constant of the excitatory estimate
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons
 
sigmav=5;
beta=14;

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity  

T=(nsec*1000)./dt;

%% simulate network activity

tic
ntr=100;
variable=[5:0.5:10,11:20,25,30:10:100,200]; 
n=length(variable);

rms=zeros(n,n,2);
cost=zeros(n,n,2);

frate=zeros(n,n,2);
CVs=zeros(n,n,2);

r_ei=zeros(n,n,2);
meanE=zeros(n,n,2);
meanI=zeros(n,n,2);

delta=zeros(n,2);     % difference of time constants

for g=1:n
    
    disp(n-g)
    tau_re=variable(g);               
    delta(g,1)=(1/tau_e) - (1/tau_re);
    
    for h=1:n
        
        tau_ri=variable(h);
        if g==1
            delta(h,2)=(1/tau_i) - (1/tau_ri);
        end
        
        tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
        
        rms_tr=zeros(ntr,2);
        cost_tr=zeros(ntr,2);

        frate_tr=zeros(ntr,2);
        CV_tr=zeros(ntr,2);

        currE_tr=zeros(ntr,2);
        currI_tr=zeros(ntr,2);
        r_tr=zeros(ntr,2);
        
        for ii=1:ntr

            [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
            [I_E,I_I,r,rmse,kappa,CV,fr] = current_fun(dt,sigmav,beta,tau_vec,s,N,q,d,x);
            
            rms_tr(ii,:)=rmse;
            cost_tr(ii,:)=kappa;
            
            CV_tr(ii,:)=CV;
            frate_tr(ii,:)=fr;
            
            r_tr(ii,:)=r;
            currE_tr(ii,:)=I_E;
            currI_tr(ii,:)=I_I;
            
        end
        
        rms(g,h,:)=mean(rms_tr);
        cost(g,h,:)=mean(cost_tr);
        
        frate(g,h,:)=mean(frate_tr);
        CVs(g,h,:)=mean(CV_tr);
        
        r_ei(g,h,:)=mean(r_tr);
        meanE(g,h,:)=mean(currE_tr);
        meanI(g,h,:)=mean(currI_tr);
        
    end
    
end
toc
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'d'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{q},{d},{dt},{nsec},{ntr}};
    
    savename='adaptation_2d_measures';
    savefile='result/adaptation/';
    save([savefile,savename],'delta','variable','frate','CVs','rms','cost','r_ei','meanE','meanI','parameters','param_name')
    
end

%%

if showfig==1
    
    rmse_tot= (rms(:,:,1) + rms(:,:,2))./2;
    cost_tot=(cost(:,:,1)+cost(:,:,2))./2;
    netE=squeeze(sum(meanE,3));
    netI=squeeze(sum(meanI,3));
     
    H=figure('units','centimeters','Position',[0,0,28,32]);
    subplot(3,2,1)
    imagesc(variable,variable,log(rms(:,:,1)))
    %set(gca,'YScale','log')
    %set(gca,'XScale','log')
    %xlabel('\tau_r^E')
    ylabel('\tau_r^I')
    colorbar
    title('encoding error')
    
    subplot(3,2,2)
    imagesc(variable,variable,log(cost_tot))
    colorbar
    title('metabolic cost')
    
    subplot(3,2,3)
    imagesc(variable,variable,netE)
    ylabel('\tau_r^I')
    colorbar
    title('net syn. current in E')
    
    subplot(3,2,4)
    imagesc(variable,variable,netI)
    colorbar
    title('net syn. current in I')

    subplot(3,2,5)
    imagesc(variable,variable,r_ei(:,:,1))
    xlabel('\tau_r^E')
    ylabel('\tau_r^I')
    colorbar
    title('correlation of syn. currents in E')
    
    subplot(3,2,6)
    imagesc(variable,variable,r_ei(:,:,2))
    colorbar
    xlabel('\tau_r^E')
    title('correlation of syn. currents in I')
    
end


