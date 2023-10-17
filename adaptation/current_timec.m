
%close all
clear all
clc

addpath('code/function/')
saveres=1;
showfig=0;
cases=3;

namec={'recE','recI','localE','localI'};
disp(['computing balance measures as a function of the ',namec{cases},' current'])

%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the E estimate  
tau_i=10;                              % time constant of the I estimate

tau_re=10;                             % time constant of the spiking rate of E neurons 
tau_ri=10;                             % time constant of the spiking rate of I neurons

b=1;
c=33;
mu=b*log(N);                             % quadratic cost
sigmav=c/log(N);                       % standard deviation of the noise

q=4;                                   % ratio E to I 
dt=0.02;                               % time step in ms     

%% set the input

T=(nsec*1000)./dt;
[s,x]=signal_fun(tau_s,tau_x,M,nsec,dt);
Ni=N/q;
%% simulate network activity

tic
%variable=[5:20,25,30:10:100,200:100:500]; 
variable=[5,10,50,100];
nit=length(variable);

MSE=zeros(nit,2); 
kappa=zeros(nit,2);

r=cell(nit,1);          % correlation of E-I currents
netsum=zeros(nit,Ni);   % temporal average of the net current
netstd=zeros(nit,Ni);   % std of the net current
eif=cell(nit,1);        % average E, I and FF current

std_est=zeros(nit,2);    % std of the estimate
alphabeta=zeros(nit,1);

for jj=1:nit
    

    disp(nit-jj)
    if cases==1
        
        tau_x=variable(jj);               
        alphabeta(jj)=(1/tau_e) - (1/tau_x);
        
    elseif cases==2
        
        tau_i=variable(jj);
        tau_ri=tau_i;
        alphabeta(jj)=(1/tau_i) - (1/tau_e);
        
    elseif cases==3
        
        tau_re=variable(jj);               
        alphabeta(jj)=(1/tau_e) - (1/tau_re);
        
    elseif cases==4
        
        tau_ri=variable(jj);               
        alphabeta(jj)=(1/tau_i) - (1/tau_ri);
        
    end
    
    tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);
    
    %% network simulation
    
    [rcurr,Imean,Istd,eiff,kappae,kappai,mse,msi,std_xhat] = current_fun(dt,sigmav,mu,tau_vec,s,N,q,x);
    
    %% measures
    r{jj}=rcurr;
    eif{jj}=eiff;
    
    netsum(jj,:)=Imean;
    netstd(jj,:)=Istd;
    
    MSE(jj,1)=mse;                  % mean squared error
    MSE(jj,2)=msi; 
    kappa(jj,1)=kappae;              	% cost
    kappa(jj,2)=kappai;                        
    
    std_est(jj,:)=std_xhat;
    
end
toc
%%

if saveres==1
    
    param_name={{'N'},{'M'},{'mu'},{'tau_vec:X,E,I,rE,rI'},{'sigmav'},{'dt'},{'nsec'},{'q'},{'tau_s'},{'b'},{'c'}};
    parameters={{N},{M},{mu},{tau_vec},{sigmav},{dt},{nsec},{q},{tau_s},{b},{c}};
    
    savename=['current_',namec{cases}];
    savefile='result/balance/';
    save([savefile,savename],'r','eif','netsum','netstd','MSE','kappa','variable','alphabeta','parameters','param_name')

end

%%

if showfig==1
    
    errore=log(MSE(:,1));
    errori=log(MSE(:,2));
    
    dist_curr=cellfun(@(x) nanmean(x,2),eif,'un',0);
    y=cell2mat(dist_curr');
    
    col={'r','b',[0.7,0.4,0.1]};
    namea={'\alpha^E','\alpha^I','\beta^E','\beta^I'};
    
    H=figure('units','centimeters','Position',[0,0,24,24]);
    subplot(2,2,1)
    hold on
    plot(alphabeta,errore,'color','r');
    plot(alphabeta,errori,'color','b')
    hold off
    legend('\epsilon^E','\epsilon^I')
    ylabel('Mean squared error')
    box off
    
    subplot(2,2,2)
    plot(alphabeta,netsum,'k')
    ylabel('<c^E+c^I>')
    xlabel(namea{cases})
    box off
    
    subplot(2,2,3)
    plot(alphabeta,cellfun(@(x) nanmean(x),r),'color','k')
    ylabel('r(c^E,c^I)')
    box off
    xlabel(namea{cases})
    
    subplot(2,2,4)
    hold on
    for ii=1:3
        plot(alphabeta,y(ii,:),'color',col{ii})
    end
    hold off
    legend('E','I','FF','Location','SouthEast')
    xlabel(namea{cases})
    ylabel('current')
    
end
%}

