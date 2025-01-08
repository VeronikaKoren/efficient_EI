%% computes the pairwise correlation of membrane potentials and tuning similarity
% for the optimal network and the network where each neuron gets an
% intependent feedforward input

close all
clear
clc

%format long
addpath([cd,'/code/function/'])
saveres=0;
showfig=1;

type=2;
namet={'normal','independent'};
display(['correlations of V(t) as a function of tuning similarity for input type ',namet{type}])

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=10;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
beta=14;                           % quadratic cost constant
sigmav=5;                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
q=4;
d=3;

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% set weights

[w,J] = w_fun(M,N,q,d);
dp = dot_prod_fun(w);

%% simulate network activity
mu_s=0;
[Vmm,Vstd,frate,rVm] = net_fun_V2(dt,sigmav,beta,tau_vec,w,J,type,nsec,tau_s,mu_s);

%%

if showfig==1
    figure('units','centimeters','Position',[0,0,46,24])
    for k=1:2
        x=dp{k};
        y=rVm{k};
        R=corr(x,y);
        
        subplot(1,2,k)
        plot(x,y,'.','markersize',3)
        grid on
        line([min(x),max(x)],[0,0],'Color','r')
        ylim([-1,1])
        xlabel('tuning similarity')
        if k==1
            ylabel('Pearson correlation Vm')
        end
        
    end
end
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec}};
    
    savefile='result/statistics/Vm/';
    savename=['corr_Vm_',namet{type}];
    save([savefile,savename],'dp','rVm','parameters','param_name') 
end

