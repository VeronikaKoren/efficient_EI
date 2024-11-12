function [xhat_e,xhat_i] = net_fun_unstructured(dt,sigmav,beta,tau_vec,s,N,q,d,f,type)


M=size(s,1);
T=size(s,2);

%lambda_x=1/tau_vec(1);
lambda_e=1/tau_vec(2);
lambda_i=1/tau_vec(3);
lambda_re=1/tau_vec(4);
lambda_ri=1/tau_vec(5);

delta_e=lambda_e-lambda_re;            % in front of homeostatic current in E 
delta_i=lambda_i-lambda_ri;            % in I 

%% weights and connectivity matrices

if type==1
    [w,J] = w_perturbation_fun(M,N,q,d,f);
elseif or(type==2,type==3)
    [w,J] = w_structure_fun(M,N,q,d,type,f);
end
Ni=round(N./q);

%% connectivity matrices

Jii=J{2};
Jie=J{3};
Jei=J{4};
    
threse=diag(w{1}'*w{1})/2+beta/2;            % firing threshold E neurons
thresi=diag(w{2}'*w{2})/2+beta/2;            % firing threshold I neurons

%% to speed up the integration

leak_pfe=1-lambda_e*dt;   % for leak current in E  
leak_pfi=1-lambda_i*dt;   % for leak current in I

De=sigmav*sqrt((2*dt)/tau_vec(2)); % noise prefactor E neurons
Di=sigmav*sqrt((2*dt)/tau_vec(3)); % noise prefactor I neurons

noise_e=De.*randn(N,T);
noise_i=Di.*randn(Ni,T);

beta_pfe=beta*delta_e;
beta_pfi=beta*delta_i;

ffe=w{1}'*s*dt;

%%    

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
    Ve(:,t+1)=leak_pfe*Ve(:,t)+ ffe(:,t) - Jei*fi(:,t) - beta_pfe*re(:,t)- beta.*fe(:,t) + noise_e(:,t);
      
    %% inhibitory neurons
    Vi(:,t+1)=leak_pfi*Vi(:,t) + Jie*fe(:,t) - Jii*fi(:,t) - beta_pfi*ri(:,t)-beta*fi(:,t)+ noise_i(:,t);
       
    activation=Ve(:,t+1)>threse;
    if sum(activation)>0
        fe(:,t+1)=activation;
    end
    
    activation_i=Vi(:,t+1)>thresi;
    if sum(activation_i)>0
        fi(:,t+1)=activation_i;
    end
    
    %re(:,t+1)=(1-lambda_re*dt)*re(:,t)+ye(:,t);                 % firing rate E
    xhat_e(:,t+1)=(1-lambda_e*dt)*xhat_e(:,t)+w{1}*fe(:,t+1);   % estimate E
    
    %ri(:,t+1)=(1-lambda_ri*dt)*ri(:,t)+yi(:,t);                 % firing rate I
    xhat_i(:,t+1)=(1-lambda_i*dt)*xhat_i(:,t)+w{2}*fi(:,t+1);   % estimate I
    
end




end