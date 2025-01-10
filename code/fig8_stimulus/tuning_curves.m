
% computes the time-averaged firing rate for a set of M=3 constant stimuli
% the stimulus in the first dimension is changed from strongly negative to
% strongly positive, while the stimuli in dimensions 2 and 3 do not
% change

close all
clear
clc

saveres=0;
addpath([cd,'/code/function/'])
disp('tuning curves in E and I neurons')

%% parameters

nsec=1;                                % duration of the trial in seconds 
dt=0.02;                               % time step in ms 

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons       
 
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % time const single neuron readout in E neurons
tau_ri=10;                             % time const single neuron readout in I neurons 
   
beta=14;                               % metabolic constant
sigmav=5;                              % noise strength

q=4;                                   % E-I ratio
d=3;                                   % ratio of mean I-I to E-I connectivity 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

%% get decoding weights and recurrent connectivity

[w,J] = w_fun(M,N,q,d);

%% set the input

a_s=1.6;

T=(nsec*1000)./dt;
s=ones(M,T).*a_s;
Ni=N/q;

%% simulate network activity

ntr=100;
as1=-5:0.1:5;
ns=length(as1);

tuningE=zeros(ns,N);
tuningI=zeros(ns,Ni);
for k=1:ns
    disp(ns-k)

    s(1,:)=as1(k);
    sc_E=zeros(ntr,N);
    sc_I=zeros(ntr,Ni);
    for tr=1:ntr
        [fe,fi,xhat_e,xhat_i,re,ri] =net_fun_complete(dt,sigmav,beta,tau_vec,s,w,J);
        sc_E(tr,:)=sum(fe,2)./nsec;              
        sc_I(tr,:)=sum(fi,2)./nsec;
    end

    tuningE(k,:)=mean(sc_E);
    tuningI(k,:)=mean(sc_I);

end

% normalized with maximal firing rate for each neuron
maxi=max(tuningE,[],1);
tunE=tuningE./repmat(maxi,ns,1);

maxi=max(tuningI,[],1);
tunI=tuningI./repmat(maxi,ns,1);

%%
if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'beta'},{'sigmav'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{beta},{sigmav},{tau_vec},{q},{dt},{nsec},{ntr}};
    
    savefile='result/stimulus/';
    savename='tuning_curves';
    save([savefile,savename],'tuningE','tuningI','as1','a_s','tunE','tunI','parameters','param_name')

end

