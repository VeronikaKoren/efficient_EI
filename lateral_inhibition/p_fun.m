function [fe,fi,xhat_e,xhat_i,re,ri] = p_fun(dt,sigmav,beta,tau_vec,s,w,J,cn,int_stim,Ap)
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
%Jee=J{1};
Jii=J{2};
Jie=J{3};
Jei=J{4};

threse=diag(w{1}'*w{1})/2+beta/2;            % firing threshold E neurons
thresi=diag(w{2}'*w{2})/2+beta/2;            % firing threshold I neurons

%% to speed up the integration

leak_pfe=1-lambda_e*dt;   % for leak current in E  
leak_pfi=1-lambda_i*dt;   % for leak current in I

leak_re=(1-lambda_re*dt); % for leak term of the r_e(t)
leak_ri=(1-lambda_ri*dt); % for leak term of r_i(t)
leak_xhe=(1-lambda_e*dt); % leak term of xhat_e(t)
leak_xhi=(1-lambda_i*dt); % leak term of xhat_i(t)

De=sigmav*sqrt((2*dt)/tau_vec(2)); % noise prefactor E neurons
Di=sigmav*sqrt((2*dt)/tau_vec(3)); % noise prefactor I neurons

noise_e=De.*randn(N,T);
noise_i=Di.*randn(Ni,T);

beta_pfe=beta*(lambda_e-lambda_re);
beta_pfi=beta*(lambda_i-lambda_ri);

ffe=w{1}'*s*dt;

%% perturb 1 neuron by giving to it a superthreshold current for a short time between t=on and t=off

ffe(cn,int_stim)=threse(cn)*Ap*dt;  % perturbation of the ff current in the neuron cn

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
    
    %%%% excitatory and inhibitory neurons
    Ve(:,t+1)=leak_pfe*Ve(:,t)+ ffe(:,t) - Jei*fi(:,t) - beta_pfe*re(:,t)- beta.*fe(:,t) + noise_e(:,t);
    Vi(:,t+1)=leak_pfi*Vi(:,t) + Jie*fe(:,t) - Jii*fi(:,t) - beta_pfi*ri(:,t)-beta*fi(:,t)+ noise_i(:,t);
    
    %% spike train
    
    activation=Ve(:,t+1)>threse; 
    if sum(activation)>0
        fe(:,t+1)=activation;
    end
    
    activation_i=Vi(:,t+1)>thresi; 
    if sum(activation_i)>0
        fi(:,t+1)=activation_i;
    end
    
    re(:,t+1)=leak_re*re(:,t)+fe(:,t);                 % firing rate E
    xhat_e(:,t+1)=leak_xhe*xhat_e(:,t)+w{1}*fe(:,t+1);   % estimate E  
    
    ri(:,t+1)=leak_ri*ri(:,t)+fi(:,t);                 % firing rate I
    xhat_i(:,t+1)=leak_xhi*xhat_i(:,t)+w{2}*fi(:,t+1);   % estimate I
    
end

fi=int8(fi);
fe=int8(fe);


end
