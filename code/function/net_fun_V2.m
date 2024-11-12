function [Vmm,Vstd,frate,rVm] = net_fun_V2(dt,sigmav,beta,tau_vec,w,J,typep,nsec,tau_s,mu_s)
% integration of the membrane potential for E and I neurons

format short
M=size(w{1},1);
T=(nsec*1000)./dt;

tau_x=tau_vec(1);
lambda_e=1/tau_vec(2);
lambda_i=1/tau_vec(3);
lambda_re=1/tau_vec(4);
lambda_ri=1/tau_vec(5);

delta_e=lambda_e-lambda_re;            % in front of local current in E 
delta_i=lambda_i-lambda_ri;            % in I 

N=size(w{1},2);
Ni=size(w{2},2);
%% weights

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

%%
sigma_s=2;
we=w{1};
if typep==1
    s=signal_mus_fun(tau_s,sigma_s,tau_x,M,nsec,dt,mu_s);
    ffe=we'*s*dt;

else
   
    B=((mu_s/tau_s).*dt)';
    D=sigma_s*sqrt((2*dt)/tau_s);
   
    lambda_s=1/tau_s;
    sp=single(zeros(N,M,T));
    for t=1:T-1
        sp(:,:,t+1)=(1-lambda_s*dt)*sp(:,:,t)+repmat(B,N,1) + D*randn(N,M); % independent O-U process for every neuron
    end

    ffe=zeros(N,T);
    for ii=1:N
        ffe(ii,:)=we(:,ii)'*squeeze(sp(ii,:,:)).*dt;
    end
end

%% integration

Ve=zeros(N,T);      % membrane potential
fe=zeros(N,T);      % spike train
re=zeros(N,T);      % filtered spike train

Vi=zeros(Ni,T);      % same for I neurons
fi=zeros(Ni,T);
ri=zeros(Ni,T);

Ve(:,1)=randn(N,1)*3-10;   % initialization with random membrane potentials E
Vi(:,1)=randn(Ni,1)*3-10;  % I

for t=1:T-1
    
    %%%% excitatory neurons
    Ve(:,t+1)=leak_pfe*Ve(:,t)+ ffe(:,t) - Jei*fi(:,t) - beta_pfe*re(:,t)- beta.*fe(:,t) + noise_e(:,t);
    %%%% inhibitory neurons
    Vi(:,t+1)=leak_pfi*Vi(:,t) + Jie*fe(:,t) - Jii*fi(:,t) - beta_pfi*ri(:,t)-beta*fi(:,t)+ noise_i(:,t);  
     
    activation=Ve(:,t+1)>threse; 
    if sum(activation)>0
        fe(:,t+1)=activation;
    end
    
    activation_i=Vi(:,t+1)>thresi; 
    if sum(activation_i)>0
        fi(:,t+1)=activation_i;
    end
    
    re(:,t+1)=(1-lambda_re*dt)*re(:,t)+fe(:,t);                 % firing rate E
    ri(:,t+1)=(1-lambda_ri*dt)*ri(:,t)+fi(:,t);                 % firing rate I
    
    
end

%% mean and STD of the Vm (average across neurons)

Vmm=zeros(2,1);
Vstd=zeros(2,1);
frate=zeros(2,1);

nsec=T*dt/1000;
frate(1)=sum(sum(fe))./(N*nsec);
frate(2)=sum(sum(fi))./(Ni*nsec);

Vmean_all=mean(Ve,2);       % mean across time
Vmm(1)=mean(Vmean_all);        % mean across neurons

Vstd_all=nanstd(Ve,0,2);
Vstd(1)=mean(Vstd_all);

Vmean_all_i=mean(Vi,2);       % mean across time
Vmm(2)=mean(Vmean_all_i);        % mean across neurons

Vstd_all_i=nanstd(Vi,0,2);
Vstd(2)=mean(Vstd_all_i);

%% correlation of membrane potentials

rVm=cell(2,1);
for k=1:2
    if k==1
        Y=1-eye(N);
        rVm{1}=nonzeros(tril(corr(Ve')).*Y);
    elseif k==2
        Y=1-eye(Ni);
        rVm{2}=nonzeros(tril(corr(Vi')).*Y);
    end
end

end
