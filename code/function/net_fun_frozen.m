function [ye,yi,xhat_e,xhat_i,fe,fi] = net_fun_frozen(dt,sigmav,beta,tau_vec,s,w,J,xi_e,xi_i)
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

noise_e=De.*xi_e;
noise_i=Di.*xi_i;


loc_e=beta*(lambda_e-lambda_re);
loc_i=beta*(lambda_i-lambda_ri);

ffe=w{1}'*s*dt;

%% integration

Ve=zeros(N,T);      % membrane potential
ye=zeros(N,T);      % spike train
fe=zeros(N,T);      % filtered spike train
xhat_e=zeros(M,T);  % excitatory estimate

Vi=zeros(Ni,T);      % same for I neurons
yi=zeros(Ni,T);
fi=zeros(Ni,T);
xhat_i=zeros(M,T);

Ve(:,1)=randn(N,1)*3-10;  % initialization with random membrane potentials E
Vi(:,1)=randn(Ni,1)*3-10;  % I
display(Ve(1:5,1),'initial conditions sample')

for t=1:T-1
    
    %%%% excitatory neurons
    Ve(:,t+1)=l_e*Ve(:,t)+ ffe(:,t) - Jei*yi(:,t) - loc_e*fe(:,t)- beta.*ye(:,t) + noise_e(:,t);
    
    %%% inhibitory neurons
    Vi(:,t+1)=l_i*Vi(:,t) + Jie*ye(:,t) - Jii*yi(:,t) - loc_i*fi(:,t)-beta*yi(:,t)+ noise_i(:,t);  
    
    a=Ve(:,t+1)>threse; 
    if sum(a)>0
        ye(:,t+1)=a;
    end
    
    a_i=Vi(:,t+1)>thresi; 
    if sum(a_i)>0
        yi(:,t+1)=a_i;
    end
    
    fe(:,t+1)=l_fe*fe(:,t)+ye(:,t);                 % firing rate E
    xhat_e(:,t+1)=l_xe*xhat_e(:,t)+w{1}*ye(:,t+1);   % estimate E  
    
    fi(:,t+1)=l_fi*fi(:,t)+yi(:,t);                 % firing rate I
    xhat_i(:,t+1)=l_xi*xhat_i(:,t)+w{2}*yi(:,t+1);   % estimate I
    
end

yi=int8(yi);
ye=int8(ye);


end
