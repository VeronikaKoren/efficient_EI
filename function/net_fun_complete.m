function [fe,fi,xhat_e,xhat_i,re,ri] = net_fun_complete(dt,sigmav,beta,tau_vec,s,w,J)
% integration of the membrane potential for E and I neurons


M=size(s,1);
T=size(s,2);
N=size(w{1},2);
Ni=size(w{2},2);

lambda_e=1/tau_vec(2);
lambda_i=1/tau_vec(3);
lambda_re=1/tau_vec(4);
lambda_ri=1/tau_vec(5);

%%

Jii=J{2};
Jie=J{3};
Jei=J{4};

threse=diag(w{1}'*w{1})/2+beta/2;            % firing threshold E neurons
thresi=diag(w{2}'*w{2})/2+beta/2;            % firing threshold I neurons

%% to speed up the integration

l_e=1-lambda_e*dt;   % for leak current in E  
l_i=1-lambda_i*dt;   % for leak current in I
l_fe=1-lambda_re*dt;
l_xe=1-lambda_e*dt;
l_fi=1-lambda_ri*dt;
l_xi=1-lambda_i*dt;

De=sigmav*sqrt((2*dt)/tau_vec(2)); % noise prefactor E neurons
Di=sigmav*sqrt((2*dt)/tau_vec(3)); % noise prefactor I neurons

noise_e=De.*randn(N,T);
noise_i=Di.*randn(Ni,T);

loc_e=beta*(lambda_e-lambda_re);
loc_i=beta*(lambda_i-lambda_ri);

ffe=w{1}'*s*dt;

%% integration

Ve=zeros(N,T);      % membrane potential
fe=zeros(N,T);      % spike train
re=zeros(N,T);      % filtered spike train
xhat_e=zeros(M,T);  % excitatory estimate

Vi=zeros(Ni,T);      % same for I neurons
fi=zeros(Ni,T);
ri=zeros(Ni,T);
xhat_i=zeros(M,T);

Ve(:,1)=randn(N,1)*3-10;  % initialization with random membrane potentials E
Vi(:,1)=randn(Ni,1)*3-10;  % I

for t=1:T-1
    
    %%%% excitatory neurons
    Ve(:,t+1)=l_e*Ve(:,t)+ ffe(:,t) - Jei*fi(:,t) - loc_e*re(:,t)- beta.*fe(:,t) + noise_e(:,t);
    
    %%% inhibitory neurons
    Vi(:,t+1)=l_i*Vi(:,t) + Jie*fe(:,t) - Jii*fi(:,t) - loc_i*ri(:,t)-beta*fi(:,t)+ noise_i(:,t);  
    
    a=Ve(:,t+1)>threse; 
    if sum(a)>0
        fe(:,t+1)=a;
    end
    
    a_i=Vi(:,t+1)>thresi; 
    if sum(a_i)>0
        fi(:,t+1)=a_i;
    end
    
    re(:,t+1)=l_fe*re(:,t)+fe(:,t);                 % firing rate E
    xhat_e(:,t+1)=l_xe*xhat_e(:,t)+w{1}*fe(:,t+1);   % estimate E  
    
    ri(:,t+1)=l_fi*ri(:,t)+fi(:,t);                 % firing rate I
    xhat_i(:,t+1)=l_xi*xhat_i(:,t)+w{2}*fi(:,t+1);   % estimate I
    
end

fi=int8(fi);
fe=int8(fe);


end
