
clear all
close all

computing=0;   % testing or computing?

if computing ==1
    saveres=1;
    showfig=0;
    disp('computing measures as a function of beta and sigma (2D grid search)');
else
    saveres=0;
    showfig=1;
    disp('testing measures as a function of beta and sigma (2D grid search)');
end

%% parameters

nsec=1;                               % duration of the trial in seconds   
dt=0.02;                               % time step in ms 

M=3; 
N=400;                                 % number of E neurons                                  

sigma_s=2;                             % sigma of the stimulus (OU process)
tau_s=10;                              % time constant of the stimuls (OU process)
tau_x=10;                              % time constant of the target signal  

tau_e=10;                              % time constant of the excitatory estimate
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
    
q=4;                                   % ratio of weight amplitudes I to E 
d=3;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
%%

addpath([cd,'/function/'])

%% compute measures
if computing==0
    ntr=2;
    beta_vec=[0,12];
    sigma_vec=0:5;

else
    ntr=50;
    beta_vec=0:2:36;
    sigma_vec=0:1:25;
end
%}
n1=length(beta_vec);
n2=length(sigma_vec);

rms=zeros(n1,n2,2);
cost=zeros(n1,n2,2);

frate=zeros(n1,n2,2);
CVs=zeros(n1,n2,2);

r_ei=zeros(n1,n2,2);
meanE=zeros(n1,n2,2);
meanI=zeros(n1,n2,2);

tic
for g=1:n1
    disp(n1-g+1);
    
    beta=beta_vec(g);

    for k=1:n2
        sigmav=sigma_vec(k);

        r_tr=zeros(ntr,2);
        currE_tr=zeros(ntr,2);
        currI_tr=zeros(ntr,2);

        fr_tr=zeros(ntr,2);
        CV_tr=zeros(ntr,2);

        rmse_tr=zeros(ntr,2);
        kappa_tr=zeros(ntr,2);

        for ii=1:ntr
            [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
           
            [I_E,I_I,r,rmse,kappa,CV,fr] = current_fun(dt,sigmav,beta,tau_vec,s,N,q,d,x);

            rmse_tr(ii,:)=rmse;
            kappa_tr(ii,:)=kappa;

            currE_tr(ii,:)=I_E;
            currI_tr(ii,:)=I_I;
            r_tr(ii,:)=r;

            CV_tr(ii,:)=CV;
            fr_tr(ii,:)=fr;

        end

        rms(g,k,:)=mean(rmse_tr);
        cost(g,k,:)=mean(kappa_tr);

        frate(g,k,:)=mean(fr_tr);
        CVs(g,k,:)=mean(CV_tr);

        r_ei(g,k,:)=mean(r_tr);
        meanE(g,k,:)=mean(currE_tr);
        meanI(g,k,:)=mean(currI_tr);

    end

end
toc
%%

if saveres==1
    %%
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigma'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{},{},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile=[cd,'/result/beta_sigma/'];
    savename='measures_beta_sigma';
    save([savefile,savename],'beta_vec','sigma_vec','rms','cost','frate','CVs','meanE','meanI','r_ei','parameters','param_name')
    disp('saved result')
end

%%

if showfig==1

    g_l=0.7;
    lossvar=log((g_l*mean(rms,3)) + ((1-g_l)*mean(cost,3)));

    figure('units','centimeters','position',[0,0,16,16])
    imagesc(beta_vec,sigma_vec,lossvar)
    axis xy
    axis square

    colorbar;
    xlabel('beta')
    ylabel('sigma')
    
end
%%

