
clear all


computing=1; % testing or computing?

if computing==1

    saveres=1;
    showfig=0;
    disp('computing measures as a function of ratios 2d');
else
    saveres=0;
    showfig=1;
end


%% parameters

M=3;                                   % number of input variables    
N=400;                                 % number of E neurons   
nsec=1;                                % duration of the trial in seconds 

sigma_s=2;
tau_s=10;
tau_x=10;                              % time constant of the signal  

tau_e=10;                              % time constant of the excitatory estimate  
tau_i=10;                              % time const I estimate 

tau_re=10;                             % t. const firing rate of E neurons
tau_ri=10;                             % t. constant firing rate of I neurons 
   
b=1;
c=33;
beta=b*log(N);                           % quadratic cost constant
sigmav=c/log(N);                       % standard deviation of the noise

dt=0.02;                               % time step in ms     
d=3.00;                                   % ratio of weight amplitudes I to E 

tau_vec=cat(1,tau_x,tau_e,tau_i,tau_re, tau_ri);

addpath([cd,'/code/function/'])
%% compute measures

if computing==0
    ntr=2;
    qvec=1:2:5;
    dvec=1:2:5;

else
    ntr=100;
    qvec=1:0.5:8;
    dvec=1:0.5:8;
end

n1=length(qvec);
n2=length(dvec);

rms=zeros(n1,n2,2);
cost=zeros(n1,n2,2);

frate=zeros(n1,n2,2);
CVs=zeros(n1,n2,2);

r_ei=zeros(n1,n2,2);
meanE=zeros(n1,n2,2);
meanI=zeros(n1,n2,2);

for g=1:n1
    %disp(n1-g)
    
    q=qvec(g)

    for k=1:n2
        d=dvec(k)

        r_tr=zeros(ntr,2);
        currE_tr=zeros(ntr,2);
        currI_tr=zeros(ntr,2);

        fr_tr=zeros(ntr,2);
        CV_tr=zeros(ntr,2);

        rmse_tr=zeros(ntr,2);
        kappa_tr=zeros(ntr,2);

        for ii=1:ntr

            [s,x]=signal_fun(tau_s,sigma_s,tau_x,M,nsec,dt);
            [I_E,I_I,r,rmse,kappa,CV,fr] = current_fun(dt,sigmav,beta,tau_vec,s,N,q,d,x);

            rmse_tr(ii,:)=rmse;
            kappa_tr(ii,:)=kappa;

            currE_tr(ii,:)=I_E;
            currI_tr(ii,:)=I_I;
            r_tr(ii,:)=r;

            CV_tr(ii,:)=CV;
            fr_tr(ii,:)=fr;

        end

        r_ei(g,k,:)=mean(r_tr);
        meanE(g,k,:)=mean(currE_tr);
        meanI(g,k,:)=mean(currI_tr);

        frate(g,k,:)=mean(fr_tr);
        CVs(g,k,:)=mean(CV_tr);

        rms(g,k,:)=mean(rmse_tr);
        cost(g,k,:)=mean(kappa_tr);

    end

end

%%
if saveres==1
    
    param_name={{'N'},{'M'},{'tau_s'},{'b'},{'c'},{'tau_vec:X,E,I,rE,rI'},{'q'},{'dt'},{'nsec'},{'ntrial'}};
    parameters={{N},{M},{tau_s},{b},{c},{tau_vec},{},{dt},{nsec},{ntr}};
    
    savefile='result/ratios/';
    savename='measures_q_d';
    save([savefile,savename],'qvec','dvec','frate','CVs','rms','cost','r_ei','meanE','meanI','parameters','param_name')
end


if showfig==1

    g_l=0.7;
    lossvar=log((g_l*mean(rms,3)) + ((1-g_l)*mean(cost,3)));

    figure('units','centimeters','position',[0,0,16,16])
    imagesc(qvec,dvec,lossvar)
    axis xy
    axis square

    colorbar;
    xlabel('N^E:N^I')
    ylabel('\sigma_w^I:\sigma_w^E')
    
end

