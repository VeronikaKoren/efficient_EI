
%close all
clear all
clc

addpath('code/function/')
saveres=0;
showfig=1;

disp('computing balance measures 2D as a function of the local current')

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=10;                               % duration of the trial in seconds 

tau_s=10;
tau_x=10;
tau_e=10;                             
tau_i=10;                          

b=1;
c=33;
mu=b*log(N);                           % quadratic cost
sigmav=c/log(N);                       % standard deviation of the noise

q=4;                                   % ratio E to I 
d=3;
dt=0.02;                               % time step in ms  

T=(nsec*1000)./dt;
[s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);

%% simulate network activity

tic
variable=[5:0.5:10,11:20,25,30:10:100,200:100:500]; 
%variable=[5,10,50];
nit=length(variable);

MSE=zeros(nit,nit,2);   % mean squared error
ratio=zeros(nit,nit,2);
bias=zeros(nit,nit,2);
cost=zeros(nit,nit,2); % cost

r=cell(nit,nit);        % temporal correlation of E-I currents
eif=cell(nit,nit,3);      % average E, I and FF current to single inh. neuron 



beta=zeros(nit,2);     % difference of time constants

for jj=1:nit
    
    disp(nit-jj)
    tau_re=variable(jj);               
    beta(jj,1)=(1/tau_e) - (1/tau_re);
    
    for kk=1:nit
        
        tau_ri=variable(kk);               
        if jj==1
            beta(kk,2)=(1/tau_i) - (1/tau_ri);
        end
        
        tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
        
        %% network simulation
        [r,mean_eiff,cost,ms,ratio,bias,CV,fr] = current_fun2(dt,sigmav,mu,tau_vec,s,N,q,d,x);
        
        %% measures
        
        r{jj,kk}=rcurr;
        eif{jj,kk}=eiff;
        
        netsum(jj,kk,:)=Imean;
        netstd(jj,kk,:)=Istd;
        
        MSE(jj,kk,1)=mse;                           
        MSE(jj,kk,2)=msi; 
        
        cost(jj,kk,1)=kappae;              	      
        cost(jj,kk,2)=kappai;                        
        
    end
    
end
toc
%%

param_name={{'N'},{'M'},{'mu'},{'tau_vec:X,E,I,rE,rI'},{'sigmav'},{'dt'},{'nsec'},{'q'},{'tau_s'},{'b'},{'c'}};
parameters={{N},{M},{mu},{tau_vec},{sigmav},{dt},{nsec},{q},{tau_s},{b},{c}};

if saveres==1
    
    savename='balance_2d_local';
    savefile='result/balance/';
    save([savefile,savename],'r','eif','netsum','netstd','MSE','kappa','variable','beta','parameters','param_name')

end

%%

if showfig==1
    
    eps_e=log(MSE(:,:,1))./max(log(MSE(:,:,1)));
    eps_i=log(MSE(:,:,2))./max(log(MSE(:,:,2)));
    eps_tot= (eps_e + eps_i)./2;
    
    rho=cellfun(@mean, r);
     
    H=figure('units','centimeters','Position',[0,0,28,20]);
    subplot(2,2,1)
    imagesc(beta(:,1),beta(:,2),eps_tot)
    xlabel('\beta^E')
    ylabel('\beta^I')
    colorbar
    title('coding error')
    
    subplot(2,2,2)
    imagesc(beta(:,1),beta(:,2),rho)
    xlabel('\beta^E')
    ylabel('\beta^I')
    colorbar
    title('correlation of E-I currents')
    
    subplot(2,2,3)
    imagesc(beta(:,1),beta(:,2),nanmean(netsum,3))
    xlabel('\beta^E')
    ylabel('\beta^I')
    colorbar
    title('mean net current')
    
    subplot(2,2,4)
    imagesc(beta(:,1),beta(:,2),nanstd(netsum,0,3))
    xlabel('\beta^E')
    ylabel('\beta^I')
    colorbar
    title('std net current')
    
end
%}

