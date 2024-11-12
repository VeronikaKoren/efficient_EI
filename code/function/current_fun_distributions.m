function [Ie,Ii,re,ri,CVe,CVi,fre,fri,kappa] = current_fun_distributions(dt,sigmav,beta,tau_vec,s,N,q,d)
% compute performance measures, CV and E-I balance measures

M=size(s,1);
T=size(s,2);

lambda_e=1/tau_vec(2);
lambda_i=1/tau_vec(3);
lambda_re=1/tau_vec(4);
lambda_ri=1/tau_vec(5);

delta_e=lambda_e-lambda_re;            % in front of homeostatic current in E 
delta_i=lambda_i-lambda_ri;            % in I 

%% selectivity w and synaptic weights J

[w,J] = w_fun(M,N,q,d);
Ni=round(N/q);
%%

Jii=J{2};
Jie=J{3};
Jei=J{4};

threse=diag(w{1}'*w{1})/2+beta/2;            % firing threshold E neurons
thresi=diag(w{2}'*w{2})/2+beta/2;            % firing threshold I neurons

%% precompute to speed up the integration

leak_pfe=1-lambda_e*dt;   % for leak current in E  
leak_pfi=1-lambda_i*dt;   % for leak current in I

De=sigmav*sqrt((2*dt)/tau_vec(2)); % noise prefactor E neurons
Di=sigmav*sqrt((2*dt)/tau_vec(3)); % noise prefactor I neurons

noise_e=De.*randn(N,T);
noise_i=Di.*randn(Ni,T);

alpha_e=beta*delta_e;
alpha_i=beta*delta_i;

ffe=w{1}'*s*dt;

%% integration

Ve=zeros(N,T);              % membrane potential
fe=zeros(N,T);              % spike train
re=zeros(N,T);              % filtered spike train
xhat_e=zeros(M,T);          % excitatory estimate
Iei=zeros(N,T);             % current from I to E neurons

Vi=zeros(Ni,T);             % same for I neurons
fi=zeros(Ni,T);
ri=zeros(Ni,T);
xhat_i=zeros(M,T);
Iie=zeros(Ni,T);             % current from E to I neurons
Iii=zeros(Ni,T);             % current from I to I neurons

Ve(:,1)=randn(N,1)*3-10;    % initialization with random membrane potentials E
Vi(:,1)=randn(Ni,1)*3-10;   % I

for t=1:T-1
    
    %% excitatory neurons
   
    Ve(:,t+1)=leak_pfe*Ve(:,t)+ ffe(:,t) - Jei*fi(:,t) - alpha_e*re(:,t)- beta.*fe(:,t) + noise_e(:,t);
    Iei(:,t+1)= - Jei*fi(:,t);    
    %% inhibitory neurons
    
    Vi(:,t+1)=leak_pfi*Vi(:,t) + Jie*fe(:,t) - Jii*fi(:,t) - alpha_i*ri(:,t)-beta*fi(:,t)+ noise_i(:,t);
    Iie(:,t+1)=Jie*fe(:,t);
    Iii(:,t+1)=- Jii*fi(:,t); 
    
    activation=Ve(:,t+1)>threse; 
    if sum(activation)>0
        fe(:,t+1)=activation;
    end
    
    activation_i=Vi(:,t+1)>thresi; 
    if sum(activation_i)>0
        fi(:,t+1)=activation_i;
    end
    
    re(:,t+1)=(1-lambda_re*dt)*re(:,t)+fe(:,t);                 % low-pass filtered spikes 
    xhat_e(:,t+1)=(1-lambda_e*dt)*xhat_e(:,t)+w{1}*fe(:,t+1);   % estimate 
    
    ri(:,t+1)=(1-lambda_ri*dt)*ri(:,t)+fi(:,t);                 
    xhat_i(:,t+1)=(1-lambda_i*dt)*xhat_i(:,t)+w{2}*fi(:,t+1);   
    
end

%% measures (average across time but not across neurons)

nsec=T*dt/1000;
fre=sum(fe,2)./nsec;
fri=sum(fi,2)./nsec;

%%
ff=w{1}'*s;         % feed-forward current
ff_neur=mean(ff,2); % average across time
I_ei=mean(Iei,2)./dt; % inhibitory current in E neurons


I_ii=mean(Iii,2)./dt; % inhibitory current in I neurons
I_ie=mean(Iie,2)./dt; % excitatory current in I neurons

Ie=cat(2,ff_neur,I_ei);              % currents in E neurons [ff, Inh]
Ii=cat(2,I_ie,I_ii);                 % currents in I neurons [Exc, Inh]  

%% temporal correlation of E and I currents 

[~,re]=balance_ff_fun(ff,Iei,dt);   % in E neurons
[~,ri] = balance_fun(Iie,Iii,dt);   % in I neurons    

%% performance 
%[rmse,kappa] = performance_fun(x,xhat_e,xhat_i,re,ri);

%% Coefficient of variation

fe=int8(fe); % integer format
fi=int8(fi);

f1e=sum(reshape(fe,N,T*dt,1/dt),3); % bin the spike trains in 1ms bins
f1i=sum(reshape(fi,Ni,T*dt,1/dt),3);

[~,CVe,CVi] = cv_fun(f1e,f1i);


end
